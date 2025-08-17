# オーディオストレージ用S3バケット
resource "aws_s3_bucket" "audio_storage" {
  bucket = var.bucket_name

  tags = var.tags
}

# S3バケットバージョニング
resource "aws_s3_bucket_versioning" "audio_storage" {
  bucket = aws_s3_bucket.audio_storage.id
  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Disabled"
  }
}

# S3バケットサーバーサイド暗号化
resource "aws_s3_bucket_server_side_encryption_configuration" "audio_storage" {
  bucket = aws_s3_bucket.audio_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3バケットパブリックアクセスブロック
resource "aws_s3_bucket_public_access_block" "audio_storage" {
  bucket = aws_s3_bucket.audio_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3バケットライフサイクル設定
resource "aws_s3_bucket_lifecycle_configuration" "audio_storage" {
  bucket = aws_s3_bucket.audio_storage.id

  rule {
    id     = "audio_lifecycle"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = var.lifecycle_noncurrent_version_expiration_days
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = var.lifecycle_abort_incomplete_multipart_upload_days
    }
  }
}

# CloudFront OAI
resource "aws_cloudfront_origin_access_identity" "audio_storage" {
  comment = "OAI for ${var.project_name} audio storage"
}

# CloudFront用S3バケットポリシー
resource "aws_s3_bucket_policy" "audio_storage" {
  bucket = aws_s3_bucket.audio_storage.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontAccess"
        Effect = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.audio_storage.iam_arn
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.audio_storage.arn}/*"
      }
    ]
  })
}