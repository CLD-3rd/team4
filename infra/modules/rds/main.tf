#RDS 서브넷
resource "aws_db_subnet_group" "memo_rds" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = var.tags
}



# RDS sg그룹
resource "aws_security_group" "memo_rds" {
  count       = length(var.security_group_ids) == 0 ? 1 : 0
  name        = "${var.name}-sg"
  description = "Default security group for RDS"
  vpc_id      = var.vpc_id  # ← 필요 시 변수로 받아야 함

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 테스트용, 실운영 시 좁혀야 함
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}


# RDS 생성
resource "aws_db_instance" "memo_rds" {
  identifier             = var.name
  db_name                = var.db_name
  db_username               = var.db_username
  db_password               = var.db_password
  engine                 = "mysql"
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  db_subnet_group_name   = aws_db_subnet_group.memo_rds.name
  vpc_security_group_ids = length(var.security_group_ids) == 0 ? [aws_security_group.memo_rds[0].id] : var.security_group_ids
  skip_final_snapshot    = true

  tags = var.tags
}