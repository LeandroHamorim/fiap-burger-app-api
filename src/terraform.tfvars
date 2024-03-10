aws_region  = "us-east-1"
bucket_name = "fiap-burger-bucket-s3"

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}