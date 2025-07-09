output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "s3_bucket_name" {
  value = module.s3.bucket_name
}
## 0709 - redis 엔드포인트 관련 redis/ouput.tf에 endpoint 설정 필요 - 김재신
output "redis_endpoint" {
  value = module.redis.endpoint
} 