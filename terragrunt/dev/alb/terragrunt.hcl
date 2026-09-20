
terraform {
  source = "../../../modules/alb"
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "sg" {
  config_path = "../sg"
}

inputs = {
  name        = "nodejs-demoapp"
  environment = "dev"

  vpc_id = dependency.vpc.outputs.vpc_id

  subnet_ids = dependency.vpc.outputs.public_subnet_ids

  security_group_id = dependency.sg.outputs.alb_security_group_id
}