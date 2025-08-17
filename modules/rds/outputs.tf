# RDSのアウトプット

output "endpoint" {
  description = "RDSエンドポイント"
  value       = aws_db_instance.main.endpoint
}

output "port" {
  description = "RDSポート番号"
  value       = aws_db_instance.main.port
}

output "database_name" {
  description = "データベース名"
  value       = aws_db_instance.main.db_name
}

output "username" {
  description = "データベースユーザー名"
  value       = aws_db_instance.main.username
}

output "instance_id" {
  description = "RDSインスタンスID"
  value       = aws_db_instance.main.id
}

output "arn" {
  description = "RDSインスタンスのARN"
  value       = aws_db_instance.main.arn
}