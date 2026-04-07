# VPC CIDR plan (realistic sizing)

This doc shows **workload-driven** CIDR allocations you can actually run.

## Model workload: "3-tier app + TKE"
Assumptions (adjust to your reality):
- 3 AZs
- ~150 application nodes total (autoscaling)
- If using VPC-CNI: pods consume VPC IPs; plan for peak pod IP usage
- DB tier uses managed DB or dedicated subnets

### Recommended baseline: /16 VPC (65,536 IPs)
Use a /16 for "main" prod VPC unless you are absolutely sure you will stay small.
Example VPC: `10.20.0.0/16`

#### Subnet allocation (per AZ)
We split by function (public, app, db) and by AZ for blast-radius control.

| Tier | Per-AZ subnet | Size | IPs (approx) | Notes |
|------|---------------|------|--------------|------|
| Public | 10.20.0.0/22 etc | /22 | 1024 | NAT/egress/LB/ingress nodes |
| App (TKE nodes + services) | 10.20.16.0/20 etc | /20 | 4096 | Node ENIs / services / headroom |
| DB | 10.20.64.0/24 etc | /24 | 256 | Private DB endpoints only |

##### Example concrete map
- Public AZ1: `10.20.0.0/22`
- Public AZ2: `10.20.4.0/22`
- Public AZ3: `10.20.8.0/22`

- App AZ1: `10.20.16.0/20`
- App AZ2: `10.20.32.0/20`
- App AZ3: `10.20.48.0/20`

- DB AZ1: `10.20.64.0/24`
- DB AZ2: `10.20.65.0/24`
- DB AZ3: `10.20.66.0/24`

### Why these sizes?
- /20 per AZ for app gives room for:
  - node primary ENIs + secondary IPs (CNI dependent)
  - service VIPs / internal LBs if used
  - bursts during rollouts

If you’re using **VPC-CNI**, validate your max pods-per-node and how many VPC IPs are reserved per node.

## Smaller workload: /18 VPC
If you are very sure you’ll stay < ~10k IPs total, you can use `/18` (16,384 IPs), but leave room for growth.

## Anti-patterns
- One giant /20 subnet for everything (hard to secure)
- Using /24 for TKE app subnet while running VPC-CNI (you will run out)
