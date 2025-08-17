# RDSモジュール用変数定義

variable "project_name" {
  description = "プロジェクト名"
  type        = string
}

variable "tags" {
  description = "リソースに付与するタグ"
  type        = map(string)
  default     = {}
}

variable "db_password" {
  description = "データベースのパスワード"
  type        = string
  sensitive   = true
}

variable "private_subnet_ids" {
  description = "プライベートサブネットのIDリスト"
  type        = list(string)
}

variable "security_group_id" {
  description = "RDS用セキュリティグループのID"
  type        = string
}

variable "instance_class" {
  description = "RDSインスタンスクラス"
  type        = string
  default     = "db.t4g.small"
}

variable "allocated_storage" {
  description = "初期ストレージサイズ（GB）"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "最大ストレージサイズ（GB）"
  type        = number
  default     = 100
}

variable "backup_retention_period" {
  description = "バックアップ保持期間（日）"
  type        = number
  default     = 30
}

variable "multi_az" {
  description = "Multi-AZ展開を有効にするか"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "削除保護を有効にするか"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "最終スナップショットをスキップするか"
  type        = bool
  default     = true
}