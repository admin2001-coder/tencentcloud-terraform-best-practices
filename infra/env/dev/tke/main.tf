module "naming" {
  source      = "../../../modules/naming"
  name_prefix = var.name_prefix
  tags        = var.tags
}

module "tke" {
  source = "../../../modules/tke"

  name_prefix = module.naming.name_prefix
  tags        = module.naming.tags

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # These are intentionally generic; tune to your org.
  cluster_name = "${module.naming.name_prefix}-tke"
}
