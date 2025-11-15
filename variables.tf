# AWS Region
variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
}

# Project name
variable "project_name" {
  type        = string
  description = "Name of the project, used as prefix for resources"
}

# VPC configuration
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of public subnet CIDRs"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of private subnet CIDRs"
}

variable "public_subnet_azs" {
  type        = list(string)
  description = "List of AZs for public subnets"
}

variable "private_subnet_azs" {
  type        = list(string)
  description = "List of AZs for private subnets"
}

# Elastic Beanstalk
variable "eb_instance_type" {
  type        = string
  description = "EC2 instance type for EB environment"
}

variable "eb_s3_bucket_for_app" {
  type        = string
  description = "Optional S3 bucket for EB application versions"
  default     = ""
}

# Database
variable "db_engine" {
  type        = string
  description = "Database engine type"
}

variable "db_engine_version" {
  type        = string
  description = "Database engine version"
}

variable "db_instance_class" {
  type        = string
  description = "DB instance class"
}

variable "db_name" {
  type        = string
  description = "Database name"
}

variable "db_username" {
  type        = string
  description = "Database username"
}

variable "db_password" {
  type        = string
  description = "Database password"
}

# Tags
variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}

variable "eb_platform" {
  type        = string
  description = "Elastic Beanstalk platform to use"
}

variable "enable_cloudwatch_logs" {
  type        = bool
  description = "Enable CloudWatch logs for EB environment"
  default     = true
}
variable "allowed_ip_set" {
  type        = list(string)
  description = "List of allowed IPs for security groups or access"
  default     = []
}
