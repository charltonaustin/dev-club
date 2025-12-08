import { Kafka, logLevel } from "kafkajs";
import { generateAuthToken } from "aws-msk-iam-sasl-signer-js";
import { sendSlackMessage } from "./slackMessageService";

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

async function consumeMessages() {
  try {
    console.log("Connecting to Kafka...");
    await consumer.connect();
    console.log("Connected successfully!");

    const topic = "test2";
    console.log(`Subscribing to topic: ${topic}`);
    await consumer.subscribe({ topic, fromBeginning: true });

    console.log("Starting to consume messages...");
    console.log("Press Ctrl+C to stop consuming");

    await consumer.run({
      eachMessage: async ({ topic, partition, message }) => {
        const key = message.key?.toString() || "null";
        const value = message.value?.toString() || "null";
        const offset = message.offset;
        const timestamp = new Date(Number(message.timestamp)).toISOString();

        console.log("\n📨 New message received:");
        console.log(`  Topic: ${topic}`);
        console.log(`  Partition: ${partition}`);
        console.log(`  Offset: ${offset}`);
        console.log(`  Key: ${key}`);
        console.log(`  Timestamp: ${timestamp}`);
        console.log(`  Value: ${value}`);

        // Try to parse JSON if possible
        try {
          const jsonValue = JSON.parse(value);
          if (jsonValue.command && jsonValue.command === "help") {
            const payload = {
              "text": "📚 **Available Commands:**\n• `join` - Join the pairing session\n `command:pair` - Start the pairing process\n• `help` - Show this help message\n• `status` - Check current session status",
            };
            const response = await sendSlackMessage("https://hooks.slack.com/services/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", payload);
            console.log("  Help message sent to Slack:", response);
          } else {
            console.log("  Parsed JSON:", JSON.stringify(jsonValue, null, 2));
          }
        } catch(e: unknown) {
          if (e instanceof Error) {
            console.error("  Failed to parse JSON:", e.message);
          }
          // If not JSON, just log as string
          console.log(`  Raw Value: ${value}`);
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
