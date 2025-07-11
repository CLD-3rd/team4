# AWS
provider "aws" {
  region  = var.region
  profile = "base-user"
}

# Kubernetes Provider 설정
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.cluster.token
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

# VPC Endpoint for EKS API
module "vpc_endpoint" {
  source = "./modules/vpc-endpoint"
  
  project           = var.project
  vpc_id            = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}

# SSH 키 페어
module "ssh_key" {
  source = "./modules/ssh-key"
  
  key_name = "memo-key"
  project  = var.project
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

  # 250709 원서희: EKS 모듈 값 전달 관련 내용 수정
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  project         = var.project

  vpc_id            = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids # <-- 2개 프라이빗 서브넷 ID 리스트
  #project_name      = var.project             # <-- EKS 모듈은 project로 받음. 변수명 통일 - 김재신
  # 방법1: main.tf에서 private_subnet_ids → subnet_ids, project_name → project로 이름 변경해서 전달
  # subnet_ids      = module.vpc.private_subnet_ids
  # project         = var.project_name
  # 방법2: modules/eks/variables.tf에서 subnet_ids → private_subnet_ids, project → project_name으로 변수명 변경
}

# Bastion 호스트
module "bastion" {
  source = "./modules/bastion"
  
  project                        = var.project
  vpc_id                         = module.vpc.vpc_id
  public_subnet_id               = module.vpc.public_subnet_id
  key_name                       = module.ssh_key.key_name
  eks_cluster_security_group_id  = module.eks.cluster_security_group_id
  eks_admin_role_arn             = module.iam.eks_admin_role_arn
  
  depends_on = [module.eks]
}

# EKS Auth - aws-auth ConfigMap
module "eks_auth" {
  source = "./modules/eks-auth"
  
  cluster_name                    = module.eks.cluster_name
  cluster_endpoint                = module.eks.cluster_endpoint
  cluster_certificate_authority_data = module.eks.cluster_ca_certificate
  eks_admin_role_arn              = module.iam.eks_admin_role_arn
  
  depends_on = [module.eks]
}



# Redis (네트워크 문제 해결 후 활성화)
# module "redis" {
#   source            = "./modules/redis"
# }



# S3
module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
  environment = var.environment
  project     = var.project # project_name 에서 변수명 통일 - 김재신
}



# RDS
module "rds" {
  source                    = "./modules/rds"
  name                      = "myapp-mysql"
  engine_version            = "8.0.36"
  instance_class            = "db.t3.micro"
  allocated_storage         = 20
  db_name                   = "memo"
  db_username               = var.db_username
  db_password               = var.db_password
  private_subnet_ids        = module.vpc.private_subnet_ids
  vpc_id                    = module.vpc.vpc_id
  allowed_security_group_ids = [module.eks.cluster_security_group_id]
  tags                      = var.tags
}
