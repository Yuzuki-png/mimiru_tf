# CloudFrontのアウトプット

output "distribution_id" {
  description = "CloudFrontディストリビューションID"
  value       = aws_cloudfront_distribution.audio_storage.id
}

output "distribution_arn" {
  description = "CloudFrontディストリビューションのARN"
  value       = aws_cloudfront_distribution.audio_storage.arn
}

output "distribution_domain_name" {
  description = "CloudFrontディストリビューションのドメイン名"
  value       = aws_cloudfront_distribution.audio_storage.domain_name
}

output "domain_name" {
  description = "CloudFrontドメイン名"
  value       = aws_cloudfront_distribution.audio_storage.domain_name
}

output "public_key_id" {
  description = "CloudFrontパブリックキーのID"
  value       = aws_cloudfront_public_key.audio_storage.id
}

output "key_group_id" {
  description = "CloudFrontキーグループのID"
  value       = aws_cloudfront_key_group.audio_storage.id
}