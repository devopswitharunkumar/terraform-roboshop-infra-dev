module "vpn" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name          = "${local.ec2_name}-vpn"
  ami           = data.aws_ami.redhat-9-ami-id.id
  instance_type = "t3.micro"

  create_security_group = false

  vpc_security_group_ids = [
    data.aws_ssm_parameter.vpn_sg_id.value
  ]

  subnet_id = data.aws_subnet.default_subnet_in_default_vpc.id
  user_data = file("${path.module}/openvpn.sh")
  user_data_replace_on_change = true


  tags = merge(
    var.common_tags,
    {
      Component = "vpn"
      Name      = "${local.ec2_name}-vpn"
    }
  )
}


