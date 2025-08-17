output "dns_name" {
  description = "ALB DNS名"
  value       = aws_lb.main.dns_name
}

output "zone_id" {
  description = "ALB ゾーンID"
  value       = aws_lb.main.zone_id
}

output "target_group_arn" {
  description = "ターゲットグループARN"
  value       = aws_lb_target_group.main.arn
}

output "load_balancer_arn" {
  description = "ロードバランサーARN"
  value       = aws_lb.main.arn
}