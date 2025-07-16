# AWS region where the MSK cluster will be created
aws_region = "us-east-2"

# Name of the MSK serverless cluster
cluster_name = "dev-club-msk-serverless"

# Environment tag
environment = "dev"

# Existing VPC Configuration (REQUIRED)
vpc_id = "vpc-004f1e0ffc2ff5faa"

# Existing private subnet IDs (minimum 2 in different AZs)
private_subnet_ids = ["subnet-01b9f300e39c690dd", "subnet-00b0d9af0d0820c02", "subnet-05654215f4a589826"]

# CloudWatch log retention in days
log_retention_days = 7

public_subnet_id = "subnet-0ddcd029a1ad55052"