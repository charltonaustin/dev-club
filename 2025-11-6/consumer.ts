import { Kafka, Consumer, EachMessagePayload } from 'kafkajs';

interface UserEvent {
  userId: number;
  action: string;
  timestamp: string;
}

// Get consumer group from command line argument
// Usage: tsx consumer.ts [groupId]
const groupId: string = process.argv[2] || 'consumer-group-1';

// Create Kafka client
const kafka = new Kafka({
  clientId: `my-consumer-${groupId}`,
  brokers: ['localhost:9092']
});

const consumer: Consumer = kafka.consumer({
  groupId: groupId
});

const consumeMessages = async (): Promise<void> => {
  await consumer.connect();
  console.log(`\n🚀 Consumer connected to Kafka`);
  console.log(`📦 Consumer Group: ${groupId}`);
  console.log(`⏳ Waiting for messages...\n`);

  await consumer.subscribe({
    topic: 'user-events',
    fromBeginning: true
  });

  await consumer.run({
    eachMessage: async ({ topic, partition, message }: EachMessagePayload) => {
      if (!message.value) {
        console.warn('Received message with no value');
        return;
      }

      const value = message.value.toString();
      const parsedValue: UserEvent = JSON.parse(value);

      console.log({
        group: groupId,
        partition: partition,
        offset: message.offset,
        key: message.key?.toString(),
        userId: parsedValue.userId,
        action: parsedValue.action,
        timestamp: parsedValue.timestamp
      });
    },
  });
};

// Handle graceful shutdown
process.on('SIGINT', async () => {
  console.log(`\n\n👋 Shutting down consumer (${groupId})...`);
  await consumer.disconnect();
  process.exit(0);
});

consumeMessages().catch(console.error);
