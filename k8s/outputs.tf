output "k8s_cluster_name" {
  value = alicloud_cs_managed_kubernetes.k8s.name
}

output "k8s_nodes" {
  value = alicloud_cs_managed_kubernetes.k8s.worker_nodes.*.id
}
