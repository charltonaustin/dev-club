terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      owner             = "llan"
      removeAsOf        = "07/21/2025"
      "kin:service"     = "epp-dev-club"
      "kin:domain"      = "epp"
      "kin:environment" = "dev"
    }
  }
}

# Variables are defined in variables.tf

# Data sources
data "aws_vpc" "selected" {
  id = var.vpc_id
}

# Security group for MSK cluster
resource "aws_security_group" "msk_security_group" {
  name_prefix = "${var.cluster_name}-sg"
  vpc_id      = var.vpc_id

  # Kafka client access (IAM) - from bastion and VPC
  ingress {
    from_port   = 9098
    to_port     = 9098
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
    description = "Kafka IAM access from VPC (including bastion)"
  }

  # Kafka client access (TLS) - from bastion and VPC
  ingress {
    from_port   = 9094
    to_port     = 9094
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
    description = "Kafka TLS access from VPC"
  }

  # Allow access from bastion security group
  ingress {
    from_port       = 9098
    to_port         = 9098
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_security_group.id]
    description     = "Kafka IAM access from bastion host"
  }

  # Allow TLS access from bastion security group
  ingress {
    from_port       = 9094
    to_port         = 9094
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_security_group.id]
    description     = "Kafka TLS access from bastion host"
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-security-group"
  }
}

# IAM role for MSK cluster
resource "aws_iam_role" "msk_cluster_role" {
  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "kafka.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.cluster_name}-cluster-role"
  }
}

# IAM role for developers to access MSK from bastion
resource "aws_iam_role" "msk_developer_role" {
  name = "${var.cluster_name}-developer-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = "msk-dev-access"
          }
        }
      }
    ]
  })

  tags = {
    Name = "${var.cluster_name}-developer-role"
  }
}

# IAM policy for MSK access
resource "aws_iam_role_policy" "msk_developer_policy" {
  name = "${var.cluster_name}-developer-policy"
  role = aws_iam_role.msk_developer_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kafka-cluster:Connect",
          "kafka-cluster:AlterCluster",
          "kafka-cluster:DescribeCluster"
        ]
        Resource = aws_msk_serverless_cluster.msk_serverless.arn
      },
      {
        Effect = "Allow"
        Action = [
          "kafka-cluster:*Topic*",
          "kafka-cluster:WriteData",
          "kafka-cluster:ReadData"
        ]
        Resource = "${aws_msk_serverless_cluster.msk_serverless.arn}/topic/*"
      },
      {
        Effect = "Allow"
        Action = [
          "kafka-cluster:AlterGroup",
          "kafka-cluster:DescribeGroup"
        ]
        Resource = "${aws_msk_serverless_cluster.msk_serverless.arn}/group/*"
      }
    ]
  })
}

# Data source to get current AWS account ID
data "aws_caller_identity" "current" {}

# CloudWatch Log Group for MSK
resource "aws_cloudwatch_log_group" "msk_log_group" {
  name              = "/aws/msk/${var.cluster_name}"
  retention_in_days = var.log_retention_days

  tags = {
    Name = "${var.cluster_name}-log-group"
  }
}

# MSK Serverless Cluster
resource "aws_msk_serverless_cluster" "msk_serverless" {
  cluster_name = var.cluster_name

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.msk_security_group.id]
  }

  client_authentication {
    sasl {
      iam {
        enabled = true
      }
    }
  }

  tags = {
    Name = var.cluster_name
  }
}

# Data source for latest Amazon Linux 2 AMI (ARM64)
data "aws_ami" "amazon_linux_arm" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-arm64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security group for bastion host
resource "aws_security_group" "bastion_security_group" {
  name_prefix = "${var.cluster_name}-bastion-sg"
  vpc_id      = var.vpc_id
  description = "Security group for Kafka bastion host"

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
    description = "SSH access to bastion host"
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Name = "${var.cluster_name}-bastion-security-group"
  }
}

# IAM role for bastion host
resource "aws_iam_role" "bastion_role" {
  name = "${var.cluster_name}-bastion-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.cluster_name}-bastion-role"
  }
}

# IAM instance profile for bastion host
resource "aws_iam_instance_profile" "bastion_profile" {
  name = "${var.cluster_name}-bastion-profile"
  role = aws_iam_role.bastion_role.name

  tags = {
    Name = "${var.cluster_name}-bastion-profile"
  }
}

# IAM policy for bastion (minimal permissions for port forwarding)
resource "aws_iam_role_policy" "bastion_minimal_policy" {
  name = "${var.cluster_name}-bastion-minimal-policy"
  role = aws_iam_role.bastion_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeNetworkInterfaces"
        ]
        Resource = "*"
      }
    ]
  })
}

# User data script for bastion host (minimal setup for port forwarding)
locals {
  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    
    # Configure SSH to allow TCP forwarding (should be default but ensuring it's set)
    echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config
    echo "GatewayPorts no" >> /etc/ssh/sshd_config
    systemctl restart sshd
    
    # Create a simple status file
    echo "Bastion host ready for port forwarding" > /home/ec2-user/status.txt
    chown ec2-user:ec2-user /home/ec2-user/status.txt
  EOF
  )
}

# EC2 bastion instance
resource "aws_instance" "kafka_bastion" {
  ami                    = data.aws_ami.amazon_linux_arm.id
  instance_type          = var.bastion_instance_type
  key_name               = var.key_name
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.bastion_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.bastion_profile.name

  user_data = local.user_data

  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp3"
    volume_size = 8
    encrypted   = true
  }

  tags = {
    Name = "${var.cluster_name}-kafka-bastion"
  }
}

# Outputs are defined in outputs.tf