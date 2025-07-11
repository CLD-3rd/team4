variable "project" {
  description = "프로젝트 명"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "프라이빗 서브넷 ID 리스트"
  type        = list(string)
} 