provider "aws" {
  region  = var.region
  profile = var.profile
}



# VPC
module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
}



# EKS
module "eks" {
  source            = "./modules/eks"
  vpc_id            = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  project_name      = var.project_name
}



# Redis
module "redis" {
  source            = "./modules/redis"
  vpc_id            = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  project_name      = var.project_name
}



# S3
module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
} 



# RDS
module "rds" {
  source              = "./modules/rds"
  name                = "myapp-mysql"
  engine_version      = "8.0.36"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  db_name             = "memo"
  username            = var.db_username
  password            = var.db_password
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [aws_security_group.rds.id]
  tags                = var.tags
}