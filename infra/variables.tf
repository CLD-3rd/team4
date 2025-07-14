variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "profile" {
  description = "AWS CLI 프로파일"
  type        = string
}

variable "admin_user_arn" {
  description = "관리자 IAM 사용자의 ARN (예: arn:aws:iam::123456789012:user/your-username)"
  type        = string
}

variable "project" {
  description = "프로젝트 명"
  type        = string
}


# EKS
variable "cluster_name" {
  description = "EKS 클러스터 이름"
  type        = string
  default     = "memo-eks-cluster" # 수정: 실제 존재하는 클러스터 이름으로 기본값 지정
}

variable "cluster_version" {
  description = "EKS 쿠버네티스 버전"
  type        = string
}





# RDS
variable "db_name" {
  type        = string
  description = "RDS database name"
}

variable "db_username" {
  type        = string
  description = "RDS master username"
  default     = "admin" # 또는 default 없이 따로 입력받기
}

variable "db_password" {
  type        = string
  description = "RDS master user password"
  sensitive   = true
}

# S3
variable "bucket_name" {
  description = "S3 버킷 이름"
  type        = string
}

# Tags
variable "tags" {
  type        = map(string)
  description = "리소스에 적용할 태그"
  default = {
    Environment = "dev"
    Project     = "memo"
  }
}