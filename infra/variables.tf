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