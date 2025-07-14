# EBS CSI Driver 설치 모듈
resource "helm_release" "aws_ebs_csi_driver" {
  name       = "aws-ebs-csi-driver"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  version    = "2.28.0"
  wait       = false

  set = [
    {
      name  = "controller.serviceAccount.create"
      value = "true"
    },
    {
      name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_iam_role.ebs_csi_role.arn
    }
  ]

  depends_on = [aws_iam_role.ebs_csi_role, aws_iam_role_policy_attachment.ebs_csi_policy]
}

# EBS CSI Driver용 IAM Role
resource "aws_iam_role" "ebs_csi_role" {
  name = "AmazonEKS_EBS_CSI_DriverRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(var.oidc_provider_url, "https://", "")}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })
}

# EBS CSI Driver 정책 연결
resource "aws_iam_role_policy_attachment" "ebs_csi_policy" {
  role       = aws_iam_role.ebs_csi_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
} 