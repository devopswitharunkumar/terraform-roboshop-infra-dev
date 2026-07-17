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
    Name = "roboshop-project"
    Environment = "dev"
    Terraform = true
  }
}

variable "sg_tags" {
  type = map
  default = {}
}




# #ingress rules related 
# variable "mongodb_sg_ingress_rules" {
#   type = list 
#   default = [
#     {
#     description     = "Allowing all inbound port 0"
#     from_port       = 80
#     to_port         = 80
#     protocol        = "tcp"
#     cidr_blocks     = ["0.0.0.0/0"]
#   },
#   {
#     description     = "Allowing all inbound port 22"
#     from_port       = 443
#     to_port         = 443
#     protocol        = "tcp"
#     cidr_blocks     = ["0.0.0.0/0"]
#   }
    
#   ]
# }

#VPN sg variables
variable "vpn_sg_name" {
  type = string
  default = "vpn"
}

variable "vpn_sg_description" {
  type = string
  default = "VPN SG"
}


#Database sg variables
variable "mongodb_sg_name" {
  type = string
  default = "mongodb"
}

variable "mongodb_sg_description" {
  type = string
  default = "Mongodb SG"
}


variable "redis_sg_name" {
  type = string
  default = "redis"
}

variable "redis_sg_description" {
  type = string
  default = "Redis SG"
}

variable "rabbitmq_sg_name" {
  type = string
  default = "rabbitmq"
}

variable "rabbitmq_sg_description" {
  type = string
  default = "RabbitMQ SG"
}

variable "mysql_sg_name" {
  type = string
  default = "mysql"
}

variable "mysql_sg_description" {
  type = string
  default = "MYSQL SG"
}

#Application sg variables

variable "catalogue_sg_name" {
  type = string
  default = "catalogue"
}

variable "catalogue_sg_description" {
  type = string
  default = "Catalogue SG"
}

variable "cart_sg_name" {
  type = string
  default = "cart"
}

variable "cart_sg_description" {
  type = string
  default = "Cart SG"
}

variable "user_sg_name" {
  type = string
  default = "user"
}

variable "user_sg_description" {
  type = string
  default = "User SG"
}


variable "shipping_sg_name" {
  type = string
  default = "shipping"
}

variable "shipping_sg_description" {
  type = string
  default = "Shipping SG"
}


variable "payment_sg_name" {
  type = string
  default = "payment"
}

variable "payment_sg_description" {
  type = string
  default = "Payment SG"
}

variable "web_sg_name" {
  type = string
  default = "web"
}

variable "web_sg_description" {
  type = string
  default = "Web SG"
}




#app alb related 
variable "app_alb_sg_name" {
  type = string
  default = "app-alb"
}

variable "app_alb_sg_description" {
  type = string
  default = "App ALB SG"
}
