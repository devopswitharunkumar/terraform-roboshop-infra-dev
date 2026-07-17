locals {
  ec2_name = "${var.Project_Name}-${var.Environment}"
  database_subnet_id = element(split(",", data.aws_ssm_parameter.database_subnet_id.value), 0) 
}


