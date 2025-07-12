output "bucket_name" {
  description = "S3 버킷 이름"
  value       = aws_s3_bucket.memo_bucket.bucket
}

output "bucket_arn" {
  description = "S3 버킷 ARN"
  value       = aws_s3_bucket.memo_bucket.arn
}

output "bucket_id" {
  description = "S3 버킷 ID"
  value       = aws_s3_bucket.memo_bucket.id
} 