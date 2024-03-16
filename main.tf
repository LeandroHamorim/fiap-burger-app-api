provider "aws" {
  region = "us-west-1" # Defina sua região preferida
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  id         = "vpc-0c9c3eae30dce3c6e"  # ID da sua VPC
}

resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_eks_cluster" "my_cluster" {
  name     = "my-cluster"
  role_arn = "arn:aws:iam::730335333567:role/LabRole"
  version  = "1.21"

  vpc_config {
    subnet_ids = [
      aws_subnet.subnet_1.id,
      aws_subnet.subnet_2.id
    ]
  }
}
