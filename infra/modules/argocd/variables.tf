# ArgoCD 모듈 variables.tf

variable "namespace" {
  type        = string
  description = "ArgoCD를 설치할 네임스페이스"
}

variable "irsa_role_arn" {
  type        = string
  description = "IRSA에서 생성된 IAM Role ARN"
}

