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