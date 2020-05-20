variable "vpc_cidr" {
  description = "VPC CIDR Block"
}

variable "availability_zones" {
  description = "availability zones"
  type        = list(string)
}

variable "vswitch_cidrs" {
  description = "Private Subnets for the VPC"
  type        = list(string)
}

# ---------------------------------------------------------------------------------------------------------------------
# Terragrunt Variables
# ---------------------------------------------------------------------------------------------------------------------

variable "environment" {
  description = "Environment Name"
}
