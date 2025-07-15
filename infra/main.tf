# AWS
provider "aws" {
  region  = var.region
  profile = "base-user"
}

# Helm Provider (수정: kubernetes 블록 → kubernetes 인자)
provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
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
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "memo-vpc"
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

# EBS CSI Driver 설치 (Redis PVC를 위해 필요)
module "ebs_csi_driver" {
  source = "./modules/ebs-csi-driver"
  
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url

  depends_on = [
    module.eks
  ]
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
  instance_class            = "db.t3.medium"
  allocated_storage         = 20
  db_name                   = "memo-app"
  db_username               = var.db_username
  db_password               = var.db_password
  private_subnet_ids        = module.vpc.private_subnet_ids
  vpc_id                    = module.vpc.vpc_id
  allowed_security_group_ids = [module.eks.cluster_security_group_id]
  tags                      = var.tags
}

# Bastion
module "bastion" {
  source         = "./modules/bastion"
  ami_id         = "ami-096990086b675eb99"          # 사용 중인 Ubuntu 또는 Amazon Linux AMI ID
  instance_type  = "t3.large"
  key_name       = "bastion-key"
  vpc_id         = module.vpc.vpc_id
  subnet_id      = module.vpc.public_subnet_ids[0]
  instance_name  = "memo-bastion"
}

# Prometheus - kube-prometheus-stack 설치
module "prometheus" {
  source = "./modules/prometheus"
  depends_on = [module.ebs_csi_driver]
}

# Grafana 설치
module "grafana" {
  source = "./modules/grafana"
  depends_on = [module.prometheus]
}

# Redis - Helm Chart를 통한 EKS 배포
module "redis_helm" {
  source = "./modules/redis select/Helm"
  
  name              = "redis-app"
  namespace         = "default"
  chart_version     = "18.0.0"
  auth_enabled      = "false"
  persistence_enabled = "true"
  replica_count     = "1"
  
  depends_on = [module.ebs_csi_driver]
}