provider "aws" {
  region = "us-east-1" # Substitua pela região desejada
}

resource "aws_s3_bucket" "hello_world" {
  bucket = "hello-world" # Nome do bucket
  acl    = "public-read"     # Controle de acesso, neste caso é privado

  tags = {
    Name = "Hello World Bucket"
  }
}
