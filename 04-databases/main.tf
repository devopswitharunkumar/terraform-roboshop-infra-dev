#Database related EC2 instance code
module "mongodb" {
  source = "terraform-aws-modules/ec2-instance/aws"
  name = "${local.ec2_name}-mongodb"
  ami = data.aws_ami.redhat-9-ami-id.id
  instance_type = "t3.small"
  
  create_security_group = false # this resource creating egress sg extra for that not to create we used this it will not create new sg if false 

  vpc_security_group_ids = [data.aws_ssm_parameter.mongodb_sg_id.value]
  subnet_id = local.database_subnet_id
  

  tags = merge(
    var.common_tags,
    {
        Component = "mongodb"
    },
    {
        Name = "${local.ec2_name}-mongodb"
    }
  )
}



resource "null_resource" "mongodb" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.mongodb.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host = module.mongodb.private_ip    
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
  }

  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh" 
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mongodb dev"
    ]
  }
}




module "redis" {
  source = "terraform-aws-modules/ec2-instance/aws"
  name = "${local.ec2_name}-redis"
  ami = data.aws_ami.redhat-9-ami-id.id
  instance_type = "t3.micro"
  
  create_security_group = false
  vpc_security_group_ids = [data.aws_ssm_parameter.redis_sg_id.value]
  subnet_id = local.database_subnet_id
  

  tags = merge(
    var.common_tags,
    {
        Component = "redis"
    },
    {
        Name = "${local.ec2_name}-redis"
    }
  )
}



resource "null_resource" "redis" {
  triggers = {
    instance_id = module.redis.id
  }


  connection {
    host = module.redis.private_ip
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
  }

  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh" 
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh redis dev"
    ]
  }
}



module "mysql" {
  source = "terraform-aws-modules/ec2-instance/aws"
  name = "${local.ec2_name}-mysql"
  ami = data.aws_ami.redhat-9-ami-id.id
  instance_type = "t3.small"
  
  create_security_group = false 
  vpc_security_group_ids = [data.aws_ssm_parameter.mysql_sg_id.value]
  subnet_id = local.database_subnet_id
  iam_instance_profile = "TerraformRoleForEc2"


  tags = merge(
    var.common_tags,
    {
        Component = "mysql"
    },
    {
        Name = "${local.ec2_name}-mysql"
    }
  )
}

resource "null_resource" "mysql" {
  triggers = {
    instance_id = module.mysql.id
  }


  connection {
    host = module.mysql.private_ip
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
  }

  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh" 
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mysql dev"
    ]
  }
}



module "rabbitmq" {
  source = "terraform-aws-modules/ec2-instance/aws"
  name = "${local.ec2_name}-rabbitmq"
  ami = data.aws_ami.redhat-9-ami-id.id
  instance_type = "t3.micro"
  
  create_security_group = false 
  vpc_security_group_ids = [data.aws_ssm_parameter.rabbitmq_sg_id.value]
  subnet_id = local.database_subnet_id
  iam_instance_profile = "TerraformRoleForEc2"


  tags = merge(
    var.common_tags,
    {
        Component = "rabbitmq"
    },
    {
        Name = "${local.ec2_name}-rabbitmq"
    }
  )
}



resource "null_resource" "rabbitmq" {
  triggers = {
    instance_id = module.rabbitmq.id
  }

  connection {
    host = module.rabbitmq.private_ip
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
  }

  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh" 
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh rabbitmq dev"
    ]
  }
}