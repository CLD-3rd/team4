variable "region" {
  description = "AWS 리전"
  type        = string
}

variable "profile" {
  description = "AWS CLI 프로파일"
  type        = string
}

variable "project_name" {
  description = "프로젝트 리소스 네이밍 prefix"
  type        = string
} 