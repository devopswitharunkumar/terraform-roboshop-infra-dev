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


variable "zone_name" {
  default = "devopswitharun.online"
}