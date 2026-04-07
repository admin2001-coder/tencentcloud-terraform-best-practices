variable "name_prefix" { type = string }
variable "tags" { type = map(string) }

variable "vpc_id" {
  type        = string
  description = "VPC for the cluster"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets for worker nodes"
}

variable "cluster_name" {
  type = string
}
