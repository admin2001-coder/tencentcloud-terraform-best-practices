# module: tke

A minimal, best-practices-oriented TKE module scaffold.

This module is intentionally conservative: it provides a place to put cluster + node pool resources, but does not try to guess your org's CNI/network mode.

## Inputs
- `vpc_id`
- `subnet_ids`
- `cluster_name`

## Outputs
- `cluster_id`
