# FluentBit IRSA 모듈 outputs.tf

output "service_account_name" {
  value = var.service_account_name
}

output "role_arn" {
  value = aws_iam_role.this.arn
}

output "role_name" {
  value = aws_iam_role.this.name
}

