provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my_bucket_1" {
  bucket = "hello-world"
}