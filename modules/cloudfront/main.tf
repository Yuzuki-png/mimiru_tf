# CloudFrontディストリビューション
resource "aws_cloudfront_distribution" "audio_storage" {
  origin {
    domain_name = var.s3_bucket_regional_domain_name
    origin_id   = "S3-${var.s3_bucket_name}"

    s3_origin_config {
      origin_access_identity = var.cloudfront_oai_cloudfront_access_identity_path
    }
  }

  enabled = true
  comment = "${var.project_name} audio storage distribution"

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${var.s3_bucket_name}"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = var.min_ttl
    default_ttl = var.default_ttl
    max_ttl     = var.max_ttl
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = var.tags
}

# CloudFrontパブリックキー（署名付きURL用）
resource "aws_cloudfront_public_key" "audio_storage" {
  comment     = "${var.project_name} CloudFront public key"
  encoded_key = file("${path.root}/${var.cloudfront_public_key_file}")
  name        = "${var.project_name}-cloudfront-key"
}

# CloudFrontキーグループ
resource "aws_cloudfront_key_group" "audio_storage" {
  comment = "${var.project_name} CloudFront key group"
  items   = [aws_cloudfront_public_key.audio_storage.id]
  name    = "${var.project_name}-key-group"
}