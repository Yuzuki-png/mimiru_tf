variable "aws_region" {
  description = "AWSリージョン"
  type        = string
  default     = "ap-northeast-1"
}

variable "project_name" {
  description = "プロジェクト名"
  type        = string
  default     = "mimiru"
}

variable "vpc_cidr" {
  description = "VPCのCIDRブロック"
  type        = string
  default     = "10.0.0.0/16"
}

variable "github_org" {
  description = "GitHub組織名"
  type        = string
}

variable "github_repo" {
  description = "GitHubリポジトリ名"
  type        = string
  default     = "radio_site_backend"
}

variable "db_password" {
  description = "RDSデータベースパスワード"
  type        = string
  sensitive   = true
}

variable "jwt_secret" {
  description = "JWT秘密鍵"
  type        = string
  sensitive   = true
}

variable "s3_bucket_name" {
  description = "オーディオストレージ用S3バケット名"
  type        = string
}

variable "aws_access_key_id" {
  description = "アプリケーション用AWSアクセスキーID"
  type        = string
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "アプリケーション用AWSシークレットアクセスキー"
  type        = string
  sensitive   = true
}

variable "cloudfront_private_key" {
  description = "CloudFront署名用秘密鍵"
  type        = string
  sensitive   = true
}