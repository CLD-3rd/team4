variable "key_name" {
  description = "SSH 키 페어 이름"
  type        = string
  default     = "memo-key"
}

variable "public_key_path" {
  description = "공개키 파일 경로"
  type        = string
  default     = "./memo-key.pub"
}

variable "project" {
  description = "프로젝트 명"
  type        = string
} 