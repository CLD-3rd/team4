provider "aws" {
  region  = var.region
  profile = var.profile
}

module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
}

module "eks" {
  source            = "./modules/eks"
  vpc_id            = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  project_name      = var.project_name
}

module "redis" {
  source            = "./modules/redis"
  vpc_id            = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  project_name      = var.project_name
}

module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
} 