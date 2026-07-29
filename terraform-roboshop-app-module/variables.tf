variable "Project_Name" {
  # default = "roboshop"
}

variable "Environment" {
  # default = "dev"
}


variable "common_tags" {
  # type = map(string)
  # default = {
  #   Name = "Roboshop-Project"
  #   Terraform = true
  #   Environment = "dev"
  # }
}


variable "tags" {
}


variable "zone_name" {
  #default = "devopswitharun.online"
}

variable "vpc_id" {
}

variable "component_sg_id" {
}

variable "private_subnet_id" { #if blank user must provide while using module
}

variable "iam_instance_profile" {
}

variable "app_alb_listner_arn" {
}

variable "alb_listner_rule_priority" {
  
}

variable "app_version" {
  
}