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
  instance_class            = "db.t3.medium"
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
  oidc_provider_url    = "oidc.eks.ap-northeast-2.amazonaws.com/id/174009068958FC8C33EFD5A601D6A4E8"    # 실제 OIDC URL
  oidc_provider_arn    = "arn:aws:iam::727646470302:oidc-provider/oidc.eks.ap-northeast-2.amazonaws.com/id/174009068958FC8C33EFD5A601D6A4E8"
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

# Bastion
module "bastion" {
  source         = "./modules/bastion"
  ami_id         = "ami-096990086b675eb99"          # 사용 중인 Ubuntu 또는 Amazon Linux AMI ID
  instance_type  = "t3.large"
  key_name       = "bastion-key"
  vpc_id         = module.vpc.vpc_id
  subnet_id      = module.vpc.public_subnet_id
  instance_name  = "bastion"    #memo-bastion으로 변경하기
}

# FluentBit의 로그 그룹 리소스 먼저 정의
resource "aws_cloudwatch_log_group" "fluentbit" {
  name              = "/aws/eks/cluster-logs"
  retention_in_days = 7
}
# FluentBit IRSA 호출
module "fluentbit_irsa" {
  source = "./modules/fluentbitirsa"

  role_name            = "fluent-bit-irsa-role"
  namespace            = "amazon-cloudwatch"
  service_account_name = "fluent-bit-sa"
  oidc_provider_url    = "https://oidc.eks.ap-northeast-2.amazonaws.com/id/174009068958FC8C33EFD5A601D6A4E8"
  oidc_provider_arn    = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.ap-northeast-2.amazonaws.com/id/174009068958FC8C33EFD5A601D6A4E8"

 # Fluent Bit 전용 CloudWatch 로그 권한 정책 ARN
  policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]
}

module "fluentbit" {
  source         = "./modules/fluentbit"
  namespace      = "amazon-cloudwatch"
  service_account_name = module.fluentbit_irsa.service_account_name
  log_group_name      = aws_cloudwatch_log_group.fluentbit.name
}