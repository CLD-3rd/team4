
### VPC main 의 Variable 변수설정 - 김재신

# 250710 원서희: Project 관련 태그 변수 추가
variable "project" {
  description = "Project name or identifier"
  type        = string
}

variable "vpc_name" {
  description = "Name tag for the VPC resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_name" {
  description = "퍼블릭 서브넷 이름"
  type        = string
  default     = "vpc1-public1"
}

variable "public_subnet_cidr" {
  description = "퍼블릭 서브넷 CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_name" {
  description = "프라이빗 서브넷 이름"
  type        = string
  default     = "vpc1-private1"
}

variable "private_subnet_cidr" {
  description = "프라이빗 서브넷 CIDR"
  type        = string
  default     = "10.0.2.0/24"
}

variable "az" { #서울 a
  description = "서브넷이 생성될 가용 영역"
  type        = string
  default     = "ap-northeast-2a"
} 