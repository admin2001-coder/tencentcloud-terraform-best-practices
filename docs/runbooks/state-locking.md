# COS state locking runbook

Terraform COS backend uses a lock file next to the state (e.g., `terraform.tfstate.tflock`).

## Symptoms
- Apply/plan fails due to lock held

## Checks
1) Confirm no other pipeline/apply is currently running.
2) Inspect lock age and owner metadata (if available).

## Break-glass
- Only if you are sure no other apply is running.
- Prefer `terraform force-unlock <LOCK_ID>`.

Keep COS bucket versioning enabled so state can be recovered.
