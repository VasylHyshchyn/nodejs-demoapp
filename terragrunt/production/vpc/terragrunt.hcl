terraform {
  source = "../../../modules/vpc"
}

inputs = {
  name        = "nodejs-demoapp"
  environment = "production"

  vpc_cidr = "10.1.0.0/16"

  public_subnet_a_cidr = "10.1.1.0/24"
  public_subnet_b_cidr = "10.1.2.0/24"

  availability_zone_a = "us-east-1a"
  availability_zone_b = "us-east-1b"
}