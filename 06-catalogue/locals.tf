locals {
  name = "${var.Project_Name}-${var.Environment}"
  current_date = formatdate("YYYY-MM-DD-hh-mm", timestamp())
  private_subnet_id = element(split(",", data.aws_ssm_parameter.private_subnet_id), 0)
}

