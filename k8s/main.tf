# ---------------------------------------------------------------------------------------------------------------------
# Netorking
# ---------------------------------------------------------------------------------------------------------------------

data "alicloud_zones" "default" {
  available_resource_creation = "VSwitch"
}

resource "alicloud_vswitch" "vswitches" {
  count             = length(data.alicloud_zones.default.zones)
  name              = "quid-${var.environment}-worker-${count.index}"
  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block        = element(var.k8s_node_cidrs, count.index)
  availability_zone = element(data.alicloud_zones.default.zones, count.index).id

  tags = {
    environment = var.environment
    stack       = "kubernetes"
    k8s_cluster = "quid-${var.environment}"
  }
}

resource "alicloud_vswitch" "terway_vswitches" {
  count             = length(data.alicloud_zones.default.zones)
  name              = "quid-${var.environment}-pod-terway-${count.index}"
  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block        = element(var.terway_pod_cidrs, count.index)
  availability_zone = element(data.alicloud_zones.default.zones, count.index).id

  tags = {
    environment = var.environment
    stack       = "kubernetes"
    k8s_cluster = "quid-${var.environment}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Kubernetes Cluster
# ---------------------------------------------------------------------------------------------------------------------

resource "alicloud_cs_managed_kubernetes" "k8s" {
  name     = "quid-${var.environment}"
  key_name = var.keypair_name
  version  = var.k8s_version

  worker_vswitch_ids = alicloud_vswitch.vswitches.*.id
  pod_vswitch_ids    = alicloud_vswitch.terway_vswitches.*.id

  worker_instance_types = var.worker_instance_types
  worker_number         = 3

  service_cidr = var.k8s_service_cidrs

  dynamic "addons" {
    for_each = var.cluster_addons
    content {
      name   = lookup(addons.value, "name", var.cluster_addons)
      config = lookup(addons.value, "config", var.cluster_addons)
    }
  }
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
