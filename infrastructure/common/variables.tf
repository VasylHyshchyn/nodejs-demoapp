variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "Minimal capacity for ASG"
  type        = number
}

variable "max_size" {
  description = "Max insrance capacity for ASG"
  type        = number

}

variable "environment" {
  description = "Env type"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_a_cidr" {
  description = "CIDR block for public subnet A"
  type        = string
}

variable "public_subnet_b_cidr" {
  description = "CIDR block for public subnet B"
  type        = string
}

variable "availability_zone_a" {
  description = "Availability Zone for public subnet A"
  type        = string
}

variable "availability_zone_b" {
  description = "Availability Zone for public subnet B"
  type        = string
}

variable "alb_name" {
  description = "ALB name"
  type        = string
}