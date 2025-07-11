# SSH 키 페어 생성
resource "aws_key_pair" "memo_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)

  tags = {
    Name    = var.key_name
    Project = var.project
  }
} 