# VPC Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "プライベートサブネットID一覧"
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  description = "パブリックサブネットID一覧"
  value       = module.vpc.public_subnet_ids
}

# ALB Outputs
output "alb_dns_name" {
  description = "ALB DNS名"
  value       = module.alb.dns_name
}

output "alb_zone_id" {
  description = "ALB ゾーンID"
  value       = module.alb.zone_id
}

output "target_group_arn" {
  description = "ターゲットグループARN"
  value       = module.alb.target_group_arn
}

# ECS Outputs
output "ecs_cluster_name" {
  description = "ECSクラスター名"
  value       = module.ecs.cluster_name
}

output "ecs_security_group_id" {
  description = "ECSセキュリティグループID"
  value       = module.security_groups.ecs_security_group_id
}

# ECR Outputs
output "ecr_repository_url" {
  description = "ECRリポジトリURL"
  value       = module.ecr.repository_url
}

# RDS Outputs
output "rds_endpoint" {
  description = "RDSエンドポイント"
  value       = module.rds.endpoint
  sensitive   = true
}

# S3 Outputs
output "s3_bucket_name" {
  description = "S3バケット名"
  value       = module.s3.bucket_name
}

# CloudFront Outputs
output "cloudfront_distribution_id" {
  description = "CloudFrontディストリビューションID"
  value       = module.cloudfront.distribution_id
}

output "cloudfront_domain_name" {
  description = "CloudFrontドメイン名"
  value       = module.cloudfront.domain_name
}

# GitHub Actions Outputs
output "github_actions_role_arn" {
  description = "GitHub Actions IAMロールARN"
  value       = module.github_oidc.role_arn
}

output "aws_account_id" {
  description = "AWSアカウントID"
  value       = local.account_id
}

# GitHub Secrets用出力
output "github_secrets" {
  description = "GitHub Secretsに設定する値"
  value = {
    AWS_ACCOUNT_ID     = local.account_id
    TARGET_GROUP_ARN   = module.alb.target_group_arn
    PRIVATE_SUBNET_1   = module.vpc.private_subnet_ids[0]
    PRIVATE_SUBNET_2   = module.vpc.private_subnet_ids[1]
    ECS_SECURITY_GROUP = module.security_groups.ecs_security_group_id
    ECR_REPOSITORY_URL = module.ecr.repository_url
    ECS_CLUSTER_NAME   = module.ecs.cluster_name
  }
}