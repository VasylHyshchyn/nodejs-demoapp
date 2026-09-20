terraform {
  source = "../../../modules/autoscaling"
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "ec2" {
  config_path = "../ec2"
}

dependency "alb" {
  config_path = "../alb"
}

inputs = {
  name        = "nodejs-demoapp"
  environment = "dev"

  min_size         = 1
  max_size         = 2
  desired_capacity = 1

  subnet_ids = dependency.vpc.outputs.public_subnet_ids

  launch_template_id = dependency.ec2.outputs.launch_template_id

  target_group_arns = [
    dependency.alb.outputs.target_group_arn
  ]
}