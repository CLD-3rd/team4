### VPC 설정 모듈 (요약:1VPC 1Private 1Public ) - 김재신
resource "aws_vpc" "memo-vpc" { # vpc 생성
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = var.vpc_name
  }
}

# Public Subnet 생성
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.memo-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "memo-vpc-public-a"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.memo-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "memo-vpc-public-b"
  }
}

# Private Subnet 생성
resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.memo-vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = false
  tags = {
    Name = "memo-vpc-private-a"
  }
}

resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.memo-vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "ap-northeast-2b"
  map_public_ip_on_launch = false
  tags = {
    Name = "memo-vpc-private-b"
  }
}

resource "aws_subnet" "private3" {
  vpc_id                  = aws_vpc.memo-vpc.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = false
  tags = {
    Name = "memo-vpc-private-c"
  }
}

resource "aws_subnet" "private4" {
  vpc_id                  = aws_vpc.memo-vpc.id
  cidr_block              = "10.0.6.0/24"
  availability_zone       = "ap-northeast-2d"
  map_public_ip_on_launch = false
  tags = {
    Name = "memo-vpc-private-d"
  }
}

# 인터넷 게이트웨이
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.memo-vpc.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# NAT용 EIP
resource "aws_eip" "nat_eip" {
  domain = "vpc"  # vpc = ture << 구버전 provider 명령어
  tags = {
    Name = "${var.vpc_name}-nat-eip"
  }
}

# NAT 게이트웨이
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public1.id
  tags = {
    Name = "${var.vpc_name}-nat"
  }
  depends_on = [aws_internet_gateway.igw]
}

# 퍼블릭 라우트 테이블
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.memo-vpc.id
  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

# 프라이빗 라우트 테이블
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.memo-vpc.id
  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

resource "aws_route" "private_nat_access" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_assoc2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_assoc3" {
  subnet_id      = aws_subnet.private3.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_assoc4" {
  subnet_id      = aws_subnet.private4.id
  route_table_id = aws_route_table.private.id
} 

# DNS 설정 확인 및 적용
resource "aws_vpc_dhcp_options" "dns" {
  domain_name = "ap-northeast-2.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    Name = "${var.vpc_name}-dns"
  }
}

resource "aws_vpc_dhcp_options_association" "dns" {
  vpc_id          = aws_vpc.memo-vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dns.id
}