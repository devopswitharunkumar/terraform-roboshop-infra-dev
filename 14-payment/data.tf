data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.Project_Name}/${var.Environment}/vpc_id"
}

data "aws_ssm_parameter" "payment_sg_id" {
  name = "/${var.Project_Name}/${var.Environment}/payment_sg_id"
}

data "aws_ssm_parameter" "private_subnet_id" {
  name = "/${var.Project_Name}/${var.Environment}/private_subnet_id"
}


data "aws_ssm_parameter" "app_alb_listner_rule" {
  name = "/${var.Project_Name}/${var.Environment}/app_alb_listner_rule"
}