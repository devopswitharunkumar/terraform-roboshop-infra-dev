variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
  type = bool
  default = true
}

variable "common_tags" {
  type = map(string)
  default = {
    Name = "roboshop-project"
    Environment = "dev"
    Terraform = true
  }
}

variable "vpc_tags" {
  type = map(string)
  default = {}
}

variable "Project_Name" {
  type = string
  default = "roboshop"
}

variable "Environment" {
  type = string
  default = "dev"
}

variable "igw_tags" {
    type = map(string)
    default = {}
  
}

#public subnet
variable "public_subnet_cidr" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

#private subnet
variable "private_subnet_cidr" {
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

#database subnet
variable "database_subnet_cidr" {
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}

#public_route_table_tags
variable "public_route_table_cidr_block" {
  default = "0.0.0.0/0"
}

#peering related
variable "is_peering_required" {
  type = bool
  default = true
}