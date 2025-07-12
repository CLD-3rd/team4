output "eks_admin_role_arn" {
  description = "EKS Admin Role의 ARN"
  value       = aws_iam_role.eks_admin_role.arn
}

output "eks_admin_role_name" {
  description = "EKS Admin Role의 이름"
  value       = aws_iam_role.eks_admin_role.name
}