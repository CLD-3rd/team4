# 변수 정의
variable "name" { default = "memo-redis" }
variable "namespace" { default = "default" }
<<<<<<< HEAD
variable "chart_version" { default = "19.4.3" }
variable "auth_enabled" { default = "false" } # 간단히 테스트할 경우 패스워드 비활성화
=======
variable "chart_version" { default = "18.11.1" }
variable "auth_enabled" { default = "false" } 	# 간단히 테스트할 경우 패스워드 비활성화
>>>>>>> ff4d9635a2a2f7804ab69877be31b00fec81f4ee
variable "persistence_enabled" { default = "false" }
variable "replica_count" { default = "1" }

variable "tags" {
  description = "리소스에 적용할 태그"
  type        = map(string)
  default     = {}
}