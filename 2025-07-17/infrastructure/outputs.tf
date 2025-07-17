# Note: Using existing VPC and subnets

output "msk_cluster_arn" {
  description = "The ARN of the MSK serverless cluster"
  value       = aws_msk_serverless_cluster.msk_serverless.arn
}

output "msk_cluster_name" {
  description = "The name of the MSK serverless cluster"
  value       = aws_msk_serverless_cluster.msk_serverless.cluster_name
}

output "bootstrap_brokers_sasl_iam" {
  description = "A list of bootstrap broker endpoints for SASL/IAM authentication"
  value       = aws_msk_serverless_cluster.msk_serverless.bootstrap_brokers_sasl_iam
}

output "vpc_id" {
  description = "The ID of the VPC used for MSK"
  value       = var.vpc_id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets where MSK is deployed"
  value       = var.private_subnet_ids
}

output "security_group_id" {
  description = "The ID of the MSK security group"
  value       = aws_security_group.msk_security_group.id
}

output "msk_cluster_uuid" {
  description = "UUID of the MSK cluster for use in topic ARNs, etc."
  value       = aws_msk_serverless_cluster.msk_serverless.cluster_uuid
}

output "msk_developer_role_arn" {
  description = "ARN of the IAM role for developers to assume for MSK access"
  value       = aws_iam_role.msk_developer_role.arn
}

output "ssh_command" {
  description = "SSH command to connect to the bastion host"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${aws_instance.kafka_bastion.public_ip}"
}

output "bastion_connection_guide" {
  description = "Guide for connecting to MSK through bastion host port forwarding"
  value = {
    ssh_tunnel_command = "ssh -i ~/.ssh/${var.key_name}.pem -L 9098:${split(":", aws_msk_serverless_cluster.msk_serverless.bootstrap_brokers_sasl_iam)[0]}:9098 ec2-user@${aws_instance.kafka_bastion.public_ip}"
    local_bootstrap_servers = "localhost:9098"
    usage_note = "After establishing the SSH tunnel, connect your Kafka clients to localhost:9098"
  }
}

output "bastion_instance_id" {
  description = "ID of the bastion EC2 instance"
  value       = aws_instance.kafka_bastion.id
}

output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = aws_instance.kafka_bastion.public_ip
}

output "bastion_public_dns" {
  description = "Public DNS name of the bastion host"
  value       = aws_instance.kafka_bastion.public_dns
}

output "bastion_security_group_id" {
  description = "Security group ID of the bastion host"
  value       = aws_security_group.bastion_security_group.id
}

output "port_forwarding_guide" {
  description = "Complete guide for port forwarding to MSK through bastion"
  value = {
    step1_ssh_tunnel = "ssh -i ~/.ssh/${var.key_name}.pem -L 9098:${split(":", aws_msk_serverless_cluster.msk_serverless.bootstrap_brokers_sasl_iam)[0]}:9098 ec2-user@${aws_instance.kafka_bastion.public_ip}"
    step2_use_localhost = "Configure your Kafka client to connect to: localhost:9098"
    step3_auth_note = "Use AWS IAM authentication with your local AWS credentials"
    msk_bootstrap_servers = aws_msk_serverless_cluster.msk_serverless.bootstrap_brokers_sasl_iam
    tunnel_explanation = "The SSH tunnel forwards local port 9098 to the MSK broker through the bastion host"
  }
}
