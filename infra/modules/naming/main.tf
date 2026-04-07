locals {
  vpc_name = "${var.name}-${var.env}-vpc"
}

output "vpc_name" {
  value = local.vpc_name
}
