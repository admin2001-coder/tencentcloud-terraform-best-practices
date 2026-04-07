resource "tencentcloud_vpc" "this" {
  name       = var.name
  cidr_block = var.cidr
  tags       = var.tags
}

resource "tencentcloud_subnet" "this" {
  for_each = { for s in var.subnets : s.name => s }

  name              = each.value.name
  vpc_id            = tencentcloud_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.availability_zone
  tags              = var.tags
}
