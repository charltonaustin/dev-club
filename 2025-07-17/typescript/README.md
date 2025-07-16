# Kafka TypeScript Producer & Consumer

TypeScript scripts to connect to Kafka and publish/consume messages.

## Prerequisites

1. Make sure you have AWS credentials exported:

   ```bash
   source ../export_aws_creds.sh
   ```

2. Ensure the SSH tunnel is running:
   ```bash
   ssh -i ../dev-club-key.pem -L 9098:boot-pieclbrb.c1.kafka-serverless.us-east-2.amazonaws.com:9098 -N ec2-user@ec2-18-226-163-91.us-east-2.compute.amazonaws.com
   ```

## Usage

### Producer (Publish Messages)

Run with tsx directly:

```bash
npx tsx main.ts
```

Run with npm script:

```bash
npm run producer
# or
npm run publish
```

### Consumer (Read Messages)

Run with tsx directly:

```bash
npx tsx consumer.ts
```

Run with npm script:

```bash
npm run consumer
# or
npm run consume
```

## What they do

### Producer (`main.ts`)

- Connects to the Kafka cluster using AWS IAM authentication
- Publishes a JSON message to the `test` topic
- Includes a timestamp, message text, and random number
- Disconnects cleanly

### Consumer (`consumer.ts`)

- Connects to the Kafka cluster using AWS IAM authentication
- Subscribes to the `test` topic from the beginning
- Continuously listens for new messages
- Displays message details including key, value, timestamp, and offset
- Attempts to parse JSON values for better readability
- Gracefully handles Ctrl+C shutdown

## Message Format

```json
{
  "timestamp": "2025-07-16T...",
  "message": "Hello from TypeScript!",
  "random": 0.123456
}
```

## Testing

1. Start the consumer in one terminal:

   ```bash
   npm run consumer
   ```

2. In another terminal, publish some messages:
   ```bash
   npm run producer
   ```

The consumer will display all messages in real-time!
