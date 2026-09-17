
data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

//Adding instance definition
resource "aws_launch_template" "app" {
  name_prefix   = "nodejs-demoapp-"
  image_id      = data.aws_ssm_parameter.al2023_ami.value
  instance_type = var.instance_type

  vpc_security_group_ids = [
    aws_security_group.ec2.id
  ]

  user_data = filebase64("../../user_data/user_data.sh")

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "nodejs-demoapp"
      Environment = "dev"
    }
  }
}

//Adding ASG
resource "aws_autoscaling_group" "app" {
  name = "nodejs-demoapp-asg"

  min_size         = 1
  max_size         = 2
  desired_capacity = 1

  vpc_zone_identifier = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  target_group_arns = [
    aws_lb_target_group.app.arn
  ]

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "nodejs-demoapp"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "dev"
    propagate_at_launch = true
  }
}

