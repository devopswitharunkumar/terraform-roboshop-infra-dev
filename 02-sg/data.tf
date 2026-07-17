data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.Project_Name}/${var.Environment}/vpc_id"
}

data "aws_vpc" "default_vpc_id" {
  default = true
}