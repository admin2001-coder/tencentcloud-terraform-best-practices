variable "region" {
  type    = string
  default = "ap-singapore"
}

variable "name_prefix" {
  type    = string
  default = "dev"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID from the network stack"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for nodes (and possibly pods if using VPC-CNI)"
}

variable "tags" {
  type    = map(string)
  default = {
    env = "dev"
  }
}
