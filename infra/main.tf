# AWS
provider "aws" {
  region  = var.region
  profile = "base-user"
}



# VPC
module "vpc" {
  source       = "./modules/vpc"
  project      = var.project
}



# EKS
module "eks" {
  source            = "./modules/eks"

# 250709 원서희: EKS 모듈 값 전달 관련 내용 수정
  cluster_name      = var.cluster_name
  cluster_version   = var.cluster_version
  project           = var.project

  vpc_id            = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids # <-- 2개 프라이빗 서브넷 ID 리스트
  #project_name      = var.project             # <-- EKS 모듈은 project로 받음. 변수명 통일 - 김재신
    # 방법1: main.tf에서 private_subnet_ids → subnet_ids, project_name → project로 이름 변경해서 전달
    # subnet_ids      = module.vpc.private_subnet_ids
    # project         = var.project_name
    # 방법2: modules/eks/variables.tf에서 subnet_ids → private_subnet_ids, project → project_name으로 변수명 변경
}



# Redis
# module "redis" {
#   source            = "./modules/redis"
#   tags              = var.tags
# }



# S3
# module "s3" {
#   source      = "./modules/s3"
#   bucket_name = var.bucket_name
#   environment = var.environment
#   project = var.project # project_name 에서 변수명 통일 - 김재신
# }

# RDS Security Group - sg 추가 -김재신
# resource "aws_security_group" "rds" {
#   name_prefix = "rds-sg-"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     from_port       = 3306
#     to_port         = 3306
#     protocol        = "tcp"
#     security_groups = [module.eks.cluster_security_group_id]
#   }

#   egress { # 보안성 수정 전체허용 >> port , cidr_blocks 내부로 제한 - 김재신
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#     cidr_blocks = ["10.0.0.0/16"]  # VPC 내부 트래픽만 허용
#   }

#   tags = var.tags
# }

# RDS
# module "rds" {
#   source              = "./modules/rds"
#   name                = "myapp-mysql"
#   engine_version      = "8.0.36"
#   instance_class      = "db.t3.micro"
#   allocated_storage   = 20
#   db_name             = "memo"
#   username            = var.db_username
#   password            = var.db_password
#   private_subnet_ids = [module.vpc.private_subnet_id] # <-- private_subnet_ids로 변수명 통일 - 김재신
#   security_group_ids  = [aws_security_group.rds.id]
#   tags                = var.tags
# }
