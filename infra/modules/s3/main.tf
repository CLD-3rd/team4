# S3 버킷 생성
resource "aws_s3_bucket" "memo_bucket" {
  bucket = var.bucket_name

  tags = var.tags
}

# S3 버킷 버전 관리 설정
resource "aws_s3_bucket_versioning" "memo_bucket_versioning" {
  bucket = aws_s3_bucket.memo_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 버킷 서버 사이드 암호화 설정
resource "aws_s3_bucket_server_side_encryption_configuration" "memo_bucket_encryption" {
  bucket = aws_s3_bucket.memo_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 버킷 퍼블릭 액세스 차단 설정
resource "aws_s3_bucket_public_access_block" "memo_bucket_public_access_block" {
  bucket = aws_s3_bucket.memo_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 버킷 정책 (필요한 경우)
resource "aws_s3_bucket_policy" "memo_bucket_policy" {
  count  = var.enable_bucket_policy ? 1 : 0
  bucket = aws_s3_bucket.memo_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowEC2Access"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.memo_bucket.arn}/*"
      }
    ]
  })
} 