output "endpoint" {
  value       = aws_db_instance.this.endpoint
  description = "RDS endpoint"
}


output "rds_id" {
  value = aws_db_instance.this.id
}

