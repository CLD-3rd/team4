variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "profile" {
  description = "AWS CLI 프로파일"
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
}

variable "cluster_version" {
  description = "EKS 쿠버네티스 버전"
  type        = string
}


# S3
variable "bucket_name" {
  type        = string
  description = "S3 버킷 이름"
}

variable "environment" {
  type        = string
  description = "환경 이름 (dev, prod 등)"
}


# RDS
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

# Tags
variable "tags" {
  type        = map(string)
  description = "리소스에 적용할 태그"
  default = {
    Environment = "dev"
    Project     = "pung"
  }
}