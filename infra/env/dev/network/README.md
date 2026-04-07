# Dev / Network stack

Path: `infra/env/dev/network`

This stack provisions dev networking (VPC + subnets + example security groups) using the shared modules under `infra/modules/*`.

## Conventions
- Remote state: COS backend (`backend.hcl`)
- Vars: `terraform.tfvars` (not committed) from `terraform.tfvars.example`

## Quick start
```bash
terraform init -backend-config=backend.hcl
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```
