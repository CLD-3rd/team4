# EC2 모듈 outputs.tf

output "instance_id" {
  description = "The ID of the Bastion EC2 instance"
  value = aws_instance.bastion.id
}

output "public_ip" {
  description = "The public IP address of the Bastion EC2 instance"
  value = aws_eip.bastion_eip.public_ip
}

output "public_dns" {
  description = "The public DNS of the Bastion EC2 instance"
  value = aws_instance.bastion.public_dns
}