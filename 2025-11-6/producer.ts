import { Kafka, Producer } from "kafkajs";

interface UserEvent {
  userId: number;
  action: string;
  timestamp: string;
}

// Create Kafka client
const kafka = new Kafka({
  clientId: "my-producer",
  brokers: ["localhost:9092"],
});

const producer: Producer = kafka.producer();

// Define possible actions
const ACTIONS = [
  "login",
  "logout",
  "purchase",
  "view_product",
  "add_to_cart",
  "remove_from_cart",
  "search",
];
const USER_IDS = [101, 102, 103, 104, 105, 106, 107, 108, 109, 110];

const produceMessages = async (): Promise<void> => {
  await producer.connect();
  console.log("Producer connected to Kafka");

  let messageCount = 0;

  const sendMessage = async () => {
    messageCount++;

    // Pick random user and action
    const userId = USER_IDS[Math.floor(Math.random() * USER_IDS.length)];
    const action = ACTIONS[Math.floor(Math.random() * ACTIONS.length)];

    const event: UserEvent = {
      userId,
      action,
      timestamp: new Date().toISOString(),
    };

    const message = {
      key: `user-${userId}`,
      value: JSON.stringify(event),
    };

    try {
      await producer.send({
        topic: "user-events",
        messages: [message],
      });

      console.log(`✅ Sent message ${messageCount}:`, message.value);
    } catch (error) {
      console.error("❌ Error sending message:", error);
    }

    // Stop after 20 messages
    if (messageCount >= 20) {
      await producer.disconnect();
      console.log("\n🎉 Producer finished sending 20 messages");
      process.exit(0);
    } else {
      // Schedule next message with random delay between 3-5 seconds
      const delay = 3000 + Math.random() * 2000;
      setTimeout(sendMessage, delay);
    }
  };

  // Start sending messages
  sendMessage();
};

// Handle graceful shutdown
process.on("SIGINT", async () => {
  console.log("\n\n👋 Shutting down producer...");
  await producer.disconnect();
  process.exit(0);
});

produceMessages().catch(console.error);
