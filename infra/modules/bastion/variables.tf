variable "project" {
  description = "프로젝트 명"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_id" {
  description = "퍼블릭 서브넷 ID"
  type        = string
}

variable "key_name" {
  description = "SSH 키 페어 이름"
  type        = string
  default     = "memo-key"
}

variable "eks_cluster_security_group_id" {
  description = "EKS 클러스터 보안 그룹 ID"
  type        = string
}

variable "eks_admin_role_arn" {
  description = "EKS Admin Role ARN"
  type        = string
} 