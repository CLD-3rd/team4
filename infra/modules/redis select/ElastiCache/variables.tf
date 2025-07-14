# AWS ElastiCache로 운영 (variables.tf) - 주석처리됨
# variable "project" {
#   description = "프로젝트 이름"
#   type = string
# }

# variable "private_subnet_ids" {
#   description = "Redis가 속할 프라이빗 서브넷 ID 목록"
#   type = list(string)
# }

# variable "engine_version" {
#   description = "Redis 엔진 버전"
#   type    = string
#   default = "7.0"
# }

# variable "node_type" {
#   description = "Redis 인스턴스 타입"
#   type    = string
#   default = "cache.t3.medium"
# }

# variable "node_count" {
#   description = "Replica 갯수"
#   type    = number
#   default = 2
# }


# # SG그룹 관련 변수
# variable "redis_sg_id" {
#   description = "기존 Redis SG ID (없으면 새로 생성)"
#   type        = string
#   default     = ""      # 빈 문자열이면 SG 새로 생성
# }

# variable "vpc_id" {
#   description = "SG 생성 시 필요한 VPC ID"
#   type        = string
# }