data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block = "10.5.0.0/16"
  #  enable_dns_hostnames = true
  tags = {
    "Name" = "cluster_eks_fiapburger"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "subnet" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.5.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.vpc.id

  tags = {
    "Name" = "cluster_eks_fiapburger"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = var.cluster_name
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "name" = "cluster_eks_fiapburger"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table_association" "route_table_association" {
  count = 2

  subnet_id      = aws_subnet.subnet.*.id[count.index]
  route_table_id = aws_route_table.route_table.id
}
