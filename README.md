# Tencent Cloud Terraform Best Practices (with GitOps)

Public template repo with:
- Terraform provider + COS remote state + locking conventions
- Realistic VPC/CIDR sizing examples
- Environment/stack layout (`infra/env/<env>/<stack>`)
- GitOps-native workflows: GitHub Actions (plan/apply split) + Tekton pipeline skeleton

## Repository layout

```
infra/
  modules/                 # reusable modules
  env/
    dev/
    staging/
    prod/
      network/             # VPC + subnets + SG baseline
      tke/                 # (example) cluster wiring placeholder

gitops/
  github-actions/          # workflow sources
  tekton/                  # tasks/pipelines/RBAC

docs/
  architecture/            # CIDR plan + design notes
  runbooks/                # locking/drift/breakglass

scripts/                   # wrappers
```

## Quick start (local)

1) Choose a stack, e.g. `infra/env/dev/network`
2) Copy vars:

```bash
cp terraform.tfvars.example terraform.tfvars
```

3) Create `backend.hcl` (or edit the example) and init:

```bash
terraform init -backend-config=backend.hcl
terraform plan
```

> Credentials: use environment variables in your shell/CI. Do not hardcode secrets in HCL.

## Stacks

### `network`
Creates:
- VPC
- 3x public subnets (one per AZ)
- 3x private-app subnets
- 3x private-db subnets
- example Security Groups

CIDR sizing guidance: see `docs/architecture/vpc-cidr-plan.md`.

## GitOps

- GitHub Actions runs fmt/validate + plan on PR.
- Apply is a separate workflow (manual approval) and can be executed by Tekton inside your cluster.

See `docs/architecture/gitops-flow.md`.
