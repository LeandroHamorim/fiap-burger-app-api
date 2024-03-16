resource "aws_s3_bucket" "private_bucket" {
  bucket = "my-first-private-bucket"
  region = "us-east"

  tags = {
    Name        = "My First Private Bucket"
    Environment = "Exercise"
  }
}

resource "aws_s3_bucket_acl" "private_bucket_acl" {
  bucket = aws_s3_bucket.private_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket" "public_bucket" {
  bucket = "my-first-public-bucket"
  region = "us-east"

  tags = {
    Name        = "My First Public Bucket"
    Environment = "Exercise"
  }

}

resource "aws_s3_bucket_acl" "public_bucket_acl" {
  bucket = aws_s3_bucket.public_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_object" "bucket_object" {
  content  = "object content"
}