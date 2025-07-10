output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_security_group_id" { ## 시큐리티 그룹추가 - 김재신
  value = module.eks.cluster_security_group_id
}

output "cluster_ca_certificate" {
  value = module.eks.cluster_certificate_authority_data
}