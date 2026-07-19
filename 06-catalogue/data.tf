#fetching ami id from aws
data "aws_ami" "redhat-9-ami-id" {
  most_recent      = true
  owners           = ["973714476881"]

  filter {
    name   = "name"
    values = ["Redhat-9-DevOps-Practice"] #if vale randomlyy changes we can give like ["Redhat-9-DevOps-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ssm_parameter" "app_alb_sg_id" {
  name = "/${var.Project_Name}/${var.Environment}/app_alb_sg_id"
}

data "aws_ssm_parameter" "private_subnet_id" {
  name = "/${var.Project_Name}/${var.Environment}/private_subnet_id"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.Project_Name}/${var.Environment}/vpc_id"
}


data "aws_ssm_parameter" "catalogue_sg_id" {
  name = "/${var.Project_Name}/${var.Environment}/catalogue_sg_id"
}

data "aws_ssm_parameter" "app_alb_listner_rule" {
  name = "/${var.Project_Name}/${var.Environment}/app_alb_listner_rule"
}