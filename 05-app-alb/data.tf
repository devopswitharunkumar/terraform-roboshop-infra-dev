data "aws_ssm_parameter" "app_alb_sg_id" {
  name = "/${var.Project_Name}/${var.Environment}/app_alb_sg_id"
}

data "aws_ssm_parameter" "private_subnet_id" {
  name = "/${var.Project_Name}/${var.Environment}/private_subnet_id"
}


data "aws_route53_zone" "domain_zone_id" {
  name         = var.zone_name
  private_zone = false
}


output "output_domain_zone_id" {
  value = data.aws_route53_zone.domain_zone_id.id
}

output "output_app_alb_zone_id" {
  value = aws_lb.app_alb.zone_id
}