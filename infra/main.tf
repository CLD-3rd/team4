# AWS
provider "aws" {
  region  = var.region
  profile = "base-user"
}

# AWS Account 정보 가져오기
data "aws_caller_identity" "current" {
}

# EKS 클러스터 인증 데이터
data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

# VPC
module "vpc" {
  source       = "./modules/vpc"
  project      = var.project
}

# IAM - EKS Admin Role
module "iam" {
  source = "./modules/iam"
  
  admin_user_arn = var.admin_user_arn
  project        = var.project
}

# EKS
module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  admin_user_arn = var.admin_user_arn
  project        = var.project
}

# S3
module "s3" {
  source = "./modules/s3"
  
  bucket_name = var.bucket_name
  tags        = var.tags
}

# RDS
module "rds" {
  source                    = "./modules/rds"
  name                      = "memo-mysql"
  engine_version            = "8.0.36"
  instance_class            = "db.t3.small"
  allocated_storage         = 20
  db_name                   = "memo"
  db_username               = var.db_username
  db_password               = var.db_password
  private_subnet_ids        = module.vpc.private_subnet_ids
  vpc_id                    = module.vpc.vpc_id
  allowed_security_group_ids = [module.eks.cluster_security_group_id]
  tags                      = var.tags
}
