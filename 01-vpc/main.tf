module "roboshop-vpc" {
  # source = "../"

  source = "git::https://github.com/devopswitharunkumar/terraform-aws-vpc-setup.git?ref=main"

  Project_Name = var.Project_Name
  Environment = var.Environment
  common_tags = var.common_tags
  vpc_tags = var.vpc_tags

  #public subnet
  public_subnet_cidr = var.public_subnet_cidr

  #private subnet
  private_subnet_cidr = var.private_subnet_cidr

  #private subnet
  database_subnet_cidr = var.database_subnet_cidr

  #public route table
  public_route_table_cidr_block = var.public_route_table_cidr_block

  #vpc peering related
  is_peering_required = var.is_peering_required
}