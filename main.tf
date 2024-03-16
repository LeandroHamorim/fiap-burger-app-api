provider "aws" {
  region = "us-east-1" # Substitua pela região desejada
}

#resource "aws_s3_bucket" "hello_world" {
#  bucket = "hello-world" # Nome do bucket
#  bucket = "hello-world-acn-001" # Nome do bucket
#
#  tags = {
#    Name = "Hello World Bucket"
#  }
#}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  id         = "vpc-0c9c3eae30dce3c6e"  # ID da sua VPC
}

resource "aws_eks_cluster" "my_cluster" {
  name     = "my-cluster"
  role_arn = "arn:aws:iam::730335333567:role/LabRole"
  version  = "1.21"

  vpc_config {
    subnet_ids = [
      subnet-081d1613d89ee8ba6,
      subnet-0b97e6916779e8ddb
    ]
  }
}
