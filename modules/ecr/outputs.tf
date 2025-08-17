# ECRリポジトリのアウトプット

output "repository_url" {
  description = "ECRリポジトリのURL"
  value       = aws_ecr_repository.main.repository_url
}

output "repository_name" {
  description = "ECRリポジトリ名"
  value       = aws_ecr_repository.main.name
}

output "repository_arn" {
  description = "ECRリポジトリのARN"
  value       = aws_ecr_repository.main.arn
}