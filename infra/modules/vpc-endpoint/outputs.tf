output "vpc_endpoint_id" {
  description = "VPC Endpoint ID"
  value       = aws_vpc_endpoint.eks_api.id
}

output "vpc_endpoint_dns_name" {
  description = "VPC Endpoint DNS 이름"
  value       = aws_vpc_endpoint.eks_api.dns_entry[0]["dns_name"]
} 