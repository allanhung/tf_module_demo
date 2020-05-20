variable "cidr_block" {
  description = "VPC CIDR Block"
}

variable "vswitch_cidr_blocks" {
  description = "Private Subnets for the VPC"
  type        = list(string)
}

variable "bandwidth" {
  description = "Bandwidth Associated with SNAT"
  default     = 10
}
