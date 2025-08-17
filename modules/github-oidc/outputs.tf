# GitHub OIDCのアウトプット

output "oidc_provider_arn" {
  description = "GitHub OIDC プロバイダーのARN"
  value       = aws_iam_openid_connect_provider.github.arn
}

output "github_actions_role_arn" {
  description = "GitHub Actions IAMロールのARN"
  value       = aws_iam_role.github_actions.arn
}

output "github_actions_role_name" {
  description = "GitHub Actions IAMロール名"
  value       = aws_iam_role.github_actions.name
}

output "role_arn" {
  description = "GitHub Actions IAMロールのARN"
  value       = aws_iam_role.github_actions.arn
}