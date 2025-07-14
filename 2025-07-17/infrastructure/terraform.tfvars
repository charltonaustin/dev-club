# AWS region where the MSK cluster will be created
aws_region = "us-east-2"

# Name of the MSK serverless cluster
cluster_name = "dev-club-msk-serverless"

# Environment tag
environment = "dev"

# Existing VPC Configuration (REQUIRED)
vpc_id = "vpc-094412cd96eb5b2a2"

# Existing private subnet IDs (minimum 2 in different AZs)
private_subnet_ids = ["subnet-06acf0c179b643c65", "subnet-0a8c7723a112326f3", "subnet-041f15a648dd616ee"]

# CloudWatch log retention in days
log_retention_days = 7
