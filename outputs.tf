output "eks_cluster_id" {
  value = module.eks.cluster_id
}

output "vpc_id" {
  value = module.network.vpc_id
}
