# EKS Cluster 정보
output "eks_cluster_name" {
  description = "EKS 클러스터 이름"
  value       = var.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS 클러스터 엔드포인트"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_security_group_id" {
  description = "EKS 클러스터 보안 그룹 ID"
  value       = module.eks.cluster_security_group_id
}

output "eks_cluster_kubeconfig_context" {
  description = "EKS 클러스터 kubeconfig context 이름"
  value       = "arn:aws:eks:${var.region}:${data.aws_caller_identity.current.account_id}:cluster/${var.cluster_name}"
}

# IAM Role 정보
output "eks_admin_role_arn" {
  description = "EKS Admin IAM Role ARN"
  value       = module.iam.eks_admin_role_arn
}

output "eks_admin_role_name" {
  description = "EKS Admin IAM Role 이름"
  value = module.iam.eks_admin_role_name
}