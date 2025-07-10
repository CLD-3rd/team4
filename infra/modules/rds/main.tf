#RDS 서브넷
resource "aws_db_subnet_group" "memo_rds" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = var.tags
}

# RDS Security Group
resource "aws_security_group" "memo_rds" {
  name_prefix = "rds-sg-"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = var.allowed_security_group_ids
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # VPC 내부 트래픽만 허용
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
  vpc_security_group_ids = [aws_security_group.memo_rds.id]
  skip_final_snapshot    = true

  tags = var.tags
}
