#######################################

# Helm으로 생성하는 코드
# Helm에서 tag 사용 안 함, aws 리소스가 아니기 때문!
variable "name" { default = "memo-redis" }
variable "namespace" { default = "default" }
variable "chart_version" { default = "21.2.9" } # latest 버전 변경 - 김재신 
variable "auth_enabled" { default = "false" } # 간단히 테스트할 경우 패스워드 비활성화
variable "persistence_enabled" { default = "false" }
variable "replica_count" { default = "1" }