variable "cluster_name" {
  type        = string
  description = "EKS 클러스터 이름"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet ID 리스트"
}

variable "project" {
  type        = string
  description = "프로젝트명"
}