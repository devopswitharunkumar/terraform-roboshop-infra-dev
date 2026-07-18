# creating aplication load balancer

resource "aws_lb" "app_alb" {
  name               = "${local.app_alb_name}-${var.tags.Component}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.app_alb_sg_id.value]
  subnets            = split(",", data.aws_ssm_parameter.private_subnet_id.value)

  # enable_deletion_protection = true

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.id
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  tags = merge(
    var.common_tags,
    var.tags
  )
}


#app alb shoould listen only port 80
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

     fixed_response {
      content_type = "text/plain"
      message_body = "Hi, This response is from App ALB"
      status_code  = "200"
    }
  }
}

#we are adding route53 record for app-alb so *.app-alb.devopswitharun.online 
#ex: 
# catalogue.app-alb.devopswitharun.online
# cart.app-alb.devopswitharun.online
# shipping.app-alb.devopswitharun.online
# etc  ike this we can use this record

#Route53 records for above db instances
resource "aws_route53_record" "app_alb_alias" {
  zone_id = data.aws_route53_zone.domain_zone_id.id

  name = "*.app-alb-${var.Environment}.${var.zone_name}"
  type = "A"

  alias {
    name                   = aws_lb.app_alb.dns_name
    zone_id                = aws_lb.app_alb.zone_id
    evaluate_target_health = true
  }
}

