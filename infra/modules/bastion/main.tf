# EC2 모듈 main.tf

# Bastion SG 생성
resource "aws_security_group" "bastion_sg" {
  name        = "memo-bastion-sg"
  description = "Allow SSH access to Bastion"
  vpc_id      = var.vpc_id  # 여기서 변수로 받음

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 보통 운영에서는 IP 제한해요
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "memo-bastion-sg"
  }
}

# 키페어 자동 생성 (로컬에서 생성 → 공개키만 AWS에 등록)
resource "tls_private_key" "bastion" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "bastion" {
  key_name   = "bastion-key"
  public_key = tls_private_key.bastion.public_key_openssh
}

resource "local_file" "bastion_private_key" {
  content          = tls_private_key.bastion.private_key_pem
  filename         = "${path.module}/bastion-key.pem"
  file_permission  = "0600"
}

# Bastion 생성
resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = aws_key_pair.bastion.key_name
  associate_public_ip_address = true

  # 아래처럼, 외부에서 받는 보안그룹 리스트에 방금 만든 보안그룹 ID를 추가해서 씁니다
  vpc_security_group_ids      = concat(var.security_group_ids, [aws_security_group.bastion_sg.id])

  tags = {
    Name = var.instance_name
  }
}

# EIP
resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion.id
  domain   = "vpc"

  tags = {
    Name = "${var.instance_name}-eip"
  }
}