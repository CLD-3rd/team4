# Helm으로 생성하는 코드
output "redis_release_name" {
  value = helm_release.redis.name
}

output "redis_status" {
  value = helm_release.redis.status
}

output "redis_port" {
  value = 6379
}