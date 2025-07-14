# FluentBit IRSA 모듈 outputs.tf

output "service_account_name" {
  value = kubernetes_service_account.this.metadata[0].name
}

output "role_arn" {
  value = aws_iam_role.this.arn
}

output "role_name" {
  value = aws_iam_role.this.name
}

