# CloudFrontモジュール用変数定義

variable "project_name" {
  description = "プロジェクト名"
  type        = string
}

variable "tags" {
  description = "リソースに付与するタグ"
  type        = map(string)
  default     = {}
}

variable "s3_bucket_name" {
  description = "S3バケット名"
  type        = string
}

variable "s3_bucket_regional_domain_name" {
  description = "S3バケットのリージョナルドメイン名"
  type        = string
}

variable "cloudfront_oai_cloudfront_access_identity_path" {
  description = "CloudFront Origin Access Identityのパス"
  type        = string
}

variable "cloudfront_public_key_file" {
  description = "CloudFrontパブリックキーファイルのパス"
  type        = string
  default     = "cloudfront-public-key.pem"
}

variable "min_ttl" {
  description = "最小TTL（秒）"
  type        = number
  default     = 0
}

variable "default_ttl" {
  description = "デフォルトTTL（秒）"
  type        = number
  default     = 3600
}

variable "max_ttl" {
  description = "最大TTL（秒）"
  type        = number
  default     = 86400
}