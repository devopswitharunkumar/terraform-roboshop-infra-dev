resource "aws_lb_target_group" "catalogue_targetgroup" {
  name     = "${var.Project_Name}-${var.Environment}-${var.tags.Component}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.id
  deregistration_delay = 60

  health_check {
    path = "/health"
    port = 8080
    healthy_threshold = 2
    unhealthy_threshold = 3
    timeout = 5
    interval = 10
    matcher = "200-299"  # has to be HTTP 200 or fails
  }
}



#create 1 instance
module "catalogue" {
  source = "terraform-aws-modules/ec2-instance/aws"
  name = "${local.name}-${var.tags.Component}-ami"
  ami = data.aws_ami.redhat-9-ami-id.id
  instance_type = "t3.micro"
  
  create_security_group = false 
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]
  subnet_id = local.private_subnet_id
  iam_instance_profile = "TerraformRoleForEc2"


  tags = merge(
    var.common_tags,
    var.tags
  )
}


#provision with ansible
resource "null_resource" "catalogue" {
  triggers = {
    instance_id = module.catalogue.id
  }

  connection {
    host = module.catalogue.private_ip
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
      "sudo sh /tmp/bootstrap.sh catalogue dev"
    ]
  }
}


# stop the instance
resource "aws_ec2_instance_state" "stop_catalogue" {
  instance_id = module.catalogue.id
  state       = "stopped"
  depends_on = [ null_resource.catalogue ]
}

# Take the AMI from the stopped instance
resource "aws_ami_from_instance" "catalogue_ami" {
  name               = "${local.name}-${var.tags.Component}-AMI-${local.current_date}"
  source_instance_id = module.catalogue.id

  # Ensures your instance isn't accidentally modified during AMI creation
  tags = {
    Name = "${var.tags.Component}-Backup-AMI-For-Roboshop-Proj-xAutoScaling"
  }

  depends_on = [ aws_ec2_instance_state.stop_catalogue ]
}

#delete/stop(charges apply in stop state) the instance
resource "null_resource" "catalogue_instance_delete" {
  triggers = {
    instance_id = module.catalogue.id
    # after completing take ami task trigger this null resource
  }

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances instance-ids ${module.catalogue.id}"
  }
  depends_on = [ aws_ami_from_instance.catalogue_ami ]
}


#all resources will be created again existing one deleted
#we have created AMI now, create launch template with AMI
resource "aws_launch_template" "catalogue_launchtemplate" {
  name = "${local.name}-${var.tags.Component}-launchtmpt"


  image_id = aws_ami_from_instance.catalogue_ami.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t2.micro"
  update_default_version = true

#   placement {
#     availability_zone = "us-east-1a"
#   }


  vpc_security_group_ids = [ data.aws_ssm_parameter.catalogue_sg_id.id ]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${local.name}-${var.tags.Component}-launchtmpt"
    }
  }
}


#auto sscaling takes input as launch template
resource "aws_autoscaling_group" "catalogue_autoscaling" {
  name                      = "${local.name}-${var.tags.Component}-autoscalinggrp"
  max_size                  = 10
  min_size                  = 1
  health_check_grace_period = 100
  health_check_type         = "ELB"
  desired_capacity          = 2
  
  vpc_zone_identifier       = split(data.aws_ssm_parameter.private_subnet_id)
  target_group_arns = [ aws_lb_target_group.catalogue_targetgroup.arn ]
  

  launch_template {
    id      = aws_launch_template.catalogue_launchtemplate.id
    version = aws_launch_template.catalogue_launchtemplate.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
    #launch template epudaithe update avuthundo apudu autoscaling anedi instances refresh avuthai like old instances down ayi new instances u avuthai 
  }
  

  tag {
    key                 = "Name"
    value               = "${local.name}-${var.tags.Component}"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

}


resource "aws_lb_listener_rule" "catalogue_listner_rule" {
  listener_arn = data.aws_ssm_parameter.app_alb_listner_rule.value
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue_targetgroup.arn
  }

  condition {
    host_header {
      values = ["${var.tags.Component}.app-alb-${var.Environment}.${var.zone_name}"]
    }
  }
}



resource "aws_autoscaling_policy" "cpu_target_tracking" {
  name                   = "${local.name}-${var.tags.Component}-autoscalinggrp-tracking-policy"
  autoscaling_group_name = aws_autoscaling_group.catalogue_autoscaling.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 5.0
  }
}