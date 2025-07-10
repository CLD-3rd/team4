#RDS
variable "name" {
  description = "RDS instance identifier"
  type        = string
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "db_username" {
  description = "Master username"
  type        = string
}

variable "db_password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "engine_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0.36"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Storage in GB"
  type        = number
  default     = 20
}



variable "private_subnet_ids" {
  description = "Subnet IDs for DB subnet group"
  type        = list(string)
}

variable "security_group_ids" {
  description = "사용할 보안 그룹 ID 목록. 비어있으면 새로 생성함"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "보안 그룹 생성을 위한 VPC ID"
  type        = string
}


variable "tags" {
  description = "RDS 공통 태그"
  type        = map(string)
  default     = {}
}