output "cluster_name" {
  description = "ECSクラスター名"
  value       = aws_ecs_cluster.main.name
}

output "cluster_arn" {
  description = "ECSクラスターのARN"
  value       = aws_ecs_cluster.main.arn
}

output "task_execution_role_arn" {
  description = "ECSタスク実行ロールのARN"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "task_role_arn" {
  description = "ECSタスクロールのARN"
  value       = aws_iam_role.ecs_task_role.arn
}

output "log_group_name" {
  description = "CloudWatchログググループ名"
  value       = aws_cloudwatch_log_group.main.name
}