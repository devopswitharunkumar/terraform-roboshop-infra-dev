data "aws_route53_zone" "domain_zone_id" {
  name         = var.zone_name
  private_zone = false
}
