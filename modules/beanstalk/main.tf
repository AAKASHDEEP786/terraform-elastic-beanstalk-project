##############################
# Elastic Beanstalk Application
##############################
resource "aws_elastic_beanstalk_application" "this" {
  name        = "${var.project_name}-app"
  description = "Elastic Beanstalk Application for ${var.project_name}"

  tags = merge(var.tags, {
    Name = "${var.project_name}-eb-app"
  })
}

##############################
# Random bucket suffix
##############################
resource "random_id" "bucket_rand" {
  byte_length = 4
}

########################################
# Create S3 bucket only if needed
########################################
resource "aws_s3_bucket" "app_bucket" {
  count         = var.app_bucket_name == "" && var.s3_bucket == "" ? 1 : 0
  bucket        = "${var.project_name}-beanstalk-artifacts-${random_id.bucket_rand.hex}"
  force_destroy = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-beanstalk-artifacts"
  })
}

locals {
  app_bucket = (
    var.s3_bucket != "" ? var.s3_bucket :
    var.app_bucket_name != "" ? var.app_bucket_name :
    (length(aws_s3_bucket.app_bucket) > 0 ? aws_s3_bucket.app_bucket[0].bucket : "")
  )
}

##############################
# Application Version (optional)
##############################
resource "aws_elastic_beanstalk_application_version" "app_version" {
  count       = var.app_version_s3_key != "" ? 1 : 0
  name        = "${var.project_name}-v1-${timestamp()}"
  application = aws_elastic_beanstalk_application.this.name
  bucket      = local.app_bucket
  key         = var.app_version_s3_key

  lifecycle {
    ignore_changes = [bucket, key]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-app-version"
  })
}

##############################
# Elastic Beanstalk Environment
##############################
resource "aws_elastic_beanstalk_environment" "this" {
  name                = "${var.project_name}-env"
  application         = aws_elastic_beanstalk_application.this.name
  solution_stack_name = var.eb_platform
  cname_prefix        = "${var.project_name}-env"

  version_label = (
    length(aws_elastic_beanstalk_application_version.app_version) > 0 ?
    aws_elastic_beanstalk_application_version.app_version[0].name :
    null
  )

  lifecycle {
    create_before_destroy = true
  }

  ############################################
  # Environment Type & Load Balancer
  ############################################
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  ############################################
  # ALB Listener Config (fixed)
  ############################################
  setting {
    namespace = "aws:elbv2:listener:default"
    name      = "ListenerEnabled"
    value     = "true"
  }

  ############################################
  # CloudWatch Logs
  ############################################
  setting {
    namespace = "aws:elasticbeanstalk:hostmanager"
    name      = "LogPublicationControl"
    value     = var.enable_cloudwatch_logs ? "true" : "false"
  }

  ############################################
  # ALB Target Group Health Check
  ############################################
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckPath"
    value     = "/"
  }

  ##############################
  # IAM Roles
  ##############################
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = var.service_role_arn
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = var.instance_profile_name
  }

  ##############################
  # Instance Config
  ##############################
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.eb_instance_type
  }

  ##############################
  # VPC / Subnet Config
  ##############################
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.public_subnet_ids)
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",", var.public_subnet_ids)
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "DBSubnets"
    value     = join(",", var.private_subnet_ids)
  }

  ##############################
  # Security Groups
  ##############################
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = length(var.instance_security_group_ids) > 0 ? join(",", var.instance_security_group_ids) : ""
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-env"
  })
}

###########################################
# Fetch the ALB created by Elastic Beanstalk safely
###########################################
data "aws_lbs" "beanstalk_albs" {
  depends_on = [aws_elastic_beanstalk_environment.this]

  tags = {
    "elasticbeanstalk:environment-name" = aws_elastic_beanstalk_environment.this.name
  }
}

data "aws_lb" "beanstalk_alb" {
  arn        = length(data.aws_lbs.beanstalk_albs.arns) > 0 ? tolist(data.aws_lbs.beanstalk_albs.arns)[0] : null
  depends_on = [data.aws_lbs.beanstalk_albs]
}
