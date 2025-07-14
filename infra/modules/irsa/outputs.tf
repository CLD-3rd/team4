# IRSA 모듈 outputs.tf

output "role_arn" {
  description = "IRSA로 생성된 IAM Role ARN"
  value       = aws_iam_role.this.arn
}
