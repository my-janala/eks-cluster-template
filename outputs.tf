output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.networking.vpc_id
}

output "eks_cluster_id" {
  description = "ID of the EKS cluster"
  value       = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  description = "Endpoint for the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "argocd_release_name" {
  description = "Name of the ArgoCD release"
  value       = module.argocd.release_name
}

output "argocd_namespace" {
  description = "Namespace where ArgoCD is deployed"
  value       = module.argocd.namespace
}