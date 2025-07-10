#RDS
output "endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.memo_rds.endpoint
}

output "db_instance_identifier" {
  description = "RDS instance ID"
  value       = aws_db_instance.memo_rds.id
}
