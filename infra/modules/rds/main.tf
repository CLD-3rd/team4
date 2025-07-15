# RDS 서브넷 그룹 생성
resource "aws_db_subnet_group" "memo_rds" {
  name       = "memo-mysql-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = var.tags
}

output "subnet_group_name" {
  description = "RDS Subnet Group Name"
  value       = aws_db_subnet_group.memo_rds.name
}

# RDS Security Group - 기존 루트 main.tf 에서 모듈로 이동 관리편이 - 김재신
resource "aws_security_group" "memo_rds" {
  name_prefix = "memo-rds-sg-"
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
  identifier             = "memo-mysql"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  engine                 = "mysql"
  engine_version         = var.engine_version
  instance_class         = "db.t3.medium"  # 최신 MySQL 버전과 호환되는 인스턴스 타입으로 변경
  allocated_storage      = 20  # 20GB로 고정
  db_subnet_group_name   = aws_db_subnet_group.memo_rds.name
  vpc_security_group_ids = [aws_security_group.memo_rds.id]
  skip_final_snapshot    = true
  deletion_protection    = false
  multi_az               = false
  publicly_accessible    = false
  storage_encrypted      = false  # 암호화 비활성화

  tags                   = var.tags
}
