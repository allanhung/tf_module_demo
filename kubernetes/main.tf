resource "alicloud_cs_managed_kubernetes" "kubernetes" {
  name_prefix = "prod-spark"
  worker_vswitch_ids = var.vpc.vswitches.*.id
  worker_instance_types = var.worker_instance_types
  worker_number = var.worker_number
  worker_disk_category  = "cloud_efficiency"
  worker_disk_size =  120
  key_name = var.keypair_name
  pod_cidr = var.pod_cidr
  service_cidr = var.service_cidr
  nat_gateway_id = var.vpc.nat.id
  install_cloud_monitor = false
  slb_internet_enabled = false
  proxy_mode = "ipvs"
  version = "1.16.6-aliyun.1"

  dynamic "addons" {
    for_each = var.cluster_addons
    content {
    name          = lookup(addons.value, "name", var.cluster_addons)
    config          = lookup(addons.value, "config", var.cluster_addons)
    }
  }
}

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
    bucket = var.bucket_name
    region = var.region
  }
}
