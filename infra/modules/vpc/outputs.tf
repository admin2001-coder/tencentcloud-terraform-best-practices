output "vpc_id" { value = tencentcloud_vpc.this.id }
output "subnet_ids" { value = { for k, s in tencentcloud_subnet.this : k => s.id } }
