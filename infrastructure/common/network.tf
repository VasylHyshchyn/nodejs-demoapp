//Netowrk configuration

//VPC Creation
resource "aws_vpc" "app_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "nodejs-demoapp-vpc"
    Environment = "dev"
  }
}

//VPC subnets
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "nodejs-demoapp-public-a"
    Environment = "dev"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true

  tags = {
    Name        = "nodejs-demoapp-public-b"
    Environment = "dev"
  }
}

//Inetrnet gateway
resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name        = "nodejs-demoapp-igw"
    Environment = "dev"
  }
}

//Route table for roting traffic outside
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_igw.id
  }

  tags = {
    Name        = "nodejs-demoapp-public-rt"
    Environment = "dev"
  }
}

//Attaching table to the Subnets
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

//Security groups
//Adding SG for ALB
resource "aws_security_group" "alb" {
  name        = "nodejs-demoapp-alb-sg"
  description = "Security group for Node.js demoapp ALB"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "nodejs-demoapp-alb-sg"
    Environment = "dev"
  }
}

//Adding SG for EC2
resource "aws_security_group" "ec2" {
  name        = "nodejs-demoapp-ec2-sg"
  description = "Security group for Node.js demoapp EC2 instances"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    description     = "Node.js app from ALB"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "nodejs-demoapp-ec2-sg"
    Environment = "dev"
  }
}


//ALB

//Adding target groups
resource "aws_lb_target_group" "app" {
  name     = "nodejs-demoapp-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.app_vpc.id

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
  }

  tags = {
    Name        = "nodejs-demoapp-tg"
    Environment = "dev"
  }
}

//Adding ALB
resource "aws_lb" "app" {
  name               = "nodejs-demoapp-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  tags = {
    Name        = "nodejs-demoapp-alb"
    Environment = "dev"
  }
}

//Adding listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  tags = {
    Name        = "nodejs-demoapp-http-listener"
    Environment = "dev"
  }
}