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

# Bastion 생성
resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
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