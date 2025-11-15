output "log_group_name" {
  description = "CloudWatch log group name for the application"
  value       = aws_cloudwatch_log_group.app.name
}
