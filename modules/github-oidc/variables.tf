# GitHub OIDCモジュール用変数定義

variable "project_name" {
  description = "プロジェクト名"
  type        = string
}

variable "tags" {
  description = "リソースに付与するタグ"
  type        = map(string)
  default     = {}
}

variable "github_org" {
  description = "GitHubの組織名"
  type        = string
}

variable "github_repo" {
  description = "GitHubリポジトリ名"
  type        = string
}

variable "ecs_task_execution_role_arn" {
  description = "ECSタスク実行ロールのARN"
  type        = string
}

variable "ecs_task_role_arn" {
  description = "ECSタスクロールのARN"
  type        = string
}