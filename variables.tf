variable "aws_region" {
  description = "The AWS region to deploy the infrastructure."
  default     = "us-east-1"  # Altere conforme necessário
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  default     = "fiapburger-cluster"  # Altere conforme necessário
}

variable "vpc_id" {
  description = "ID of the VPC"
  default     = "" # Insira o valor padrão ou forneça este valor ao executar o Terraform
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs"
  default     = [] # Insira o valor padrão ou forneça este valor ao executar o Terraform
}
