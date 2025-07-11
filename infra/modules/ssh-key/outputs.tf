output "key_name" {
  description = "SSH 키 페어 이름"
  value       = aws_key_pair.memo_key.key_name
} 