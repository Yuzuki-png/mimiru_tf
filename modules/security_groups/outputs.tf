output "alb_security_group_id" {
  description = "ALBセキュリティグループID"
  value       = aws_security_group.alb.id
}

output "ecs_security_group_id" {
  description = "ECSセキュリティグループID"
  value       = aws_security_group.ecs.id
}

output "rds_security_group_id" {
  description = "RDSセキュリティグループID"
  value       = aws_security_group.rds.id
}