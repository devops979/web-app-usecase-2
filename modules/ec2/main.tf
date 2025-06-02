resource "aws_instance" "web" {
  count         = var.instance_count
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_ids[count.index]
  security_groups = [var.security_group_id]

  user_data = var.user_data

  tags = var.tags
}

output "web_instance_ids" {
  value = aws_instance.web[*].id
}

output "web_instance_ips" {
  value = aws_instance.web[*].public_ip
}
