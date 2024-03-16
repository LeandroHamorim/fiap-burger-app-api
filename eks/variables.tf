variable "aws_region" {
  description = "AWS region"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
}

variable "vpc_id" {
  description = "ID of the VPC"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs"
}
