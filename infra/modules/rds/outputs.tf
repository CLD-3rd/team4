output "endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.this.endpoint
}

output "port" {
  description = "RDS port"
  value       = aws_db_instance.this.port
}

output "db_instance_identifier" {
  description = "RDS instance ID"
  value       = aws_db_instance.this.id
}