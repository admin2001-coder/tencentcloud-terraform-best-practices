module "naming" {
  source = "../../../modules/naming"
}

module "tke-overlay" {
  source = "../../../modules/tke-overlay"

  cluster_id = "cls-xxxx"
}
