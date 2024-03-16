provider "aws" {
  region = "us-east-1"  # Altere para a região desejada
}

# Criação de um VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"  # CIDR do VPC
}

# Criação de sub-redes públicas
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"  # CIDR da sub-rede pública
  map_public_ip_on_launch = true
}

# Criação de sub-redes privadas
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"  # CIDR da sub-rede privada
}

# Criação de um grupo de segurança para permitir tráfego de entrada apenas nas portas necessárias
resource "aws_security_group" "eks_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 443  # HTTPS para comunicação com o EKS
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Criação de uma gateway de internet para permitir acesso à internet para instâncias na sub-rede pública
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Anexa a gateway de internet ao VPC
resource "aws_vpc_attachment" "igw_attachment" {
  vpc_id       = aws_vpc.main.id
  internet_gateway_id = aws_internet_gateway.igw.id
}

# Associa a sub-rede pública à tabela de roteamento padrão
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_vpc.main.main_route_table_id
}
