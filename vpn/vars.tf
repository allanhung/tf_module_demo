variable "name" {
    description = "dev"
  default = "dev"
}

variable "tunnels" {
  description = "Outside IP addresses from Site-to-Site VPN Connection on AWS"
  type = list(map(string))
}

variable "alicloud_subnets" {
  description = "Alibaba VPC local subnets"
  type = list(string)
}

variable "aws_subnets" {
  description = "AWS VPC subnets"
  type = list(string)
}
