## EKS Cluster Resources
#
#resource "aws_security_group" "cluster_eks_fiapburger" {
#  name        = "cluster_eks_fiapburger"
#  description = "Cluster communication with worker nodes"
#  vpc_id      = var.vpc_id
#
#  ingress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  tags = {
#    "Name" = var.cluster_name
#  }
#}
#
#resource "aws_eks_cluster" "cluster_eks_fiapburger" {
#  name     = var.cluster_name
#  role_arn = "arn:aws:iam::730335333567:role/LabRole"
#  #role_arn = "arn:aws:iam::730335333567:role/eksFiapClusterRole"
#
#  vpc_config {
#    security_group_ids = [aws_security_group.cluster_eks_fiapburger.id]
#    subnet_ids         = var.subnet_ids
#  }
#
#}
#
#resource "aws_eks_node_group" "vpc-fiapburger" {
#  cluster_name    = aws_eks_cluster.cluster_eks_fiapburger.name
#  node_group_name = "vpc-fiapburger"
#  node_role_arn   = "arn:aws:iam::730335333567:role/LabRole"
#  subnet_ids      = var.subnet_ids
#  tags = {
#    "Name" = "cluster_eks_fiapburger-workers"
#  }
#  remote_access {
#    ec2_ssh_key = "vockey"
#  }
#  scaling_config {
#    desired_size = 2
#    max_size     = 4
#    min_size     = 1
#  }
#}
#
#resource "aws_network_interface" "eni_eks" {
#  count = 2
#
#  subnet_id      = var.subnet_ids[count.index]
#}
#
#resource "aws_lb" "lb_eks" {
#  name               = "lb-eks"
#  internal           = false
#  load_balancer_type = "network"
#  subnets            = var.subnet_ids
#
#  enable_deletion_protection = false
#}
