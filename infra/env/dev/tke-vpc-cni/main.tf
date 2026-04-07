module "naming" {
  source = "../../../modules/naming"
}

module "tke-vpc-cni" {
  source = "../../../modules/tke-vpc-cni"

  cluster_id = "cls-xxxx"
}
