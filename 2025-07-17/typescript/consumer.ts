import {Kafka, logLevel} from "kafkajs";
import {generateAuthToken} from "aws-msk-iam-sasl-signer-js";

// Kafka configuration
const kafka = new Kafka({
    clientId: "simple-consumer",
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

const consumer = kafka.consumer({
    groupId: "typescript-consumer-group-" + Date.now(),
    sessionTimeout: 30000,
    heartbeatInterval: 3000,
});

let users: string[] = []
const producer = kafka.producer();

async function consumeMessages() {
    try {
        console.log("Connecting to Kafka...");
        await consumer.connect();
        await producer.connect();
        console.log("Connected successfully!");

        const topic = "command";
        console.log(`Subscribing to topic: ${topic}`);
        await consumer.subscribe({topic, fromBeginning: false});

        console.log("Starting to consume messages...");
        console.log("Press Ctrl+C to stop consuming");

        await consumer.run({
            eachMessage: async ({topic, partition, message}) => {
                const value = message.value?.toString() || "null";
                // Try to parse JSON if possible
                try {
                    const jsonValue = JSON.parse(value);
                    let commandName = jsonValue["command"];
                    switch (commandName) {
                        case "join":
                            console.log("Parsed JSON:", JSON.stringify(jsonValue, null, 2));
                            users.push(jsonValue["userId"]);
                            break;
                        case "pair":
                            
                            let pairs:string[][] = []
                            while (users.length > 1) {
                                let user_1 = users.pop()
                                let user_2 = users.pop()

                                if (user_1 != undefined && user_2 != undefined) {
                                    pairs.push([user_1, user_2])
                                }
                            }

                            if (users.length > 0) {
                                let final_user = users.pop()
                                if (final_user != undefined) {
                                    pairs[pairs.length-1].push(final_user)
                                }
                            }
                            console.log("Pairs:", pairs);
                            const message = {
                                key: "message-key-" + Date.now(),
                                value: JSON.stringify({
                                    teams: pairs,
                                    timestamp: new Date().toISOString(),
                                }),
                            };
                            console.log(`Publishing message to topic: paired`);
                            console.log("Message:", message);
                            await producer.send({
                                topic: "paired",
                                messages: [message],
                            });
                            break;
                        default:
                            console.log("Ignored.");
                    }
                } catch (error) {
                    // If not JSON, just log as string
                    console.log(`error: ${error}`);
                }
            },
        });
    } catch (error) {
        console.error("Error consuming messages:", error);
    }
}

// Handle graceful shutdown
process.on("SIGINT", async () => {
    console.log("\n\nShutting down consumer...");
    try {
        await consumer.disconnect();
        await producer.disconnect();
        console.log("Consumer disconnected successfully");
        process.exit(0);
    } catch (error) {
        console.error("Error during shutdown:", error);
        process.exit(1);
    }
});

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

// Start consuming
consumeMessages().catch(console.error);
