# NOTE: This module is a scaffold.
# TKE resources differ depending on your chosen networking mode.
# Fill in tencentcloud_kubernetes_cluster + node pools as desired.

# Placeholder output to keep examples runnable without creating resources.
locals {
  cluster_id = "example-${var.network_mode}"
}
