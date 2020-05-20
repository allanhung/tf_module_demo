# ---------------------------------------------------------------------------------------------------------------------
# Key Pair
# ---------------------------------------------------------------------------------------------------------------------

data "alicloud_zones" "default" {
  available_resource_creation = "VSwitch"
}

resource "alicloud_key_pair" "default" {
  key_name = var.keypair_name
  key_file = var.keypair_name
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC
# ---------------------------------------------------------------------------------------------------------------------

resource "alicloud_vpc" "vpc" {
  name       = var.environment
  cidr_block = var.cidr_block
}

resource "alicloud_vswitch" "switches" {
  count      = length(data.alicloud_zones.default.zones)
  vpc_id     = alicloud_vpc.vpc.id
  cidr_block = element(var.vswitch_cidr_blocks, count.index)

  availability_zone = element(data.alicloud_zones.default.zones, count.index).id

  name = "${var.environment}-${element(data.alicloud_zones.default.zones, count.index).id}"
}

resource "alicloud_nat_gateway" "default" {
  vpc_id = alicloud_vpc.vpc.id
  name   = var.environment
}

resource "alicloud_eip" "default" {
  count = length(data.alicloud_zones.default.zones)
  name  = var.environment

  bandwidth = var.bandwidth
}

resource "alicloud_eip_association" "default" {
  count         = length(data.alicloud_zones.default.zones)
  allocation_id = element(alicloud_eip.default.*.id, count.index)
  instance_id   = alicloud_nat_gateway.default.id
}

resource "alicloud_common_bandwidth_package" "default" {
  name                 = "tf_cbp"
  bandwidth            = var.bandwidth
  internet_charge_type = "PayByTraffic"
  ratio                = 100
}

resource "alicloud_common_bandwidth_package_attachment" "default" {
  count                = length(data.alicloud_zones.default.zones)
  bandwidth_package_id = alicloud_common_bandwidth_package.default.id
  instance_id          = element(alicloud_eip.default.*.id, count.index)
}

resource "alicloud_snat_entry" "default" {
  depends_on        = [alicloud_eip_association.default]
  snat_table_id     = alicloud_nat_gateway.default.snat_table_ids
  source_vswitch_id = alicloud_vswitch.switches.0.id
  snat_ip           = join(",", alicloud_eip.default.*.ip_address)
}
