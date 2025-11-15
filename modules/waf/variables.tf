variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "beanstalk_env_name" {
  type        = string
  description = "Elastic Beanstalk environment name (optional)"
  default     = null
}

variable "alb_arn" {
  description = "ARN of the ALB to attach WAF"
  type        = string
  default     = null
}

