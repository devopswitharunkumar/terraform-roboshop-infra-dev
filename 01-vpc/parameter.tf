resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.Project_Name}/${var.Environment}/vpc_id"
  type  = "String"
  value = module.roboshop-vpc.vpc_id
}

#list is not accepting in this because we have 2 subnets each so used join with , seperator

output "public_subnets_id" {
  value = module.roboshop-vpc.public_subnets_id
} #checking how the output coming based on that used below 

resource "aws_ssm_parameter" "public_subnet_id" {
  name  = "/${var.Project_Name}/${var.Environment}/public_subnet_id"
  type  = "StringList"
  value = join(",",  module.roboshop-vpc.public_subnets_id)
}

resource "aws_ssm_parameter" "private_subnet_id" {
  name  = "/${var.Project_Name}/${var.Environment}/private_subnet_id"
  type  = "StringList"
  value = join(",",  module.roboshop-vpc.private_subnets_id)
}

resource "aws_ssm_parameter" "database_subnet_id" {
  name  = "/${var.Project_Name}/${var.Environment}/database_subnet_id"
  type  = "StringList"
  value = join(",",  module.roboshop-vpc.database_subnets_id)
}