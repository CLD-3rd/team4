# 최신 Amazon Linux 2023 AMI 가져오기
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Bastion 호스트용 IAM Role
resource "aws_iam_role" "bastion_role" {
  name = "${var.project}-bastion-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name    = "${var.project}-bastion-role"
    Project = var.project
  }
}

# Bastion IAM Role에 EKS 정책 연결
resource "aws_iam_role_policy_attachment" "bastion_eks_policy" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "bastion_eks_worker_policy" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Bastion Role이 eks-admin-role을 assume할 수 있도록 정책 추가
resource "aws_iam_role_policy" "bastion_assume_eks_admin" {
  name = "${var.project}-bastion-assume-eks-admin"
  role = aws_iam_role.bastion_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Resource = var.eks_admin_role_arn
      }
    ]
  })
}

# Bastion IAM Instance Profile
resource "aws_iam_instance_profile" "bastion_profile" {
  name = "${var.project}-bastion-profile"
  role = aws_iam_role.bastion_role.name
}

# Bastion 호스트 생성
resource "aws_instance" "bastion" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"
  subnet_id     = var.public_subnet_id
  key_name      = var.key_name
  iam_instance_profile = aws_iam_instance_profile.bastion_profile.name

  vpc_security_group_ids = [aws_security_group.bastion.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y kubectl
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              ./aws/install
              EOF

  tags = {
    Name    = "${var.project}-bastion"
    Project = var.project
  }
}

# Bastion 보안 그룹
resource "aws_security_group" "bastion" {
  name_prefix = "${var.project}-bastion-"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project}-bastion-sg"
    Project = var.project
  }
}

# EKS 클러스터 보안 그룹에 Bastion 접근 허용
resource "aws_security_group_rule" "eks_from_bastion" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion.id
  security_group_id        = var.eks_cluster_security_group_id
  description              = "Bastion to EKS cluster"
} 