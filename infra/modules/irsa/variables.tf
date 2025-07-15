# IRSA 모듈 variables.tf

variable "role_name" {
  type        = string
  description = "생성할 IAM Role 이름"
}

variable "namespace" {
  type        = string
  description = "서비스 계정이 존재하는 Kubernetes 네임스페이스"
}

variable "service_account_name" {
  type        = string
  description = "IAM Role과 연결할 Kubernetes 서비스 계정 이름"
}

variable "oidc_provider_url" {
  type        = string
  description = "OIDC 공급자 URL (https://oidc.eks.<region>.amazonaws.com/id/XXXX)"
}

variable "oidc_provider_arn" {
  type        = string
  description = "OIDC 공급자 ARN (arn:aws:iam::<account-id>:oidc-provider/...)"
}

variable "policy_arns" {
  type        = list(string)
  description = "IAM Role에 붙일 정책 ARN 리스트"
  default     = []
}

