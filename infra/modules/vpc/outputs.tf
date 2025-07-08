output "vpc_id" {
  value = aws_vpc.vpc1.id
}

output "public_subnet_id" {
  value = aws_subnet.public1.id
}

output "private_subnet_id" {
  value = aws_subnet.private1.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
} 