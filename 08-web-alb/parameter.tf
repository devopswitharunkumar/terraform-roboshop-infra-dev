resource "aws_ssm_parameter" "web_alb_listner_rule" {
  name  = "/${var.Project_Name}/${var.Environment}/web_alb_listner_rule"
  type  = "String"
  value = aws_lb_listener.https.arn
}

resource "aws_ssm_parameter" "web_alb_dns_name" {
  name  = "/${var.Project_Name}/${var.Environment}/web_alb_dns_name"
  type  = "String"
  value = aws_lb.web_alb.dns_name
}
