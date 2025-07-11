# EKS Cluster 정보
output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

# IAM Role 정보
output "eks_admin_role_arn" {
  value = module.iam.eks_admin_role_arn
}

output "eks_admin_role_name" {
  value = module.iam.eks_admin_role_name
}

# S3 정보
output "s3_bucket_name" {
  value = module.s3.bucket_name
}

# Bastion 호스트 정보
output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}

output "bastion_private_ip" {
  value = module.bastion.bastion_private_ip
}

## 0709 - redis 엔드포인트 관련 redis/ouput.tf에 endpoint 설정 필요 - 김재신
#output "redis_endpoint" {
#  value = module.redis.redis_status
#}