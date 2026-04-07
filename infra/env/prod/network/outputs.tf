output "vpc_id" { value = module.vpc.vpc_id }
output "subnet_ids" { value = module.vpc.subnet_ids }
output "sg" {
  value = {
    lb  = module.security_groups.lb_sg_id
    app = module.security_groups.app_sg_id
    db  = module.security_groups.db_sg_id
  }
}
