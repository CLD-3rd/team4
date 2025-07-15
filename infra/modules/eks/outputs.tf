output "cluster_name" {
  value = module.eks_cluster.cluster_name
}

output "cluster_endpoint" {
  value = module.eks_cluster.cluster_endpoint
}

output "cluster_security_group_id" { ## 시큐리티 그룹추가 - 김재신
  value = module.eks_cluster.cluster_security_group_id
}

output "cluster_ca_certificate" {
  value = module.eks_cluster.cluster_certificate_authority_data
}

output "oidc_provider_arn" {
  description = "EKS OIDC Provider ARN"
  value       = module.eks_cluster.oidc_provider_arn
}

output "oidc_provider_url" {
  description = "EKS OIDC Provider URL"
  value       = module.eks_cluster.oidc_provider
}