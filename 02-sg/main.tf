#VPN Security Groups
module "vpn" {
  source = "git::https://github.com/devopswitharunkumar/terraform-aws-security-group.git?ref=main"
  Project_Name = var.Project_Name
  Environment = var.Environment
  #we need to take default vpc id remaining below sg groups should be created in roboshop vpc
  vpc_id = data.aws_vpc.default_vpc_id.id
  sg_name = var.vpn_sg_name
  sg_description = var.vpn_sg_description
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}



#Database Security Groups
module "mongodb" {
  source = "git::https://github.com/devopswitharunkumar/terraform-aws-security-group.git?ref=main"
  Project_Name = var.Project_Name
  Environment = var.Environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value 
  sg_name = var.mongodb_sg_name
  sg_description = var.mongodb_sg_description
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "redis" {
  source = "git::https://github.com/devopswitharunkumar/terraform-aws-security-group.git?ref=main"
  Project_Name = var.Project_Name
  Environment = var.Environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value 
  sg_name = var.redis_sg_name
  sg_description = var.redis_sg_description
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "mysql" {
  source = "git::https://github.com/devopswitharunkumar/terraform-aws-security-group.git?ref=main"
  Project_Name = var.Project_Name
  Environment = var.Environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value 
  sg_name = var.mysql_sg_name
  sg_description = var.mysql_sg_description
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "rabbitmq" {
  source = "git::https://github.com/devopswitharunkumar/terraform-aws-security-group.git?ref=main"
  Project_Name = var.Project_Name
  Environment = var.Environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value 
  sg_name = var.rabbitmq_sg_name
  sg_description = var.rabbitmq_sg_description
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}


#Application Security Groups

module "catalogue" {
  source = "git::https://github.com/devopswitharunkumar/terraform-aws-security-group.git?ref=main"
  Project_Name = var.Project_Name
  Environment = var.Environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value 
  sg_name = var.catalogue_sg_name
  sg_description = var.catalogue_sg_description
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "cart" {
  source = "git::https://github.com/devopswitharunkumar/terraform-aws-security-group.git?ref=main"
  Project_Name = var.Project_Name
  Environment = var.Environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value 
  sg_name = var.cart_sg_name
  sg_description = var.cart_sg_description
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "user" {
  source = "git::https://github.com/devopswitharunkumar/terraform-aws-security-group.git?ref=main"
  Project_Name = var.Project_Name
  Environment = var.Environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value 
  sg_name = var.user_sg_name
  sg_description = var.user_sg_description
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "shipping" {
  source = "git::https://github.com/devopswitharunkumar/terraform-aws-security-group.git?ref=main"
  Project_Name = var.Project_Name
  Environment = var.Environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value 
  sg_name = var.shipping_sg_name
  sg_description = var.shipping_sg_description
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "payment" {
  source = "git::https://github.com/devopswitharunkumar/terraform-aws-security-group.git?ref=main"
  Project_Name = var.Project_Name
  Environment = var.Environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value 
  sg_name = var.payment_sg_name
  sg_description = var.payment_sg_description
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "web" {
  source = "git::https://github.com/devopswitharunkumar/terraform-aws-security-group.git?ref=main"
  Project_Name = var.Project_Name
  Environment = var.Environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value 
  sg_name = var.web_sg_name
  sg_description = var.web_sg_description
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}


################# From Here Rules will start ##############################


#for openvpn 
resource "aws_security_group_rule" "openvpn_rule_to_connect_to_private_ec2_s" {
  security_group_id = module.vpn.sg_id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

# #extra i added
# resource "aws_security_group_rule" "vpn_egress" {
#   security_group_id = module.vpn.sg_id
#   type        = "egress"
#   from_port   = 0
#   to_port     = 0
#   protocol    = "-1"
#   cidr_blocks = ["0.0.0.0/0"]
#   description = "Allow VPN EC2 outbound internet access"
# }

#mongodb rules
#mongodb accepting connections from catalogue instance instead of ingress rules because ip address is dynamic u can use this way
resource "aws_security_group_rule" "mongodb_accept_catalogue_traffic" {
    source_security_group_id = module.catalogue.sg_id
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  security_group_id = module.mongodb.sg_id
}


resource "aws_security_group_rule" "mongodb_accept_user_traffic" {
    source_security_group_id = module.user.sg_id #from user to mongodb
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  security_group_id = module.mongodb.sg_id  #into mongodb in which sg we need to add other sg that sg id 
  
}


resource "aws_security_group_rule" "mongodb_accept_vpn_traffic" {
    source_security_group_id = module.vpn.sg_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = module.mongodb.sg_id
}



#redis rules
resource "aws_security_group_rule" "redis_accept_user_traffic" {
    source_security_group_id = module.user.sg_id 
  type              = "ingress"
  from_port         = 6397
  to_port           = 6397
  protocol          = "tcp"
  security_group_id = module.redis.sg_id 
}


resource "aws_security_group_rule" "redis_accept_cart_traffic" {
    source_security_group_id = module.cart.sg_id 
  type              = "ingress"
  from_port         = 6397
  to_port           = 6397
  protocol          = "tcp"
  security_group_id = module.redis.sg_id 
}

resource "aws_security_group_rule" "redis_accept_vpn_traffic" {
    source_security_group_id = module.vpn.sg_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = module.redis.sg_id
}



#mysql rules
resource "aws_security_group_rule" "mysql_accept_shipping_traffic" {
    source_security_group_id = module.shipping.sg_id 
  type              = "ingress"
  from_port         = 3306 
  to_port           = 3306 
  protocol          = "tcp"
  security_group_id = module.mysql.sg_id 
}

resource "aws_security_group_rule" "mysql_accept_vpn_traffic" {
    source_security_group_id = module.vpn.sg_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = module.mysql.sg_id
}



#rabbitmq rules
resource "aws_security_group_rule" "rabbitmq_accept_payment_traffic" {
    source_security_group_id = module.payment.sg_id 
  type              = "ingress"
  from_port         = 5672 
  to_port           = 5672 
  protocol          = "tcp"
  security_group_id = module.rabbitmq.sg_id 
}

resource "aws_security_group_rule" "rabbitmq_accept_vpn_traffic" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.rabbitmq.sg_id 
}



#catalogue rules 
resource "aws_security_group_rule" "catalogue_accept_vpn_traffic" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.catalogue.sg_id
}

# resource "aws_security_group_rule" "catalogue_accept_web_traffic" {
#   source_security_group_id = module.web.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.catalogue.sg_id
# }

# resource "aws_security_group_rule" "catalogue_accept_cart_traffic" {
#   source_security_group_id = module.cart.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.catalogue.sg_id
# }

#user rules 
resource "aws_security_group_rule" "user_accept_vpn_traffic" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.user.sg_id
}

# resource "aws_security_group_rule" "user_accept_web_traffic" {
#   source_security_group_id = module.web.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.user.sg_id
# }

# resource "aws_security_group_rule" "user_accept_payment_traffic" {
#   source_security_group_id = module.payment.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.user.sg_id
# }

#cart rules 
resource "aws_security_group_rule" "cart_accept_vpn_traffic" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_accept_web_traffic" {
  source_security_group_id = module.web.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_accept_shipping_traffic" {
  source_security_group_id = module.shipping.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_accept_payment_traffic" {
  source_security_group_id = module.payment.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.cart.sg_id
}

#shipping rules 
resource "aws_security_group_rule" "shipping_accept_vpn_traffic" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.shipping.sg_id
}

resource "aws_security_group_rule" "shipping_accept_web_traffic" {
  source_security_group_id = module.web.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.shipping.sg_id
}

#payment rules
resource "aws_security_group_rule" "payment_accept_vpn_traffic" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.payment.sg_id
}

resource "aws_security_group_rule" "payment_accept_web_traffic" {
  source_security_group_id = module.web.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.payment.sg_id
}

#web rules
resource "aws_security_group_rule" "web_accept_vpn_tarrfic" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.web.sg_id
}

resource "aws_security_group_rule" "web_accept_internet_traffic" {
  cidr_blocks = ["0.0.0.0/0"]
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = module.web.sg_id
}



#load balancer related 


module "app_alb" {
  source = "git::https://github.com/devopswitharunkumar/terraform-aws-security-group.git?ref=main"
  Project_Name = var.Project_Name
  Environment = var.Environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value 
  sg_name = var.app_alb_sg_name
  sg_description = var.app_alb_sg_description
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}


resource "aws_security_group_rule" "catalogue_accept_app_alb_traffic" {
  source_security_group_id = module.app_alb.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.catalogue.sg_id
}
#comment catalogue accepting from web because we placed alb in between

resource "aws_security_group_rule" "user_accept_app_alb_traffic" {
  source_security_group_id = module.app_alb.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.user.sg_id
}