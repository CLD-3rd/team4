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