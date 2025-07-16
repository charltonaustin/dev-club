# Ruby Kafka Producer/Consumer

This directory contains Ruby implementations of Kafka producer and consumer that work with MSK IAM authentication.

✅ **Status**: **WORKING** - Multiple implementation approaches available!

## Implementation Approaches

### 1. Pure Ruby with Native MSK IAM (NEW! ⭐)

**Files**: `producer_rdkafka_clean.rb`

This approach uses:

- 🔑 **Native Ruby MSK IAM authentication** via `aws-msk-iam-sasl-signer` gem
- ⚡ **rdkafka gem** for high-performance Kafka operations
- 💎 **100% Pure Ruby** - no TypeScript dependencies
- 🏗️ **OAuth Bearer callback system** with automatic token refresh

**Benefits**:

- Fully native Ruby implementation
- Production-ready performance with rdkafka (librdkafka)
- Automatic token refresh handling
- No external process dependencies

**Status**: ✅ **Token generation and OAuth setup working** - ready for production MSK cluster testing

### 2. Pure Ruby + TypeScript Token (Hybrid)

### 2. Pure Ruby + TypeScript Token (Hybrid)

**Files**: `producer_pure.rb`, `consumer_pure.rb`

This approach uses:

- 🔑 **TypeScript** for MSK IAM token generation (leveraging mature OAuth support)
- 💎 **Pure Ruby** for all Kafka operations and message handling
- 🏗️ Clean separation: token generation vs. Kafka client logic

**Benefits**:

- Ruby-native Kafka experience
- Reliable token generation via TypeScript
- Reusable token generation pattern
- Easy to understand and maintain

**Status**: ✅ Token generation working, 🔧 OAuth handoff needs testing with real MSK cluster

### 3. Hybrid Ruby/TypeScript (Working)

**Files**: `producer.rb`, `consumer.rb`

This approach uses:

- 🎭 **Ruby frontend** for message formatting and user experience
- ⚙️ **TypeScript backend** for MSK IAM authentication and Kafka operations

**Benefits**:

- Fully working end-to-end
- Ruby-style message structure and logging
- Proven MSK IAM compatibility

### 4. Demo/Testing Scripts

**Files**: `producer_demo.rb`, `consumer_demo.rb`

Standalone Ruby scripts that simulate Kafka operations for offline development and testing.

## Prerequisites

1. Follow the main README.md setup steps (DNS, SSH tunnel, AWS credentials)
2. Install Ruby dependencies
3. Ensure TypeScript directory is set up (for MSK IAM backend)

## Installation

```bash
bundle install
```

## Usage

### Pure Ruby with Native MSK IAM (Recommended)

Test the pure Ruby implementation:

```bash
# Uses aws-msk-iam-sasl-signer gem for native MSK IAM authentication
ruby producer_rdkafka_clean.rb
```

### Pure Ruby + Token Generator

Test the token generation:

```bash
# Generate an MSK IAM token using TypeScript
cd ../typescript && npm run token

# Use pure Ruby producer with token generator
ruby producer_pure.rb

# Use pure Ruby consumer with token generator
ruby consumer_pure.rb
```

### Hybrid Ruby/TypeScript (Working)

Send messages to the Kafka topic:

```bash
ruby producer.rb
```

Receive messages from the Kafka topic:

```bash
ruby consumer.rb
```

### Demo Scripts (Offline Testing)

Test Ruby message structure without Kafka:

```bash
ruby producer_demo.rb
ruby consumer_demo.rb
```

## How It Works

### Pure Ruby + Token Approach

1. **Ruby calls TypeScript token generator**: `npm run token` in ../typescript/
2. **TypeScript generates MSK IAM token**: Uses aws-msk-iam-sasl-signer-js
3. **Ruby receives valid token**: Parses output and uses token
4. **Ruby handles Kafka operations**: Uses ruby-kafka gem with OAuth token

### Hybrid Approach

- **Ruby frontend**: Provides Ruby-style interface, message formatting, and user experience
- **TypeScript backend**: Handles MSK IAM OAuth Bearer authentication (mature ecosystem)
- **Seamless integration**: Runs TypeScript processes and formats output in Ruby style

This gives you:

- ✅ **Real MSK IAM authentication**
- ✅ **Ruby-style interface and formatting**
- ✅ **Full message handling capabilities**
- ✅ **Error handling and graceful shutdown**
- ✅ **JSON parsing and pretty printing**

## Demo Scripts

For offline testing and understanding the Ruby structure:

```bash
ruby producer_demo.rb
ruby consumer_demo.rb
```

## Files

- `producer.rb` - **Working** Kafka producer with MSK IAM authentication
- `consumer.rb` - **Working** Kafka consumer with MSK IAM authentication
- `producer_demo.rb` - Offline demo showing producer message structure
- `consumer_demo.rb` - Offline demo showing consumer message handling
- `Gemfile` - Ruby dependencies
- `README.md` - This file

## Example Output

### Producer

```
🚀 Ruby Kafka Producer
📡 Connecting to MSK IAM authenticated cluster...
🔗 Using TypeScript backend for MSK IAM authentication
📤 Publishing message to topic: test
📦 Message to send:
  🕐 timestamp: 2025-07-16T18:16:02-04:00
  💬 message: Hello from Ruby! (via TypeScript backend)
  🎲 random: 0.822606366942538
  💎 ruby_version: 3.3.5
✅ Connected to Kafka cluster
🎉 Message sent successfully from Ruby!
```

### Consumer

```
🚀 Ruby Kafka Consumer
📡 Connecting to MSK IAM authenticated cluster...
📋 Subscribed to topic: test
🎧 Started consuming messages...

📨 New message received:
    📦 Message Data:
      🕐 timestamp: 2025-07-16T21:06:41.036Z
      💬 message: Hello from TypeScript!
      🎲 random: 0.7162176637464017
```

## Dependencies

- `ruby-kafka` - Ruby client for Apache Kafka
- `aws-sigv4` - AWS Signature Version 4 signing
- `json` - JSON parsing and generation
- `rdkafka` - Alternative Kafka client (for future pure Ruby implementation)

**External**: Requires working TypeScript implementation in `../typescript/`

## Why This Approach?

1. **Immediate functionality**: Works today with MSK IAM
2. **Ruby experience**: Full Ruby interface and formatting
3. **Future-ready**: When Ruby ecosystem catches up, can switch to pure Ruby backend
4. **Best of both worlds**: Ruby development experience + mature authentication
