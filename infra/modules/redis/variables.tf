# 변수 정의
variable "name" { default = "memo-redis" }
variable "namespace" { default = "default" }
variable "chart_version" { default = "18.11.1" }
variable "auth_enabled" { default = "false" } 	# 간단히 테스트할 경우 패스워드 비활성화
variable "persistence_enabled" { default = "false" }
variable "replica_count" { default = "1" }

variable "tags" {
  description = "리소스에 적용할 태그"
  type        = map(string)
  default     = {}
}