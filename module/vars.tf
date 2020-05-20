variable "environment" {
  description = "Environment name"
}

variable "worker_instance_types" {
  description = "Kubernetes Agents type"
  type        = list(string)
}

variable "k8s_version" {
  description = "Kubernetes Version for Aliyun"
  default     = "1.16.6-aliyun.1"
}

# ---------------------------------------------------------------------------------------------------------------------
# Networking
# ---------------------------------------------------------------------------------------------------------------------

variable "k8s_node_cidrs" {
  description = "Kubernetes Node CIDRs"
  type        = list(string)
}

variable "k8s_service_cidrs" {
  description = "Kubernetes Service CIDRs"
}

variable "terway_pod_cidrs" {
  description = "Kubernetes Pod CIDRs"
  type        = list(string)
}

# ---------------------------------------------------------------------------------------------------------------------
# Autoscaling
# https://github.com/terraform-providers/terraform-provider-alicloud/tree/master/examples/cluster-autoscaler
# ---------------------------------------------------------------------------------------------------------------------

variable "autoscaling" {
  description = "Cluster Autoscaling Parameters"
  type        = map(string)
  default = {
    utilization             = "0.8"
    cool_down_duration      = "600"
    defer_scale_in_duration = "600"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Addons
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_addons" {
  description = "Addon components in kubernetes cluster"

  type = list(object({
    name   = string
    config = string
  }))

  default = [
    {
      name   = "flannel",
      config = "",
    },
    {
      name   = "flexvolume",
      config = "",
    },
    {
      name   = "alicloud-disk-controller",
      config = "",
    },
    {
      name   = "logtail-ds",
      config = "{\"IngressDashboardEnabled\":\"true\"}",
    },
    {
      name   = "nginx-ingress-controller",
      config = "{\"IngressSlbNetworkType\":\"internet\"}",
    },
  ]
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

variable "terraform_relative_vpc_state_path" {
  description = "Relative path for VPC Path"
}

variable "terraform_relative_shared_vpc_state_path" {
  description = "Relative path for Shared VPC Path"
}

variable "keypair_name" {
  description = "Regional Key Pair Name"
}
