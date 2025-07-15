### VPC main 의 Variable 변수설정 - 김재신

# 250710 원서희: Project 관련 태그 변수 추가
variable "project" {
  description = "Project name or identifier"
  type        = string
}

variable "vpc_name" {
  description = "Name tag for the VPC resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
