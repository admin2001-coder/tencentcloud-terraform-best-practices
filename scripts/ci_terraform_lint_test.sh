#!/usr/bin/env bash
set -euo pipefail

# Lint + validate all Terraform stacks under infra/env/**

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v terraform >/dev/null 2>&1; then
  echo "ERROR: terraform not found in PATH"
  exit 1
fi

echo "==> terraform fmt -check -recursive"
# In CI we want a hard fail if formatting is off.
terraform fmt -check -recursive

echo "==> discovering stacks under infra/env/**"
# A 'stack' is any directory under infra/env/** that contains at least one *.tf file.
mapfile -t STACK_DIRS < <(
  find infra/env -type f -name '*.tf' -print0 \
    | xargs -0 -n1 dirname \
    | sort -u
)

if [[ ${#STACK_DIRS[@]} -eq 0 ]]; then
  echo "No Terraform stacks found under infra/env/**"
  exit 0
fi

for d in "${STACK_DIRS[@]}"; do
  echo "==> stack: $d"
  pushd "$d" >/dev/null

  # Init without backend, so we don't need remote state credentials.
  terraform init -backend=false -input=false -no-color

  terraform validate -no-color

  popd >/dev/null
done
