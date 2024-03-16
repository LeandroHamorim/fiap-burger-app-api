terraform {
  required_version = ">= 0.13.1"
  required_providers {
    aws = ">=5.38.0"
    local = ">=2.4.1"
  }
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "./network"
  aws_region = var.aws_region
  cluster_name = var.cluster_name
}

module "eks" {
  source = "./eks"
  aws_region = var.aws_region
  cluster_name = var.cluster_name
  vpc_id = module.network.vpc_id
}
