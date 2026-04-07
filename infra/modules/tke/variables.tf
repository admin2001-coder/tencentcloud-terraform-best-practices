variable "cluster_name" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "network_mode" {
  type        = string
  description = "overlay or vpc-cni"
  validation {
    condition     = contains(["overlay", "vpc-cni"], var.network_mode)
    error_message = "network_mode must be overlay or vpc-cni"
  }
}
