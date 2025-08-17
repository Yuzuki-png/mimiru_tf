terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Data sources
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {
  state = "available"
}

# Local values
locals {
  account_id  = data.aws_caller_identity.current.account_id
  azs         = slice(data.aws_availability_zones.available.names, 0, 2)
  environment = "production"
  
  tags = {
    Project     = var.project_name
    Environment = local.environment
    ManagedBy   = "terraform"
  }
}

# VPC Module
module "vpc" {
  source = "../../modules/vpc"
  
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
  azs          = local.azs
  tags         = local.tags
}

# Security Groups Module
module "security_groups" {
  source = "../../modules/security_groups"
  
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  vpc_cidr     = var.vpc_cidr
  tags         = local.tags
}

# ECR Module (ECSより前に定義)
module "ecr" {
  source = "../../modules/ecr"
  
  project_name = var.project_name
  tags         = local.tags
}

# ALB Module
module "alb" {
  source = "../../modules/alb"
  
  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.security_groups.alb_security_group_id
  tags                  = local.tags
}

# ECS Module
module "ecs" {
  source = "../../modules/ecs"
  
  project_name = var.project_name
  tags         = local.tags
}

# RDS Module
module "rds" {
  source = "../../modules/rds"
  
  project_name       = var.project_name
  private_subnet_ids = module.vpc.private_subnet_ids
  security_group_id  = module.security_groups.rds_security_group_id
  db_password        = var.db_password
  tags               = local.tags
}

# Secrets Module
module "secrets" {
  source = "../../modules/secrets"
  
  project_name           = var.project_name
  db_password           = var.db_password
  jwt_secret            = var.jwt_secret
  aws_access_key_id     = var.aws_access_key_id
  aws_secret_access_key = var.aws_secret_access_key
  s3_bucket_name        = var.s3_bucket_name
  cloudfront_private_key = var.cloudfront_private_key
  tags                  = local.tags
}

# S3 Module
module "s3" {
  source = "../../modules/s3"
  
  project_name = var.project_name
  bucket_name  = var.s3_bucket_name
  tags         = local.tags
}

# CloudFront Module
module "cloudfront" {
  source = "../../modules/cloudfront"
  
  project_name                                   = var.project_name
  s3_bucket_name                                 = var.s3_bucket_name
  s3_bucket_regional_domain_name                 = module.s3.bucket_regional_domain_name
  cloudfront_oai_cloudfront_access_identity_path = module.s3.cloudfront_oai_cloudfront_access_identity_path
  tags                                           = local.tags
}

# GitHub OIDC Module
module "github_oidc" {
  source = "../../modules/github-oidc"
  
  project_name               = var.project_name
  github_org                 = var.github_org
  github_repo                = var.github_repo
  ecs_task_execution_role_arn = module.ecs.task_execution_role_arn
  ecs_task_role_arn          = module.ecs.task_role_arn
  tags                       = local.tags
}