# EC2 모듈 variables.tf

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.large"
}

variable "subnet_id" {
  description = "Subnet ID for Bastion instance"
  type = string
}

variable "vpc_id" {
  description = "VPC ID where Bastion will be deployed"
  type        = string
}

# SSH 키페어는 Terraform이 자동으로 생성/등록하며, bastion-key.pem 파일이 이 모듈 디렉토리에 저장됩니다.

variable "instance_name" {
  description = "Name tag for EC2 instance"
  type = string
}

variable "security_group_ids" {
  description = "Additional security group IDs to attach"
  type = list(string)
  default = []
}