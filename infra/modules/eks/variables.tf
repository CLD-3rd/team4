// EKS 모듈 변수명 관련 안내
// 상위(main.tf)에서 private_subnet_ids, project_name으로 전달됨
// 1. main.tf에서 project로 이름 변경해서 전달
// 2. 이 파일에서 private_subnet_ids로 변수명 변경
// 아래는 현재 상태
variable "cluster_name" {
  type        = string
  description = "EKS 클러스터 이름"
}

variable "cluster_version" {
  type        = string
  description = "EKS 클러스터 Version"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "private_subnet_ids" { # 변수명 통일 - 김재신
  type        = list(string)
  description = "Subnet ID 리스트"
}

variable "project" { # 상위 모듈 변수명 통일 - 김재신
  type        = string
  description = "프로젝트명"
}

variable "admin_user_arn" {
  type        = string
  description = "EKS 관리자 사용자 ARN"
}