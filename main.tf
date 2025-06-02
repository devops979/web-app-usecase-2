
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.94.1"
    }
  }
}

provider "aws" {
  region = var.region
}
data "aws_availability_zones" "available" {}

module "vpc" {
  source     = "./modules/vpc"
  cidr_block = var.cidr_block
  tags       = var.tags
}

module "subnets" {
  source             = "./modules/subnets"
  vpc_id             = module.vpc.vpc_id
  vpc_cidr_block     = var.cidr_block
  availability_zones = data.aws_availability_zones.available.names
  tags               = var.tags
}

module "route_tables" {
  source             = "./modules/route_tables"
  vpc_id             = module.vpc.vpc_id
  igw_id             = module.vpc.igw_id
  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
  tags               = var.tags
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
  tags   = var.tags
}

module "ec2" {
  source            = "./modules/ec2"
  instance_count    = 2
  ami               = var.ami
  instance_type     = var.instance_type
  subnet_ids        = module.subnets.public_subnet_ids
  security_group_id = module.security_groups.web_sg_id
  user_data         = <<-EOF
                      #!/bin/bash
                      sudo apt update -y
                      sudo apt install nginx -y
                      sudo systemctl start nginx
                      sudo systemctl enable nginx
                      EOF
  tags              = var.tags
}

module "rds" {
  source               = "./modules/rds"
  db_subnet_group_name = "main-db-subnet-group"
  subnet_ids           = module.subnets.private_subnet_ids
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  #parameter_group_name  = "default.mysql8.0"
  vpc_security_group_ids = [module.security_groups.db_sg_id]
  tags                   = var.tags
}

module "alb" {
  source                = "./modules/alb"
  name                  = "web-lb"
  security_group_id     = module.security_groups.web_sg_id
  subnet_ids            = module.subnets.public_subnet_ids
  target_group_name     = "web-target-group"
  target_group_port     = 80
  target_group_protocol = "HTTP"
  vpc_id                = module.vpc.vpc_id
  health_check_path     = "/"
  health_check_protocol = "HTTP"
  health_check_interval = 30
  health_check_timeout  = 5
  healthy_threshold     = 2
  unhealthy_threshold   = 2
  listener_port         = 80
  listener_protocol     = "HTTP"
  target_ids            = module.ec2.web_instance_ids
  tags                  = var.tags
}
