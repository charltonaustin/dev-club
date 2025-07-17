# Ruby Kafka Producer/Consumer

This directory contains Ruby implementations of Kafka producer and consumer that work with MSK IAM authentication.

## Prerequisites

1. Follow the main README.md setup steps (DNS, SSH tunnel, AWS credentials)
2. Install Ruby dependencies

## Installation

```bash
bundle install
```

## Usage

### Pure Ruby with Native MSK IAM (Recommended)

Send messages to the Kafka topic:

```bash
ruby producer.rb
```

Receive messages from the Kafka topic:

```bash
ruby consumer.rb
```

## Example Output

### Producer (`producer.rb`)

```
🚀 Ruby Kafka Producer (rdkafka + aws-msk-iam-sasl-signer)
📡 Connecting to MSK IAM authenticated cluster...
 Publishing message to topic: test
📦 Message to send:
  🕐 timestamp: 2025-07-17T15:30:22-05:00
  💬 message: Hello from Pure Ruby! (rdkafka + aws-msk-iam-sasl-signer)
  🎲 random: 0.123456789
  💎 ruby_version: 3.3.5
✅ Connected to Kafka cluster
📬 Message delivery confirmed: partition=0, offset=145
🎉 Message sent successfully!
```

### Consumer (`consumer.rb`)

```
🚀 Ruby Kafka Consumer (rdkafka + aws-msk-iam-sasl-signer)
📡 Connecting to MSK IAM authenticated cluster...
📋 Subscribed to topic: test
🎧 Started consuming messages... (Press Ctrl+C to stop)

📨 New message received:
    📦 Message Data:
      🕐 timestamp: 2025-07-17T20:30:22.123Z
      💬 message: Hello from Pure Ruby! (rdkafka + aws-msk-iam-sasl-signer)
      🎲 random: 0.123456789
      💎 ruby_version: 3.3.5
```

## Dependencies

### Primary Dependencies (Pure Ruby)

- `rdkafka` - High-performance Ruby client for Apache Kafka (librdkafka binding)
- `aws-msk-iam-sasl-signer` - AWS MSK IAM authentication for Ruby
- `json` - JSON parsing and generation
