# AWS ElastiCache로 운영 (outputs.tf)
output "redis_primary_endpoint" {
  value = aws_elasticache_replication_group.redis.primary_endpoint_address
}

output "redis_reader_endpoint" {
  value = aws_elasticache_replication_group.redis.reader_endpoint_address
}


#SG그룹 관련 outputs
output "redis_security_group_id" {
  value = local.final_redis_sg_id
}