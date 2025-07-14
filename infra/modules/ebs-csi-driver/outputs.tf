output "ebs_csi_role_arn" {
  description = "EBS CSI Driver IAM Role ARN"
  value       = aws_iam_role.ebs_csi_role.arn
} 