data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

// Adding instance definition
resource "aws_launch_template" "app" {
  name_prefix   = "nodejs-demoapp-${var.environment}-"
  image_id      = data.aws_ssm_parameter.al2023_ami.value
  instance_type = var.instance_type

  vpc_security_group_ids = [
    aws_security_group.ec2.id
  ]

  user_data = filebase64("../../user_data/user_data.sh")

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "nodejs-demoapp-${var.environment}"
      Environment = var.environment
    }
  }
}

// Adding ASG
resource "aws_autoscaling_group" "app" {
  name = "nodejs-demoapp-${var.environment}-asg"

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.min_size

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
    value               = "nodejs-demoapp-${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}

