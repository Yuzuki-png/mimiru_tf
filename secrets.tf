# Secrets Manager
resource "aws_secretsmanager_secret" "database_url" {
  name                    = "${var.project_name}/database-url"
  description             = "Database URL for ${var.project_name}"
  recovery_window_in_days = 7

  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "database_url" {
  secret_id = aws_secretsmanager_secret.database_url.id
  secret_string = "postgresql://postgres:${var.db_password}@${aws_db_instance.main.endpoint}/${aws_db_instance.main.db_name}"
}

resource "aws_secretsmanager_secret" "jwt_secret" {
  name                    = "${var.project_name}/jwt-secret"
  description             = "JWT secret for ${var.project_name}"
  recovery_window_in_days = 7

  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "jwt_secret" {
  secret_id     = aws_secretsmanager_secret.jwt_secret.id
  secret_string = var.jwt_secret
}

resource "aws_secretsmanager_secret" "aws_access_key_id" {
  name                    = "${var.project_name}/aws-access-key-id"
  description             = "AWS Access Key ID for ${var.project_name}"
  recovery_window_in_days = 7

  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "aws_access_key_id" {
  secret_id     = aws_secretsmanager_secret.aws_access_key_id.id
  secret_string = var.aws_access_key_id
}

resource "aws_secretsmanager_secret" "aws_secret_access_key" {
  name                    = "${var.project_name}/aws-secret-access-key"
  description             = "AWS Secret Access Key for ${var.project_name}"
  recovery_window_in_days = 7

  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "aws_secret_access_key" {
  secret_id     = aws_secretsmanager_secret.aws_secret_access_key.id
  secret_string = var.aws_secret_access_key
}

resource "aws_secretsmanager_secret" "s3_bucket_name" {
  name                    = "${var.project_name}/s3-bucket-name"
  description             = "S3 bucket name for ${var.project_name}"
  recovery_window_in_days = 7

  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "s3_bucket_name" {
  secret_id     = aws_secretsmanager_secret.s3_bucket_name.id
  secret_string = aws_s3_bucket.audio_storage.bucket
}

resource "aws_secretsmanager_secret" "cloudfront_distribution_id" {
  name                    = "${var.project_name}/cloudfront-distribution-id"
  description             = "CloudFront distribution ID for ${var.project_name}"
  recovery_window_in_days = 7

  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "cloudfront_distribution_id" {
  secret_id     = aws_secretsmanager_secret.cloudfront_distribution_id.id
  secret_string = aws_cloudfront_distribution.audio_storage.id
}

resource "aws_secretsmanager_secret" "cloudfront_domain" {
  name                    = "${var.project_name}/cloudfront-domain"
  description             = "CloudFront domain for ${var.project_name}"
  recovery_window_in_days = 7

  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "cloudfront_domain" {
  secret_id     = aws_secretsmanager_secret.cloudfront_domain.id
  secret_string = "https://${aws_cloudfront_distribution.audio_storage.domain_name}"
}

resource "aws_secretsmanager_secret" "cloudfront_key_pair_id" {
  name                    = "${var.project_name}/cloudfront-key-pair-id"
  description             = "CloudFront key pair ID for ${var.project_name}"
  recovery_window_in_days = 7

  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "cloudfront_key_pair_id" {
  secret_id     = aws_secretsmanager_secret.cloudfront_key_pair_id.id
  secret_string = aws_cloudfront_public_key.audio_storage.id
}

resource "aws_secretsmanager_secret" "cloudfront_private_key" {
  name                    = "${var.project_name}/cloudfront-private-key"
  description             = "CloudFront private key for ${var.project_name}"
  recovery_window_in_days = 7

  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "cloudfront_private_key" {
  secret_id     = aws_secretsmanager_secret.cloudfront_private_key.id
  secret_string = var.cloudfront_private_key
}

# Additional variables for secrets
variable "aws_access_key_id" {
  description = "AWS Access Key ID"
  type        = string
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key"
  type        = string
  sensitive   = true
}

variable "cloudfront_private_key" {
  description = "CloudFront private key for signed URLs"
  type        = string
  sensitive   = true
}