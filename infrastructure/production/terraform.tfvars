aws_region = "eu-central-1"

instance_type = "t3.small"
min_size      = 2
max_size      = 4
environment   = "prod"

vpc_cidr             = "10.1.0.0/16"
public_subnet_a_cidr = "10.1.1.0/24"
public_subnet_b_cidr = "10.1.2.0/24"

availability_zone_a = "eu-central-1a"
availability_zone_b = "eu-central-1b"

alb_name = "nodejs-demoapp-alb-prod"