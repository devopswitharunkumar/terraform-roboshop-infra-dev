#getting data stored in ssm parameter of sg id's
data "aws_ssm_parameter" "mongodb_sg_id" {
  name = "/${var.Project_Name}/${var.Environment}/mongodb_sg_id"
}

data "aws_ssm_parameter" "redis_sg_id" {
  name = "/${var.Project_Name}/${var.Environment}/redis_sg_id"
}

data "aws_ssm_parameter" "mysql_sg_id" {
  name = "/${var.Project_Name}/${var.Environment}/mysql_sg_id"
}

data "aws_ssm_parameter" "rabbitmq_sg_id" {
  name = "/${var.Project_Name}/${var.Environment}/rabbitmq_sg_id"
}


data "aws_ssm_parameter" "vpn_sg_id" {
  name = "/${var.Project_Name}/${var.Environment}/vpn_sg_id"
}


#getting data stored in ssm parameter of subnet id's
data "aws_ssm_parameter" "database_subnet_id" {
  name = "/${var.Project_Name}/${var.Environment}/database_subnet_id"
}


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

data "aws_route53_zone" "domain_zone_id" {
  name         = "devopswitharun.online"
  private_zone = false
}


data "aws_vpc" "default_vpc_id" {
  default = true
}

data "aws_subnet" "default_subnet_in_default_vpc" {
    vpc_id = data.aws_vpc.default_vpc_id.id
    availability_zone = "us-east-1a"
}