provider "aws" {
  region = "us-east-1" // Substitua pela sua região preferida
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "hello-world"
  acl    = "private"
}