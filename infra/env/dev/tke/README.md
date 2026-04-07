# Dev / TKE stack

Path: `infra/env/dev/tke`

This stack is a **starter skeleton** for provisioning a TKE cluster and node pool(s).

You must decide networking mode:
- Overlay (pods get cluster CIDR)
- VPC-CNI (pods consume VPC subnet IPs) — impacts subnet sizing

This repo leaves the final choice to you; see `docs/architecture/vpc-cidr-plan.md`.
