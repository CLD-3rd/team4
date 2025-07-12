output "vpc_id" {
  value = aws_vpc.vpc1.id
}

output "public_subnet_id" {
  value = aws_subnet.public1.id
}

output "private_subnet_id" { # vpc 모듈에서 정의된 private subnet id
  value = aws_subnet.private1.id
}

output "private_subnet_ids" { # EKS용 4개 프라이빗 서브넷 ID 리스트
  value = [aws_subnet.private1.id, aws_subnet.private2.id, aws_subnet.private3.id, aws_subnet.private4.id]
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}