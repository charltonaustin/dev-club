# Kafka Connection Guide

This guide walks through the steps to connect to the MSK (Managed Streaming for Kafka) cluster.

## Step 1: Setup DNS Configuration

Run the setup script to configure DNS masquerading:

```bash
./setup.sh
```

## Step 2: Establish SSH Port Forward

Create an SSH tunnel to the Kafka broker through the bastion host:

```bash
ssh -i dev-club-key.pem -L 9098:boot-pieclbrb.c1.kafka-serverless.us-east-2.amazonaws.com:9098 -N ec2-user@ec2-18-226-163-91.us-east-2.compute.amazonaws.com
```

**Note:** Keep this terminal open - the tunnel needs to stay active.

## Step 3: Get AWS Session Credentials

Assume the IAM role and export temporary credentials:

```bash
TEMP_CREDS=$(aws sts assume-role \
 --role-arn arn:aws:iam::863647765358:role/dev-club-msk-serverless-bastion-role \
 --role-session-name fresh-kafka-session \
 --profile sandboxplatform)

export AWS_SESSION_TOKEN=$(echo $TEMP_CREDS | jq -r '.Credentials.SessionToken')
export AWS_SECRET_ACCESS_KEY=$(echo $TEMP_CREDS | jq -r '.Credentials.SecretAccessKey')
export AWS_ACCESS_KEY_ID=$(echo $TEMP_CREDS | jq -r '.Credentials.AccessKeyId')
```

**Alternatively, use the convenience script:**

```bash
source ./export_aws_creds.sh
```

## Step 4: Run Kafka Client

Navigate to the TypeScript directory and run the consumer:

```bash
cd typescript
npm install
npm run consumer
```

**Or run the producer:**

```bash
npm run producer
```

## Cleanup

When finished, run the teardown script to clean up DNS configuration:

```bash
./teardown.sh
```
