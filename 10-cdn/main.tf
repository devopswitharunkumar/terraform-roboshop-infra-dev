resource "aws_cloudfront_distribution" "alb_distribution" {
  enabled     = true
  aliases     = ["web-${var.tags.Component}.${var.zone_name}"]
  price_class = "PriceClass_100"

  origin {
    domain_name = "web-${var.Environment}.${var.zone_name}"
    origin_id   = "web-${var.Environment}.${var.zone_name}"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }


  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/images/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "web-${var.Environment}.${var.zone_name}"

    cache_policy_id = data.aws_cloudfront_cache_policy.cache_optimized.id
    compress               = true
    viewer_protocol_policy = "https-only"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/static/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "web-${var.Environment}.${var.zone_name}"

    cache_policy_id = data.aws_cloudfront_cache_policy.cache_optimized.id
    compress               = true
    viewer_protocol_policy = "https-only"
  }

 # Cache behavior with precedence 2
  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = "web-${var.Environment}.${var.zone_name}"
    compress               = true
    viewer_protocol_policy = "https-only"
    cache_policy_id = data.aws_cloudfront_cache_policy.no_cache_optimized.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["IN", "US", "CA"]
    }
  }

  tags = merge(
    var.common_tags,
    var.tags
  )
  viewer_certificate {
    acm_certificate_arn      = data.aws_ssm_parameter.acm_certificate_arn.value
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}


resource "aws_route53_record" "app_alb_alias" {
  zone_id = data.aws_route53_zone.domain_zone_id.id

  name = "web-${var.tags.Component}.${var.zone_name}"
  type = "A"

  alias {
    name                   = aws_cloudfront_distribution.alb_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.alb_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}