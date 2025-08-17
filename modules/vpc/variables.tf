variable "project_name" {
  description = "プロジェクト名"
  type        = string
}

variable "vpc_cidr" {
  description = "VPCのCIDRブロック"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "アベイラビリティゾーン"
  type        = list(string)
}

variable "tags" {
  description = "共通タグ"
  type        = map(string)
  default     = {}
}