resource "aws_s3_bucket" "memo_image_bucket" {
  bucket = var.bucket_name
  force_destroy = true

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.memo_image_bucket.id
  acl    = "private"
}