provider "aws" {
  region = "us-east-1"
}

resource "aws_eks_cluster" "my_cluster_" {
  name     = "my-cluster-acn-01"
  role_arn = "arn:aws:iam::730335333567:role/LabRole"

  vpc_config {
    subnet_ids = [
      "subnet-081d1613d89ee8ba6",
      "subnet-0b97e6916779e8ddb"
    ]
  }
}
