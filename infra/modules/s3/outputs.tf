output "bucket_id" {
  description = "S3 버킷 ID"
  value       = aws_s3_bucket.memo_image_bucket.id
}

output "bucket_arn" {
  description = "S3 버킷 ARN"
  value       = aws_s3_bucket.memo_image_bucket.arn
}
