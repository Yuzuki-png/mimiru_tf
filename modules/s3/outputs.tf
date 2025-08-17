# S3のアウトプット

output "bucket_name" {
  description = "S3バケット名"
  value       = aws_s3_bucket.audio_storage.bucket
}

output "bucket_arn" {
  description = "S3バケットのARN"
  value       = aws_s3_bucket.audio_storage.arn
}

output "bucket_id" {
  description = "S3バケットID"
  value       = aws_s3_bucket.audio_storage.id
}

output "bucket_domain_name" {
  description = "S3バケットのドメイン名"
  value       = aws_s3_bucket.audio_storage.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "S3バケットのリージョナルドメイン名"
  value       = aws_s3_bucket.audio_storage.bucket_regional_domain_name
}

output "cloudfront_oai_id" {
  description = "CloudFront Origin Access IdentityのID"
  value       = aws_cloudfront_origin_access_identity.audio_storage.id
}

output "cloudfront_oai_iam_arn" {
  description = "CloudFront Origin Access IdentityのIAM ARN"
  value       = aws_cloudfront_origin_access_identity.audio_storage.iam_arn
}

output "cloudfront_oai_cloudfront_access_identity_path" {
  description = "CloudFront Origin Access Identityのパス"
  value       = aws_cloudfront_origin_access_identity.audio_storage.cloudfront_access_identity_path
}