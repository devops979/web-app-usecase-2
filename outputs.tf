output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.subnets.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.subnets.private_subnet_ids
}

output "web_instance_ids" {
  value = module.ec2.web_instance_ids
}

output "web_instance_ips" {
  value = module.ec2.web_instance_ips
}

output "db_endpoint" {
  value = module.rds.db_endpoint
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
