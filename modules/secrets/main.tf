# データベースパスワード
resource "aws_secretsmanager_secret" "database_password" {
  name        = "${var.project_name}/database/password"
  description = "RDSデータベースパスワード"
  
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "database_password" {
  secret_id     = aws_secretsmanager_secret.database_password.id
  secret_string = var.db_password
}

# JWT秘密鍵
resource "aws_secretsmanager_secret" "jwt_secret" {
  name        = "${var.project_name}/jwt/secret"
  description = "JWT署名用秘密鍵"
  
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "jwt_secret" {
  secret_id     = aws_secretsmanager_secret.jwt_secret.id
  secret_string = var.jwt_secret
}

# AWSアクセスキーID
resource "aws_secretsmanager_secret" "aws_access_key_id" {
  name        = "${var.project_name}/aws/access-key-id"
  description = "アプリケーション用AWSアクセスキーID"
  
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "aws_access_key_id" {
  secret_id     = aws_secretsmanager_secret.aws_access_key_id.id
  secret_string = var.aws_access_key_id
}

# AWSシークレットアクセスキー
resource "aws_secretsmanager_secret" "aws_secret_access_key" {
  name        = "${var.project_name}/aws/secret-access-key"
  description = "アプリケーション用AWSシークレットアクセスキー"
  
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "aws_secret_access_key" {
  secret_id     = aws_secretsmanager_secret.aws_secret_access_key.id
  secret_string = var.aws_secret_access_key
}

# S3バケット名
resource "aws_secretsmanager_secret" "s3_bucket_name" {
  name        = "${var.project_name}/s3/bucket-name"
  description = "S3バケット名"
  
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "s3_bucket_name" {
  secret_id     = aws_secretsmanager_secret.s3_bucket_name.id
  secret_string = var.s3_bucket_name
}

# CloudFront秘密鍵
resource "aws_secretsmanager_secret" "cloudfront_private_key" {
  name        = "${var.project_name}/cloudfront/private-key"
  description = "CloudFront署名用秘密鍵"
  
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "cloudfront_private_key" {
  secret_id     = aws_secretsmanager_secret.cloudfront_private_key.id
  secret_string = var.cloudfront_private_key
}