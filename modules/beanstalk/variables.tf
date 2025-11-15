variable "project_name" {
  type        = string
  description = "Name of the project, used as prefix for resources"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where EB environment and subnets are deployed"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for EC2 instances and ALB"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs (optional, for DB or private resources)"
}

variable "instance_security_group_ids" {
  type        = list(string)
  description = "Security group IDs for EB EC2 instances"
  default     = []
}

variable "eb_platform" {
  type        = string
  description = "Elastic Beanstalk platform (e.g., Node.js 20 running on 64bit Amazon Linux 2023)"
}

variable "eb_instance_type" {
  type        = string
  description = "EC2 instance type for EB environment"
}

variable "service_role_arn" {
  type        = string
  description = "IAM role ARN for Elastic Beanstalk service role"
}

variable "instance_profile_name" {
  type        = string
  description = "IAM instance profile name for EC2 instances in EB environment"
}

variable "app_bucket_name" {
  type        = string
  description = "Optional pre-created S3 bucket name to store EB application versions"
  default     = ""
}

variable "s3_bucket" {
  type        = string
  description = "Deprecated alias for external bucket, prefer app_bucket_name"
  default     = ""
}

variable "app_version_s3_key" {
  type        = string
  description = "S3 object key for the application version to deploy (optional)"
  default     = ""
}

variable "enable_cloudwatch_logs" {
  type        = bool
  description = "Enable CloudWatch logs for EB environment"
  default     = true
}

