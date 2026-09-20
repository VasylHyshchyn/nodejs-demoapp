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
  name        = "nodejs-demoapp-production"
  environment = "production"

  min_size         = 2
  max_size         = 4
  desired_capacity = 2

  subnet_ids = dependency.vpc.outputs.public_subnet_ids

  launch_template_id = dependency.ec2.outputs.launch_template_id

  target_group_arns = [
    dependency.alb.outputs.target_group_arn
  ]
}