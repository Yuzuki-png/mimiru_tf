# CloudFront Distribution
resource "aws_cloudfront_distribution" "audio_storage" {
  origin {
    domain_name = aws_s3_bucket.audio_storage.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.audio_storage.bucket}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.audio_storage.cloudfront_access_identity_path
    }
  }

  enabled = true
  comment = "${var.project_name} audio storage distribution"

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${aws_s3_bucket.audio_storage.bucket}"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = local.tags
}

# CloudFront Key Group (for signed URLs)
resource "aws_cloudfront_public_key" "audio_storage" {
  comment     = "${var.project_name} CloudFront public key"
  encoded_key = file("${path.module}/cloudfront-public-key.pem") # You need to provide this file
  name        = "${var.project_name}-cloudfront-key"
}

resource "aws_cloudfront_key_group" "audio_storage" {
  comment = "${var.project_name} CloudFront key group"
  items   = [aws_cloudfront_public_key.audio_storage.id]
  name    = "${var.project_name}-key-group"
}