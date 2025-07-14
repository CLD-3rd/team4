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
  project      = var.project
}

# EC2 eip 설정 호출
module "ec2" {
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

# EBS CSI Driver 설치 (Redis PVC를 위해 필요)
module "ebs_csi_driver" {
  source = "./modules/ebs-csi-driver"
  
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url
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

# ArgoCD 전용 IRSA 생성
module "irsa_argocd" {
  source = "./modules/irsa"

  role_name            = "argocd-irsa-role"
  namespace            = "argocd"
  service_account_name = "argocd-service-account"
  oidc_provider_url    = "oidc.eks.ap-northeast-2.amazonaws.com/id/EXAMPLEDID"    # 본인의 OIDC URL
  oidc_provider_arn    = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.ap-northeast-2.amazonaws.com/id/EXAMPLEDID"
}

# ArgoCD 설치
module "argocd" {
  source = "./modules/argocd"

  namespace     = "argocd"
  irsa_role_arn = module.irsa_argocd.role_arn

  providers = {
    helm       = helm
    kubernetes = kubernetes
  }
  depends_on = [module.irsa_argocd]
}
