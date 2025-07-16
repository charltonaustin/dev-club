#!/bin/bash

# Script to assume AWS role and export temporary credentials
# Usage: source ./export_aws_creds.sh

set -e

echo "Assuming AWS role and exporting temporary credentials..."

# Assume the role and get temporary credentials
TEMP_CREDS=$(aws sts assume-role \
 --role-arn arn:aws:iam::863647765358:role/dev-club-msk-serverless-bastion-role \
 --role-session-name fresh-kafka-session \
 --profile sandboxplatform)

# Export the credentials as environment variables
export AWS_SESSION_TOKEN=$(echo $TEMP_CREDS | jq -r '.Credentials.SessionToken')
export AWS_SECRET_ACCESS_KEY=$(echo $TEMP_CREDS | jq -r '.Credentials.SecretAccessKey')
export AWS_ACCESS_KEY_ID=$(echo $TEMP_CREDS | jq -r '.Credentials.AccessKeyId')

echo "AWS credentials exported successfully!"
echo "AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID:0:10}..."
echo "AWS_SECRET_ACCESS_KEY: ${AWS_SECRET_ACCESS_KEY:0:10}..."
echo "AWS_SESSION_TOKEN: ${AWS_SESSION_TOKEN:0:10}..."
echo ""
echo "Note: These credentials are temporary and will expire."
echo "To use these credentials, run: source ./creds.sh"
