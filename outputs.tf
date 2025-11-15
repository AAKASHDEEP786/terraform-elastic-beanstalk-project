# VPC Outputs
output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID created by VPC module"
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "Public subnet IDs created by VPC module"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "Private subnet IDs created by VPC module"
}

# RDS Outputs
output "rds_endpoint" {
  value       = module.rds.endpoint
  description = "RDS endpoint"
}

# Elastic Beanstalk Outputs
output "elastic_beanstalk_environment_name" {
  value       = module.beanstalk.elastic_beanstalk_environment_name
  description = "Elastic Beanstalk Environment Name"
}

output "elastic_beanstalk_alb_arn" {
  value       = module.beanstalk.elastic_beanstalk_alb_arn
  description = "ALB ARN created by EB environment"
}

output "elastic_beanstalk_alb_dns" {
  value       = module.beanstalk.elastic_beanstalk_alb_dns
  description = "ALB DNS name created by EB environment"
}
