variable "Project_Name" {
  type = string
  default = "roboshop"
}

variable "Environment" {
  type = string
  default = "dev"
}

variable "common_tags" {
  type = map(string)
  default = {
    Name = "Roboshop-Project"
    Terraform = true
    Environment = "dev"
  }
}


variable "tags" {
    default = {
        Component = "shipping"
    }
}


variable "zone_name" {
  default = "devopswitharun.online"
}

variable "iam_instance_profile" {
    default = "TerraformRoleForEc2"
}

variable "alb_listner_rule_priority" {
  default = 40
}