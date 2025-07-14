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

variable "key_name" {
  description = "SSH key pair name"
  type = string
}

variable "instance_name" {
  description = "Name tag for EC2 instance"
  type = string
}

variable "security_group_ids" {
  description = "Additional security group IDs to attach"
  type = list(string)
  default = []
}