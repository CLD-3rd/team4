variable "bucket_name" {
  description = "S3 버킷 이름"
  type        = string
}

variable "environment" {
  description = "환경 이름 (ex: dev, prod)"
  type        = string
}

variable "project" {
  description = "프로젝트 이름"
  type        = string
}