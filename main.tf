locals {
  name_prefix = var.project_name
}

#########################
# VPC Module
#########################
module "vpc" {
  source               = "./modules/vpc"
  project_name         = local.name_prefix
  vpc_cidr             = var.vpc_cidr

  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  public_subnet_azs    = var.public_subnet_azs
  private_subnet_azs   = var.private_subnet_azs

  environment          = var.tags["Environment"]
}

#########################
# IAM Module
#########################
module "iam" {
  source       = "./modules/iam"
  project_name = local.name_prefix
}

#########################
# RDS Module
#########################
module "rds" {
  source             = "./modules/rds"
  project_name       = local.name_prefix
  vpc_id             = module.vpc.vpc_id
  private_subnets    = module.vpc.private_subnet_ids
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
  db_instance_class  = var.db_instance_class
  db_engine          = var.db_engine
  db_engine_version  = var.db_engine_version
  security_group_ids = [module.vpc.rds_sg_id]
}

#########################
# CloudWatch Module
#########################
module "cloudwatch" {
  source             = "./modules/cloudwatch"
  project_name       = local.name_prefix
  log_retention_days = 14
}

#########################
# Elastic Beanstalk Module
#########################
module "beanstalk" {
  source                      = "./modules/beanstalk"
  project_name                = local.name_prefix
  aws_region                  = var.aws_region
  vpc_id                      = module.vpc.vpc_id
  public_subnet_ids           = module.vpc.public_subnet_ids
  private_subnet_ids          = module.vpc.private_subnet_ids
  eb_platform                 = var.eb_platform
  eb_instance_type            = var.eb_instance_type
  service_role_arn            = module.iam.beanstalk_service_role_arn
  instance_profile_name       = module.iam.beanstalk_instance_profile_name
  s3_bucket                   = var.eb_s3_bucket_for_app
  app_bucket_name             = ""
  app_version_s3_key          = ""
  instance_security_group_ids = [module.vpc.eb_instance_sg_id]
  enable_cloudwatch_logs      = var.enable_cloudwatch_logs

  depends_on = [
    module.iam,
    module.vpc
  ]
}


#########################
# WAF Module
#########################
module "waf" {
  source       = "./modules/waf"
  project_name = local.name_prefix
  region       = var.aws_region
  alb_arn      = module.beanstalk.elastic_beanstalk_alb_arn

  depends_on = [
    module.beanstalk
  ]
}
