# S3モジュール用変数定義

variable "project_name" {
  description = "プロジェクト名"
  type        = string
}

variable "tags" {
  description = "リソースに付与するタグ"
  type        = map(string)
  default     = {}
}

variable "bucket_name" {
  description = "S3バケット名"
  type        = string
}

variable "versioning_enabled" {
  description = "バージョニングを有効にするか"
  type        = bool
  default     = true
}

variable "lifecycle_noncurrent_version_expiration_days" {
  description = "非現行バージョンの有効期限（日）"
  type        = number
  default     = 30
}

variable "lifecycle_abort_incomplete_multipart_upload_days" {
  description = "不完全なマルチパートアップロードの削除日数"
  type        = number
  default     = 7
}