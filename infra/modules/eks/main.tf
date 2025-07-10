module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.37.1"
  #  version         = "20.8.4" # 구버전 호환 문제로 최신 latest로 버전변경 - 김재신

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids # 변수명 통일 - 김재신

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      desired_size   = 2
      max_size       = 3
      min_size       = 1
      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
    }
  }

  tags = {
    Project = var.project
  }
}