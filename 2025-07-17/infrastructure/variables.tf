variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-west-2"
}

variable "aws_profile" {
  description = "AWS profile to use for authentication"
  type        = string
  default     = null
}

variable "cluster_name" {
  description = "Name of the MSK serverless cluster"
  type        = string
  default     = "dev-club-msk-serverless"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_id" {
  description = "ID of the existing VPC to use for MSK cluster"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of existing private subnet IDs to use for MSK cluster (minimum 2 subnets in different AZs)"
  type        = list(string)
  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "At least 2 private subnet IDs must be provided for MSK cluster high availability."
  }
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 7
}

variable "public_subnet_id" {
  description = "Public subnet ID where the bastion host will be deployed"
  type        = string
  default     = "subnet-086ae58369f7e70ff"
}

variable "key_name" {
  description = "EC2 Key Pair name for SSH access to bastion host"
  type        = string
  default     = "dev-club-key"
}

variable "bastion_instance_type" {
  description = "EC2 instance type for the bastion host (optimized for port forwarding)"
  type        = string
  default     = "t4g.nano"
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to SSH to bastion host"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Restrict this in production
}
