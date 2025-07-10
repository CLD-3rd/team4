resource "aws_s3_bucket" "memo_image_bucket" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Project     = var.project
  }
}

# ACL 대신 버킷 소유권 설정 사용
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.memo_image_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# 버킷 공개 액세스 차단 설정
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.memo_image_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}