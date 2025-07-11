# EKS API를 위한 VPC Endpoint
resource "aws_vpc_endpoint" "eks_api" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.ap-northeast-2.eks"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoint.id]

  private_dns_enabled = true

  tags = {
    Name    = "${var.project}-eks-api-endpoint"
    Project = var.project
  }
}

# VPC Endpoint 보안 그룹
resource "aws_security_group" "vpc_endpoint" {
  name_prefix = "${var.project}-vpc-endpoint-"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # VPC CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project}-vpc-endpoint-sg"
    Project = var.project
  }
} 