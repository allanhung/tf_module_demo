resource "alicloud_vpn_gateway" "aws" {
  name                 = "aws-${var.name}"
  vpc_id               = data.terraform_remote_state.vpc.outputs.vpc_id
  bandwidth            = "10"
  enable_ssl           = true
  instance_charge_type = "PostPaid"
  description          = "VPN to AWS Quid Shared VPC"
}

resource "alicloud_vpn_customer_gateway" "aws" {
  count       = length(var.tunnels)
  name        = "aws-${var.name}-${count.index}"
  ip_address  = element(var.tunnels, count.index)["outside_ip"]
  description = "${var.name} AWS"
}

resource "alicloud_vpn_connection" "aws" {
  count               = length(var.tunnels)
  name                = "aws-${var.name}-${count.index}"
  vpn_gateway_id      = alicloud_vpn_gateway.aws.id
  customer_gateway_id = element(alicloud_vpn_customer_gateway.aws.*.id, count.index)
  local_subnet        = var.alicloud_subnets
  remote_subnet       = var.aws_subnets
  effect_immediately  = true

  ike_config {
    ike_auth_alg  = "sha1"
    ike_enc_alg   = "aes"
    ike_version   = element(var.tunnels, count.index)["ike_version"]
    ike_mode      = "main"
    ike_lifetime  = 28800
    psk           = element(var.tunnels, count.index)["private_shared_key"]
    ike_pfs       = "group2"
    ike_remote_id = element(var.tunnels, count.index)["remote_id"]
    ike_local_id  = alicloud_vpn_gateway.aws.id
  }

  ipsec_config {
    ipsec_pfs      = "group2"
    ipsec_enc_alg  = "aes"
    ipsec_auth_alg = "sha1"
    ipsec_lifetime = 3600
  }
}

resource "alicloud_route_entry" "route_entries" {
  count = length(var.aws_subnets)
  name  = "aws-route-${count.index}"

  route_table_id = data.terraform_remote_state.vpc.outputs.route_table
  nexthop_type   = "VpnGateway"
  nexthop_id     = alicloud_vpn_gateway.aws.id

  destination_cidrblock = element(var.aws_subnets, count.index)
}

# ---------------------------------------------------------------------------------------------------------------------
# State References
# ---------------------------------------------------------------------------------------------------------------------

data "terraform_remote_state" "vpc" {
  backend = "oss"

  config = {
    prefix = "${var.region}/${var.environment}/vpc"
    key    = "terraform.tfstate"
    bucket = var.bucket
    region = var.region
  }
}
