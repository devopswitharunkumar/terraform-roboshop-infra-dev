data "aws_ssm_parameter" "acm_certificate_arn" {
  name = "/${var.Project_Name}/${var.Environment}/acm_certificate_arn"
}


data "aws_route53_zone" "domain_zone_id" {
  name         = var.zone_name
  private_zone = false
}

# Look up the ID of the AWS managed CachingOptimized policy
data "aws_cloudfront_cache_policy" "cache_optimized" {
  name = "Managed-CachingOptimized"
}

# Look up the ID of the AWS managed CachingOptimized policy
data "aws_cloudfront_cache_policy" "no_cache_optimized" {
  name = "Managed-CachingDisabled"
}