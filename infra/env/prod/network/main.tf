terraform {
  required_version = ">= 1.6.0"

  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = "~> 1.81"
    }
  }
}

module "naming" {
  source = "../../../modules/naming"

  env  = var.env
  name = var.name
}

module "vpc" {
  source = "../../../modules/vpc"

  env       = var.env
  name      = var.name
  vpc_cidr  = var.vpc_cidr
  vpc_name  = module.naming.vpc_name
  subnet_az = var.subnet_az
}
