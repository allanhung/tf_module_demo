# ---------------------------------------------------------------------------------------------------------------------
# VPC
# ---------------------------------------------------------------------------------------------------------------------

resource "alicloud_vpc" "vpc" {
  name       = var.environment
  cidr_block = var.cidr_block
}

resource "alicloud_vswitch" "vswitches" {
  count      = length(data.alicloud_zones.default.zones)
  vpc_id     = alicloud_vpc.vpc.id
  cidr_block = element(var.vswitch_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
  name = "${var.environment}-${element(data.alicloud_zones.default.zones, count.index)}"
}
