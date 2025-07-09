output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "s3_bucket_name" {
  value = module.s3.bucket_name
}

output "redis_endpoint" {
  value = module.redis.endpoint
} 