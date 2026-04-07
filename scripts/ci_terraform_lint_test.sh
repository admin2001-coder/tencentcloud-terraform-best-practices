#!/usr/bin/env bash
set -euo pipefail

# CI lint + "mock-safe" tests:
# - terraform fmt -check -recursive
# - terraform init -backend=false (downloads providers, no backend)
# - terraform validate

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

if ! command -v terraform >/dev/null 2>&1; then
  echo "terraform not found in PATH" >&2
  exit 127
fi

echo "==> terraform fmt -check -recursive"
terraform fmt -check -recursive

echo "==> discovering stacks under infra/env/**"
mapfile -t STACK_DIRS < <(find infra/env -type f -name "*.tf" -print0 | xargs -0 -n1 dirname | sort -u)

if [[ ${#STACK_DIRS[@]} -eq 0 ]]; then
  echo "No stacks found under infra/env" >&2
  exit 0
fi

overall_rc=0
for d in "${STACK_DIRS[@]}"; do
  echo "==> stack: ${d}"
  pushd "${d}" >/dev/null

  # Avoid pulling remote state / requiring credentials
  terraform init -backend=false -input=false -no-color >/dev/null

  # Validate should not require provider credentials.
  if ! terraform validate -no-color; then
    overall_rc=1
  fi

  popd >/dev/null
  echo
 done

exit "${overall_rc}"
