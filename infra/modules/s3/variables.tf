variable "bucket_name" {
  description = "S3 버킷 이름"
  type        = string
}

variable "enable_bucket_policy" {
  description = "S3 버킷 정책 활성화 여부"
  type        = bool
  default     = false
}

variable "tags" {
  description = "리소스에 적용할 태그"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "memo"
  }
} 