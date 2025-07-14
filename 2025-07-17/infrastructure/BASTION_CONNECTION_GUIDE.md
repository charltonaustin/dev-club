# Connecting to MSK Serverless through Bastion Host

This guide explains how developers can connect to the MSK Serverless cluster from their local machines using a bastion host with port forwarding.

## Overview

The MSK Serverless cluster is deployed in private subnets and uses IAM authentication. Developers connect through a bastion host using:

1. SSH port forwarding to tunnel traffic
2. AWS IAM role assumption for authentication
3. Local Kafka clients pointing to localhost

## Prerequisites

1. Access to the bastion host in the same VPC
2. AWS CLI configured with appropriate permissions
3. SSH access to the bastion host
4. Kafka client libraries installed locally

## Connection Steps

### 1. Get Connection Details

After deploying the infrastructure, get the connection details:

```bash
# Get the bootstrap servers
terraform output bootstrap_brokers_sasl_iam

# Get the developer role ARN
terraform output msk_developer_role_arn

# Get the connection guide
terraform output bastion_connection_guide
```

### 2. Set Up SSH Port Forwarding

Replace `BASTION_HOST` with your actual bastion host address:

```bash
# Extract the bootstrap server hostname (remove port)
BOOTSTRAP_HOST=$(terraform output -raw bootstrap_brokers_sasl_iam | cut -d':' -f1)

# Set up port forwarding
ssh -L 9098:${BOOTSTRAP_HOST}:9098 -N bastion-user@BASTION_HOST
```

Keep this SSH connection open in a separate terminal.

### 3. Assume the Developer IAM Role

```bash
# Get the role ARN
ROLE_ARN=$(terraform output -raw msk_developer_role_arn)

# Assume the role
aws sts assume-role \
  --role-arn $ROLE_ARN \
  --role-session-name msk-dev-session \
  --external-id msk-dev-access

# Export the temporary credentials (replace with actual values from assume-role output)
export AWS_ACCESS_KEY_ID="ASIA..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_SESSION_TOKEN="..."
```

### 4. Configure Your Kafka Client

Now configure your Kafka client to connect to `localhost:9098`:

## Python Example

```python
from kafka import KafkaProducer, KafkaConsumer
from aws_msk_iam_sasl_signer import MSKAuthTokenProvider

# Configuration
config = {
    'bootstrap_servers': ['localhost:9098'],
    'security_protocol': 'SASL_SSL',
    'sasl_mechanism': 'AWS_MSK_IAM',
    'sasl_oauth_token_provider': MSKAuthTokenProvider(region='us-east-2')
}

# Producer
producer = KafkaProducer(**config)
producer.send('test-topic', value=b'Hello from local!')

# Consumer
consumer = KafkaConsumer('test-topic', **config, group_id='local-consumer-group')
for message in consumer:
    print(f"Received: {message.value}")
```

## Java/Spring Boot Example

```properties
# application.properties
spring.kafka.bootstrap-servers=localhost:9098
spring.kafka.security.protocol=SASL_SSL
spring.kafka.properties.sasl.mechanism=AWS_MSK_IAM
spring.kafka.properties.sasl.jaas.config=software.amazon.msk.auth.iam.IAMLoginModule required;
spring.kafka.properties.sasl.client.callback.handler.class=software.amazon.msk.auth.iam.IAMClientCallbackHandler

# Producer/Consumer configs
spring.kafka.producer.key-serializer=org.apache.kafka.common.serialization.StringSerializer
spring.kafka.producer.value-serializer=org.apache.kafka.common.serialization.StringSerializer
spring.kafka.consumer.key-deserializer=org.apache.kafka.common.serialization.StringDeserializer
spring.kafka.consumer.value-deserializer=org.apache.kafka.common.serialization.StringDeserializer
spring.kafka.consumer.group-id=local-consumer-group
```

Add this dependency to your `pom.xml`:

```xml
<dependency>
    <groupId>software.amazon.msk</groupId>
    <artifactId>aws-msk-iam-auth</artifactId>
    <version>1.1.9</version>
</dependency>
```

## Node.js Example

```javascript
const { Kafka } = require("kafkajs");
const { MSKIAMTokenProvider } = require("@aws-sdk/client-kafka");

const kafka = Kafka({
  clientId: "local-dev-client",
  brokers: ["localhost:9098"],
  ssl: true,
  sasl: {
    mechanism: "aws-msk-iam",
    authorizationIdentity: "", // MSK IAM auth doesn't use this
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
    sessionToken: process.env.AWS_SESSION_TOKEN,
  },
});

const producer = kafka.producer();
const consumer = kafka.consumer({ groupId: "local-consumer-group" });

// Usage
async function run() {
  await producer.connect();
  await producer.send({
    topic: "test-topic",
    messages: [{ value: "Hello from Node.js!" }],
  });

  await consumer.connect();
  await consumer.subscribe({ topic: "test-topic" });

  await consumer.run({
    eachMessage: async ({ topic, partition, message }) => {
      console.log({
        topic,
        partition,
        offset: message.offset,
        value: message.value.toString(),
      });
    },
  });
}
```

## Shell Script for Easy Setup

Create a script `connect-to-msk.sh`:

```bash
#!/bin/bash

# Configuration
BASTION_HOST="your-bastion-host.com"
BASTION_USER="ec2-user"

echo "Setting up MSK connection through bastion..."

# Get connection details
BOOTSTRAP_HOST=$(terraform output -raw bootstrap_brokers_sasl_iam | cut -d':' -f1)
ROLE_ARN=$(terraform output -raw msk_developer_role_arn)

echo "Bootstrap host: $BOOTSTRAP_HOST"
echo "Role ARN: $ROLE_ARN"

# Start port forwarding in background
echo "Starting SSH port forwarding..."
ssh -L 9098:${BOOTSTRAP_HOST}:9098 -N ${BASTION_USER}@${BASTION_HOST} &
SSH_PID=$!

echo "Port forwarding started (PID: $SSH_PID)"
echo "MSK cluster is now accessible at localhost:9098"
echo ""
echo "To assume the developer role, run:"
echo "aws sts assume-role --role-arn $ROLE_ARN --role-session-name msk-dev-session --external-id msk-dev-access"
echo ""
echo "Press Ctrl+C to stop port forwarding"

# Wait for Ctrl+C
trap "kill $SSH_PID; echo 'Port forwarding stopped'" EXIT
wait $SSH_PID
```

## Troubleshooting

### 1. Connection Refused

- Ensure SSH port forwarding is working: `netstat -an | grep 9098`
- Check bastion host security group allows SSH access
- Verify MSK security group allows access from bastion

### 2. Authentication Errors

- Verify IAM role assumption worked: `aws sts get-caller-identity`
- Check AWS credentials are exported correctly
- Ensure the IAM role has necessary MSK permissions

### 3. SSL/TLS Issues

- MSK Serverless requires TLS connections
- Ensure your Kafka client supports SASL_SSL protocol
- Check your client's SSL certificate validation settings

### 4. Topic Access Issues

- The IAM role has permissions for all topics (`/topic/*`)
- Create topics first if auto-creation is disabled
- Check topic-level permissions if using fine-grained access control

## Security Notes

1. **Temporary Credentials**: The assumed role credentials are temporary (1 hour by default)
2. **Port Forwarding**: Only forwards traffic, doesn't store credentials
3. **Network Security**: Traffic is encrypted through SSH tunnel and TLS to MSK
4. **IAM Permissions**: Developer role has limited MSK-specific permissions
5. **External ID**: Required for role assumption adds an extra security layer

## Configuration Management

For different environments, you can:

1. Use different terraform workspaces
2. Pass bastion host as a variable
3. Create environment-specific connection scripts
4. Use AWS SSM Parameter Store for configuration
