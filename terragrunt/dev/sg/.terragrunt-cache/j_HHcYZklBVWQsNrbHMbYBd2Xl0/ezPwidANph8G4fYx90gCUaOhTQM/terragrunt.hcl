
terraform {
  source = "../../../modules/sg"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  name        = "nodejs-demoapp"
  environment = "dev"

  vpc_id = dependency.vpc.outputs.vpc_id
}