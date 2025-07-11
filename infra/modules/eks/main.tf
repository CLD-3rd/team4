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

# EKS 클러스터 보안 그룹에 외부 접근 규칙 추가
resource "aws_security_group_rule" "eks_cluster_external_access" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.eks.cluster_security_group_id
  description       = "External access to EKS cluster API"
}

resource "aws_security_group_rule" "eks_cluster_external_access_6443" {
  type              = "ingress"
  from_port         = 6443
  to_port           = 6443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.eks.cluster_security_group_id
  description       = "External access to EKS cluster API (6443)"
}

resource "aws_security_group_rule" "eks_cluster_external_access_10250" {
  type              = "ingress"
  from_port         = 10250
  to_port           = 10250
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.eks.cluster_security_group_id
  description       = "External access to EKS kubelet API"
}