aws_region = "eu-central-1"

instance_type = "t3.micro"
min_size      = 1
max_size      = 2
environment   = "dev"

vpc_cidr             = "10.0.0.0/16"
public_subnet_a_cidr = "10.0.1.0/24"
public_subnet_b_cidr = "10.0.2.0/24"

availability_zone_a = "eu-central-1a"
availability_zone_b = "eu-central-1b"

alb_name = "nodejs-demoapp-alb-dev"