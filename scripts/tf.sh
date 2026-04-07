#!/usr/bin/env bash
set -euo pipefail

STACK=${1:-}
CMD=${2:-}

if [[ -z "$STACK" || -z "$CMD" ]]; then
  echo "usage: scripts/tf.sh <stack-path> <init|plan|apply>" >&2
  exit 2
fi

cd "$STACK"

case "$CMD" in
  init)
    terraform init -backend-config=backend.hcl
    ;;
  plan)
    terraform plan -out=tfplan.out
    terraform show -no-color tfplan.out > plan.txt
    ;;
  apply)
    terraform apply
    ;;
  *)
    echo "unknown cmd: $CMD" >&2
    exit 2
    ;;
esac
