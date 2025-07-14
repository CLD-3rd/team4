module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.37.1"
  #  version         = "20.8.4" # 구버전 호환 문제로 최신 latest로 버전변경 - 김재신

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids # 변수명 통일 - 김재신

  # 클러스터 엔드포인트 설정 -이거없으면 접근안됨 - 김재신
  cluster_endpoint_public_access = true
  cluster_endpoint_private_access = true

  eks_managed_node_group_defaults = {
    desired_size = 2
    max_size     = 3
    min_size     = 2
    instance_types = ["t3.large"]
    ami_type     = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    memo-eks-node = {
      desired_size = 2
      max_size     = 3
      min_size     = 2
      instance_types = ["t3.large"]
      ami_type     = "AL2_x86_64"
    }
  }

  #Access  Entries 설정 (최신 EKS 모듈 방식)
  access_entries = {
    admin = {
      principal_arn    = var.admin_user_arn
      type             = "STANDARD"
    }
  }

  # KMS 비활성화
  create_kms_key = false
  cluster_encryption_config = {}

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
  security_group_id = module.eks_cluster.cluster_security_group_id
  description       = "External access to EKS cluster API"
}

resource "aws_security_group_rule" "eks_cluster_external_access_6443" {
  type              = "ingress"
  from_port         = 6443
  to_port           = 6443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.eks_cluster.cluster_security_group_id
  description       = "External access to EKS cluster API (6443)"
}

resource "aws_security_group_rule" "eks_cluster_external_access_10250" {
  type              = "ingress"
  from_port         = 10250
  to_port           = 10250
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.eks_cluster.cluster_security_group_id
  description       = "External access to EKS kubelet API"
}

# EKS Access Policy Association - 관리자 권한 부여
resource "aws_eks_access_policy_association" "admin" {
  depends_on = [module.eks_cluster]
  
  cluster_name   = var.cluster_name
  principal_arn  = var.admin_user_arn
  policy_arn     = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  access_scope {
    type = "cluster"
  }
}