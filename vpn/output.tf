output "aws_customer_gateway" {
  value = alicloud_vpn_gateway.aws.internet_ip
}