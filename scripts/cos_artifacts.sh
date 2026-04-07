#!/usr/bin/env bash
set -euo pipefail

# COS artifact helper (template)
#
# This repo does NOT assume a specific COS CLI is installed.
# Implement one of the options below:
# - coscli (Tencent COSCLI)
# - s3-compatible CLI if your COS endpoint is configured
#
# Usage examples (to implement):
#   ./scripts/cos_artifacts.sh upload-plan  <bucket> <key_prefix> tfplan.out plan.txt
#   ./scripts/cos_artifacts.sh upload-logs  <bucket> <key_prefix> apply.log
#   ./scripts/cos_artifacts.sh download-plan <bucket> <key_prefix> tfplan.out

cmd=${1:-""}
shift || true

echo "cos_artifacts.sh: TODO implement for your COS tooling" >&2
echo "command was: $cmd" >&2
exit 2
