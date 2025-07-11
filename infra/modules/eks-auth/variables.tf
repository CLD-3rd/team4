variable "cluster_name" {
  description = "EKS 클러스터 이름"
  type        = string
}

variable "cluster_endpoint" {
  description = "EKS 클러스터 엔드포인트"
  type        = string
}

variable "cluster_certificate_authority_data" {
  description = "EKS 클러스터 CA 인증서 데이터"
  type        = string
}

variable "eks_admin_role_arn" {
  description = "EKS Admin Role의 ARN"
  type        = string
} 