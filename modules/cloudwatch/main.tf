resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/elasticbeanstalk/${var.project_name}/application"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.project_name}-cloudwatch-logs"
    Environment = var.environment
    Project     = var.project_name
  }
}
