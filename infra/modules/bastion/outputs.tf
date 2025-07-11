output "bastion_public_ip" {
  description = "Bastion 호스트 공인 IP"
  value       = aws_instance.bastion.public_ip
}

output "bastion_private_ip" {
  description = "Bastion 호스트 사설 IP"
  value       = aws_instance.bastion.private_ip
}

output "bastion_security_group_id" {
  description = "Bastion 보안 그룹 ID"
  value       = aws_security_group.bastion.id
} 