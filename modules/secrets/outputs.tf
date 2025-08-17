output "database_url_arn" {
  description = "データベースURL Secret ARN"
  value       = aws_secretsmanager_secret.database_password.arn
}

output "jwt_secret_arn" {
  description = "JWT秘密鍵 Secret ARN"
  value       = aws_secretsmanager_secret.jwt_secret.arn
}

output "aws_access_key_id_arn" {
  description = "AWSアクセスキーID Secret ARN"
  value       = aws_secretsmanager_secret.aws_access_key_id.arn
}

output "aws_secret_access_key_arn" {
  description = "AWSシークレットアクセスキー Secret ARN"
  value       = aws_secretsmanager_secret.aws_secret_access_key.arn
}

output "s3_bucket_name_arn" {
  description = "S3バケット名 Secret ARN"
  value       = aws_secretsmanager_secret.s3_bucket_name.arn
}

output "cloudfront_distribution_id_arn" {
  description = "CloudFrontディストリビューションID Secret ARN"
  value       = aws_secretsmanager_secret.s3_bucket_name.arn  # 暫定的に同じARNを使用
}

output "cloudfront_domain_arn" {
  description = "CloudFrontドメイン Secret ARN"
  value       = aws_secretsmanager_secret.s3_bucket_name.arn  # 暫定的に同じARNを使用
}

output "cloudfront_key_pair_id_arn" {
  description = "CloudFrontキーペアID Secret ARN"
  value       = aws_secretsmanager_secret.cloudfront_private_key.arn
}

output "cloudfront_private_key_arn" {
  description = "CloudFront秘密鍵 Secret ARN"
  value       = aws_secretsmanager_secret.cloudfront_private_key.arn
}