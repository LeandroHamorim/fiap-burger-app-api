# Providers:
terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.aws_region
}


# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#  * Elastic Network Interface (ENI)
#  * Elastic Load Balancer

data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc-fiapburger" {
  cidr_block = "10.5.0.0/16"
  #  enable_dns_hostnames = true
  tags = map(
    "name", "cluster_eks_fiapburger",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

resource "aws_subnet" "vpc-fiapburger" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.5.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.vpc-fiapburger.id

  tags = map(
    "name", "cluster_eks_fiapburger",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

resource "aws_internet_gateway" "vpc-fiapburger" {
  vpc_id = aws_vpc.vpc-fiapburger.id

  tags = {
    Name = var.cluster-name
  }
}

resource "aws_route_table" "vpc-fiapburger" {
  vpc_id = aws_vpc.vpc-fiapburger.id
  tags = {
    name = "cluster_eks_fiapburger"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-fiapburger.id
  }
}

resource "aws_route_table_association" "vpc-fiapburger" {
  count = 2

  subnet_id      = aws_subnet.vpc-fiapburger.*.id[count.index]
  route_table_id = aws_route_table.vpc-fiapburger.id
}

#
# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * EC2 Security Group to allow networking traffic with EKS cluster
#  * EKS Cluster
#

resource "aws_security_group" "cluster_eks_fiapburger" {
  name        = "cluster_eks_fiapburger"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.vpc-fiapburger.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.cluster-name
  }
}

resource "aws_eks_cluster" "cluster_eks_fiapburger" {
  name     = var.cluster-name
  role_arn = "arn:aws:iam::730335333567:role/LabRole"
  #role_arn = "arn:aws:iam::730335333567:role/eksFiapClusterRole"

  vpc_config {
    security_group_ids = [aws_security_group.cluster_eks_fiapburger.id]
    subnet_ids         = aws_subnet.vpc-fiapburger[*].id
  }

}

#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#

resource "aws_eks_node_group" "vpc-fiapburger" {
  cluster_name    = aws_eks_cluster.cluster_eks_fiapburger.name
  node_group_name = "vpc-fiapburger"
  node_role_arn   = "arn:aws:iam::730335333567:role/LabRole"
  subnet_ids      = aws_subnet.vpc-fiapburger[*].id
  tags = {
    Name = "cluster_eks_fiapburger-workers"
  }
  remote_access {
    ec2_ssh_key = "vockey"
  }
  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 1
  }
}

resource "aws_network_interface" "eni_eks" {
  count = 2

  subnet_id      = aws_subnet.vpc-fiapburger.*.id[count.index]
}

resource "aws_lb" "lb_eks" {
  name               = "lb-eks"
  internal           = false
  load_balancer_type = "network"
  subnets            = [for subnet in aws_subnet.vpc-fiapburger : subnet.id]

  enable_deletion_protection = false
}