output "elastic_beanstalk_environment_name" {
  value       = aws_elastic_beanstalk_environment.this.name
  description = "Name of Elastic Beanstalk Environment"
}

output "elastic_beanstalk_alb_arn" {
  value       = data.aws_lb.beanstalk_alb.arn
  description = "ARN of ALB created by Elastic Beanstalk"
}

output "elastic_beanstalk_alb_dns" {
  value       = data.aws_lb.beanstalk_alb.dns_name
  description = "DNS name of ALB created by Elastic Beanstalk"
}
