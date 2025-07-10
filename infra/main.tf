# AWS
provider "aws" {
  region = var.region
}



# VPC
module "vpc" {
  source  = "./modules/vpc"
  project = var.project
}



# EKS
module "eks" {
  source = "./modules/eks"

  # 250709 원서희: EKS 모듈 값 전달 관련 내용 수정
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  project         = var.project

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids # <-- EKS 모듈은 subnet_ids로 받음. 변수명 통일 - 김재신
  #project_name      = var.project             # <-- EKS 모듈은 project로 받음. 변수명 통일 - 김재신
  # 방법1: main.tf에서 private_subnet_ids → subnet_ids, project_name → project로 이름 변경해서 전달
  # subnet_ids      = module.vpc.private_subnet_ids
  # project         = var.project_name
  # 방법2: modules/eks/variables.tf에서 subnet_ids → private_subnet_ids, project → project_name으로 변수명 변경
}



# Redis
module "redis" {
  source = "./modules/redis"
}



# S3
module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
  environment = var.environment
  project     = var.project # project_name 에서 변수명 통일 - 김재신
}



# RDS
module "rds" {
  source             = "./modules/rds"
  name               = "myapp-mysql"
  engine_version     = "8.0.36"
  instance_class     = "db.t3.micro"
  allocated_storage  = 20
  db_name            = "memo"
  username           = var.db_username
  password           = var.db_password
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [aws_security_group.rds.id]
  tags               = var.tags
}
