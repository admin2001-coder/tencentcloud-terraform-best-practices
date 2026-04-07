locals {
  prefix = "${var.org}-${var.env}-${var.app}"
  tags = {
    org = var.org
    env = var.env
    app = var.app
    managed_by = "terraform"
  }
}
