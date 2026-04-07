resource "tencentcloud_security_group" "lb" {
  name        = "${var.name_prefix}-lb-sg"
  description = "LB security group"
  project_id  = 0
  tags        = var.tags
}

resource "tencentcloud_security_group" "app" {
  name        = "${var.name_prefix}-app-sg"
  description = "App security group"
  project_id  = 0
  tags        = var.tags
}

resource "tencentcloud_security_group" "db" {
  name        = "${var.name_prefix}-db-sg"
  description = "DB security group"
  project_id  = 0
  tags        = var.tags
}

# Allow HTTP/HTTPS to LB
resource "tencentcloud_security_group_rule" "lb_in_http" {
  security_group_id = tencentcloud_security_group.lb.id
  type              = "ingress"
  ip_protocol       = "TCP"
  cidr_ip           = "0.0.0.0/0"
  port_range        = "80"
  policy            = "ACCEPT"
}

resource "tencentcloud_security_group_rule" "lb_in_https" {
  security_group_id = tencentcloud_security_group.lb.id
  type              = "ingress"
  ip_protocol       = "TCP"
  cidr_ip           = "0.0.0.0/0"
  port_range        = "443"
  policy            = "ACCEPT"
}

# Allow LB -> App
resource "tencentcloud_security_group_rule" "app_in_from_lb" {
  security_group_id = tencentcloud_security_group.app.id
  type              = "ingress"
  ip_protocol       = "TCP"
  source_security_group_id = tencentcloud_security_group.lb.id
  port_range        = "30000-32767" # example: NodePort range; adjust if using CLB->Ingress
  policy            = "ACCEPT"
}

# Allow App -> DB (example 3306)
resource "tencentcloud_security_group_rule" "db_in_from_app" {
  security_group_id = tencentcloud_security_group.db.id
  type              = "ingress"
  ip_protocol       = "TCP"
  source_security_group_id = tencentcloud_security_group.app.id
  port_range        = "3306"
  policy            = "ACCEPT"
}
