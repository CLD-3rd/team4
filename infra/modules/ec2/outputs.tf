# EC2 모듈 outputs.tf

output "instance_id" {
  value = aws_instance.web.id
}

output "instance_public_ip" {
  value = aws_eip.web_eip.public_ip
}
