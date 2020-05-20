output "route_table" {
  value = alicloud_vpc.vpc.route_table_id
}

output "vpc_id" {
  value = alicloud_vpc.vpc.id
}

output "vswitch_id" {
  value = alicloud_vswitch.switches.*.id
}

output "keypair_public_key" {
  value = alicloud_key_pair.default.public_key
}
