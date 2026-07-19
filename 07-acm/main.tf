resource "aws_acm_certificate" "cert" {
  domain_name       = "*.${var.zone_name}"
  validation_method = "DNS"

  tags = merge(
    var.common_tags,
    var.tags,   
  )

    lifecycle {
    create_before_destroy = true
  }

}


resource "aws_route53_record" "record_for_acm_cert" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 1
  type            = each.value.type
  zone_id         = data.aws_route53_zone.domain_zone_id.zone_id
}

resource "aws_acm_certificate_validation" "validation_cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.record_for_acm_cert : record.fqdn]
}