output "azs" {
  value = module.roboshop-vpc.availability_zones
}

output "az" {
  value = module.roboshop-vpc.az
}

output "public_subnet" {
  value = module.roboshop-vpc.public_subnets_id
}

output "private_subnet" {
  value = module.roboshop-vpc.private_subnets_id
}

output "database_subnet" {
  value = module.roboshop-vpc.database_subnets_id
}