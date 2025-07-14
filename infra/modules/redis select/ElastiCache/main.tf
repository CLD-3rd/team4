# AWS ElastiCache로 운영 (main.tf) - 주석처리됨
# resource "aws_elasticache_subnet_group" "redis_subnet_group" {
#   name       = "${var.project}-redis-subnet-group"
#   subnet_ids = var.private_subnet_ids
# }

# # AWS ElastiCache SG그룹
# resource "aws_security_group" "memo_redis_sg" {
#   count       = var.redis_sg_id == "" ? 1 : 0
#   name        = "${var.project}-redis-sg"
#   description = "Redis security group"
#   vpc_id      = var.vpc_id

#   ingress {
#     from_port   = 6379
#     to_port     = 6379
#     protocol    = "tcp"
#     cidr_blocks = ["10.0.2.0/24","10.0.3.0/24"]   # 테스트 이후 프라이빗 서브넷의 보안그룹으로 업데이트 필요!!!
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name    = "${var.project}-redis-sg"
#     Project = var.project
#   }
# }
# # SG ID 동적으로 선택
# locals {
#   final_redis_sg_id = var.redis_sg_id != "" ? var.redis_sg_id : aws_security_group.memo_redis_sg[0].id
# }

# #AWS ElastiCache 생성
# resource "aws_elasticache_replication_group" "redis" {
#   replication_group_id          = "${var.project}-redis"
#   replication_group_description = "Redis Replication Group"
#   engine                        = "redis"
#   engine_version                = var.engine_version
#   node_type                     = var.node_type
#   number_cache_clusters         = var.node_count
#   automatic_failover_enabled    = true		    # 자동 failover 기능, 
#   port                          = 6379

#   subnet_group_name  = aws_elasticache_subnet_group.redis_subnet_group.name
#   security_group_ids = [local.final_redis_sg_id]

#   tags = {
#     Project = var.project
#   }
# }