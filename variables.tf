variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "ami" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = "ami-084568db4383264d4"
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "mydatabase"
}

variable "db_username" {
  description = "The username for the database"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  default     = "mypassword"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Name = "TerraformProject"
  }
}
