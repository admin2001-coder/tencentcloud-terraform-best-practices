module "naming" {
  source = "../../../modules/naming"

  org = var.org
  env = var.env
  app = var.app
}

locals {
  # Example: 3-AZ mapping that matches docs/architecture/vpc-cidr-plan.md
  subnets = [
    { name = "${module.naming.prefix}-public-a", cidr = "10.20.0.0/22",  availability_zone = var.availability_zones[0] },
    { name = "${module.naming.prefix}-public-b", cidr = "10.20.4.0/22",  availability_zone = var.availability_zones[1] },
    { name = "${module.naming.prefix}-public-c", cidr = "10.20.8.0/22",  availability_zone = var.availability_zones[2] },

    { name = "${module.naming.prefix}-app-a",    cidr = "10.20.16.0/20", availability_zone = var.availability_zones[0] },
    { name = "${module.naming.prefix}-app-b",    cidr = "10.20.32.0/20", availability_zone = var.availability_zones[1] },
    { name = "${module.naming.prefix}-app-c",    cidr = "10.20.48.0/20", availability_zone = var.availability_zones[2] },

    { name = "${module.naming.prefix}-db-a",     cidr = "10.20.64.0/24", availability_zone = var.availability_zones[0] },
    { name = "${module.naming.prefix}-db-b",     cidr = "10.20.65.0/24", availability_zone = var.availability_zones[1] },
    { name = "${module.naming.prefix}-db-c",     cidr = "10.20.66.0/24", availability_zone = var.availability_zones[2] },
  ]
}

module "vpc" {
  source = "../../../modules/vpc"

  name    = "${module.naming.prefix}-vpc"
  cidr    = var.vpc_cidr
  subnets = local.subnets
  tags    = module.naming.tags
}

module "security_groups" {
  source = "../../../modules/security-groups"

  vpc_id       = module.vpc.vpc_id
  name_prefix  = module.naming.prefix
  tags         = module.naming.tags
}
