provider "aws" {
  region  = var.region
  profile = var.profile
}

module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project
}

module "eks" {
  source            = "./modules/eks"
  vpc_id            = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids # <-- EKS 모듈은 subnet_ids로 받음. 변수명 통일 - 김재신
  project_name      = var.project             # <-- EKS 모듈은 project로 받음. 변수명 통일 - 김재신
  # 방법1: main.tf에서 private_subnet_ids → subnet_ids, project_name → project로 이름 변경해서 전달
  # subnet_ids      = module.vpc.private_subnet_ids
  # project         = var.project_name
  # 방법2: modules/eks/variables.tf에서 subnet_ids → private_subnet_ids, project → project_name으로 변수명 변경
}

module "redis" {
  source            = "./modules/redis"
  vpc_id            = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids # <-- redis 모듈에서는 해당 변수 사용 안함. 불필요하면 제거 가능
  project_name      = var.project_name              # <-- redis 모듈에서도 사용 안함. 불필요하면 제거 가능
}

module "s3" {
  source       = "./modules/s3"
  project_name = var.project # project_name 에서 변수명 통일 - 김재신

} 
