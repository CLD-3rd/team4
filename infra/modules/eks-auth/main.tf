# EKS 클러스터 인증 데이터 가져오기
data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

# aws-auth ConfigMap 생성/업데이트
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = var.eks_admin_role_arn
        username = "admin:{{SessionName}}"
        groups   = ["system:masters"]
      }
    ])
  }

  depends_on = [data.aws_eks_cluster.cluster]
} 