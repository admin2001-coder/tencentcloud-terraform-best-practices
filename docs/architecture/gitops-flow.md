# GitOps flow (GitHub Actions + Tekton)

## Principle
- PR = plan (no writes to prod)
- Merge/dispatch = apply (controlled identity, locking enabled)

## Option A: GitHub Actions apply
- Use environment protection rules for prod.

## Option B: Tekton apply inside cluster
- GitHub Actions produces a signed/traceable plan artifact (optional)
- Tekton pulls the plan and runs apply with cluster-side network and policy controls

## COS artifacts convention
- `cos://tfartifacts-<org>-<env>-<acct>/plans/<repo>/<env>/<sha>/tfplan.out`
- `cos://tfartifacts-<org>-<env>-<acct>/logs/<repo>/<env>/<sha>/apply.log`

> Exact COS upload/download commands depend on your COS CLI tooling.
