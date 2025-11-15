output "beanstalk_service_role_arn" {
  description = "IAM service role ARN for Elastic Beanstalk"
  value       = aws_iam_role.beanstalk_service_role.arn
}

output "beanstalk_instance_profile_name" {
  description = "Instance profile name for Beanstalk EC2 instances"
  value       = aws_iam_instance_profile.beanstalk_instance_profile.name
}
