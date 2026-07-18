resource "aws_ssm_parameter" "app_alb_listner_rule" {
  name  = "/${var.Project_Name}/${var.Environment}/app_alb_listner_rule"
  type  = "String"
  value = aws_lb_listener.http.arn
}
