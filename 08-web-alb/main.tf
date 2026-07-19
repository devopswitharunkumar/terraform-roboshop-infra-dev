# creating web aplication load balancer

resource "aws_lb" "web_alb" {
  name               = "${local.name}-${var.tags.Component}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.web_alb_sg_id.value]
  subnets            = split(",", data.aws_ssm_parameter.public_subnet_id.value)
  

  tags = merge(
    var.common_tags,
    var.tags
  )
}


#web alb shoould listen only port 80
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"  #in web alb u can get while creating u can see security policy 
  certificate_arn   = data.aws_ssm_parameter.acm_certificate_arn.value

  default_action {
    type = "fixed-response"

     fixed_response {
      content_type = "text/plain"
      message_body = "Hi, This response is from Web ALB using HTTPS"
      status_code  = "200"
    }
  }
}


#Route53 records for above db instances
resource "aws_route53_record" "web_alb_alias" {
  zone_id = data.aws_route53_zone.domain_zone_id.id

  name = "web-${var.Environment}"
  type = "A"

  alias {
    name                   = aws_lb.web_alb.dns_name
    zone_id                = aws_lb.web_alb.zone_id
    evaluate_target_health = true
  }
}