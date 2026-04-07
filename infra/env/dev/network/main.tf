module "naming" {
  source      = "../../../modules/naming"
  name_prefix = var.name_prefix
  tags        = var.tags
}

module "vpc" {
  source = "../../../modules/vpc"

  name_prefix = module.naming.name_prefix
  tags        = module.naming.tags

  vpc_cidr = "10.20.0.0/16"

  subnets = {
    public-a  = { cidr = "10.20.0.0/24",  zone = "ap-singapore-1", public = true }
    public-b  = { cidr = "10.20.1.0/24",  zone = "ap-singapore-2", public = true }
    app-a     = { cidr = "10.20.10.0/23", zone = "ap-singapore-1", public = false }
    app-b     = { cidr = "10.20.12.0/23", zone = "ap-singapore-2", public = false }
    data-a    = { cidr = "10.20.20.0/24", zone = "ap-singapore-1", public = false }
    data-b    = { cidr = "10.20.21.0/24", zone = "ap-singapore-2", public = false }
  }
}

module "security_groups" {
  source = "../../../modules/security-groups"

  name_prefix = module.naming.name_prefix
  tags        = module.naming.tags
  vpc_id      = module.vpc.vpc_id
}
