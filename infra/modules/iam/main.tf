# EKS Admin Role 생성
resource "aws_iam_role" "eks_admin_role" {
  name = "eks-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.admin_user_arn
        }
      },
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::727646470302:role/memo-bastion-role"
        }
      }
    ]
  })

  tags = {
    Name    = "eks-admin-role"
    Project = var.project
  }
}

# AdministratorAccess 정책 연결
resource "aws_iam_role_policy_attachment" "eks_admin_role_policy" {
  role       = aws_iam_role.eks_admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
} 