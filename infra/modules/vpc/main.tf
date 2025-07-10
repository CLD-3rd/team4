### VPC 설정 모듈 (요약:1VPC 1Private 1Public ) - 김재신
resource "aws_vpc" "vpc1" { # vpc 생성
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public1" { # 퍼블릭 subnet
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.az # 서울 a 영역
  map_public_ip_on_launch = true # 퍼블릭
  tags = {
    Name = var.public_subnet_name
  }
}

resource "aws_subnet" "private1" { #프라이빗 subnet
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.az # 서울 a 영역
  map_public_ip_on_launch = false # 프라이빗
  tags = {
    Name = var.private_subnet_name
  }
} 

resource "aws_subnet" "private2" { #프라이빗 subnet 2
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = "10.0.3.0/24" # 두 번째 프라이빗 서브넷 CIDR (충돌 해결)
  availability_zone = "ap-northeast-2b" # 서울 b 영역
  map_public_ip_on_launch = false # 프라이빗
  tags = {
    Name = "${var.private_subnet_name}-2"
  }
} 

# 인터넷 게이트웨이
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id
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
  vpc_id = aws_vpc.vpc1.id
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
  vpc_id = aws_vpc.vpc1.id
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