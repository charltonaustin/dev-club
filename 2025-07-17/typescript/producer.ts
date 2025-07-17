import {Kafka, logLevel} from "kafkajs";
import {generateAuthToken} from "aws-msk-iam-sasl-signer-js";

// Kafka configuration
const kafka = new Kafka({
    clientId: "simple-producer",
    brokers: ["boot-pieclbrb.c1.kafka-serverless.us-east-2.amazonaws.com:9098"],
    logLevel: logLevel.ERROR, // Reduce log verbosity
    ssl: true,
    sasl: {
        mechanism: "oauthbearer",
        oauthBearerProvider: async () => {
            const authTokenResponse = await generateAuthToken({
                region: "us-east-2",
            });
            return {
                value: authTokenResponse.token,
            };
        },
    },
});

const producer = kafka.producer();

async function publishMessage() {
    try {
        console.log("Connecting to Kafka...");
        await producer.connect();
        console.log("Connected successfully!");

        const topic = "command";
        const message = {
            key: "message-key-" + Date.now(),
            value: JSON.stringify({
                userId: Math.floor(Math.random() * 100),
                command: "pair",
                timestamp: new Date().toISOString(),
            }),
        };

        console.log(`Publishing message to topic: ${topic}`);
        console.log("Message:", message);

        await producer.send({
            topic,
            messages: [message],
        });

        console.log("Message published successfully!");
    } catch (error) {
        console.error("Error publishing message:", error);
    } finally {
        await producer.disconnect();
        console.log("Disconnected from Kafka");
    }
}

// Check if AWS credentials are set
if (
    !process.env.AWS_ACCESS_KEY_ID ||
    !process.env.AWS_SECRET_ACCESS_KEY ||
    !process.env.AWS_SESSION_TOKEN
) {
    console.error(
        "AWS credentials not found. Please run: source ../export_aws_creds.sh"
    );
    process.exit(1);
}

// Run the publisher
publishMessage().catch(console.error);
