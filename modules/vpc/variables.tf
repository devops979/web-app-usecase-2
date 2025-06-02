variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
