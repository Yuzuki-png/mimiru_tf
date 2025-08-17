variable "project_name" {
  description = "プロジェクト名"
  type        = string
}

variable "db_password" {
  description = "データベースパスワード"
  type        = string
  sensitive   = true
}

variable "jwt_secret" {
  description = "JWT秘密鍵"
  type        = string
  sensitive   = true
}

variable "aws_access_key_id" {
  description = "AWSアクセスキーID"
  type        = string
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWSシークレットアクセスキー"
  type        = string
  sensitive   = true
}

variable "s3_bucket_name" {
  description = "S3バケット名"
  type        = string
}

variable "cloudfront_private_key" {
  description = "CloudFront秘密鍵"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "共通タグ"
  type        = map(string)
  default     = {}
}