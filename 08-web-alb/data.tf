data "aws_ssm_parameter" "web_alb_sg_id" {
  name = "/${var.Project_Name}/${var.Environment}/web_alb_sg_id"
}

data "aws_ssm_parameter" "public_subnet_id" {
  name = "/${var.Project_Name}/${var.Environment}/public_subnet_id"
}

data "aws_route53_zone" "domain_zone_id" {
  name         = var.zone_name
  private_zone = false
}

data "aws_ssm_parameter" "acm_certificate_arn" {
  name = "/${var.Project_Name}/${var.Environment}/acm_certificate_arn"
}
