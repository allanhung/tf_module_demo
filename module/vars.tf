variable "environment" {
  description = "Environment Name"
}

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

# ---------------------------------------------------------------------------------------------------------------------
# Terragrunt Variables
# ---------------------------------------------------------------------------------------------------------------------

variable "region" {
  description = "Alicloud Region"
}

variable "state_files_bucket_name" {
  description = "OSS Bucket name for TF State files."
}

variable "terraform_module_root" {
  description = "TF Module Root required by Terragrunt."
}

variable "terraform_relative_shared_vpc_state_path" {
  description = "Relative path for Share VPC Path"
}

variable "keypair_name" {
  description = "Regional Key Pair Name"
}

