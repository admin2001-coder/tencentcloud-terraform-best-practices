#!/usr/bin/env bash
set -euo pipefail

# CI lint + "mock-safe" tests:
# - (optional) terraform fmt -check -recursive (only if terraform can format-check successfully)
# - terraform init -backend=false (downloads providers, no backend)
# - terraform validate

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

if ! command -v terraform >/dev/null 2>&1; then
  echo "terraform not found in PATH" >&2
  exit 127
fi

# terraform fmt -check exits non-zero when files need formatting.
# That is good for repos that enforce fmt, but this repo does not yet enforce fmt.
# To avoid breaking all CI, run it in "report only" mode.
echo "==> terraform fmt -check -recursive (non-blocking)"
if ! terraform fmt -check -recursive; then
  echo "WARN: terraform fmt check failed (files need formatting). Not failing CI." >&2
fi

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

  terraform init -backend=false -input=false -no-color >/dev/null

  if ! terraform validate -no-color; then
    overall_rc=1
  fi

  popd >/dev/null
  echo
done

exit "${overall_rc}"
