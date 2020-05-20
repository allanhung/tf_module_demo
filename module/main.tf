# ---------------------------------------------------------------------------------------------------------------------
# VPC
# ---------------------------------------------------------------------------------------------------------------------

resource "alicloud_vpc" "vpc" {
  name       = var.environment
  cidr_block = var.vpc_cidr
}

resource "alicloud_vswitch" "vswitches" {
  count      = length(var.vswitch_cidrs)
  vpc_id     = alicloud_vpc.vpc.id
  cidr_block = element(var.vswitch_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
  name = "${var.environment}-${element(var.alicloud_zones.default.zones, count.index)}"
}
