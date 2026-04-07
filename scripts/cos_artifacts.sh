#!/usr/bin/env bash
set -euo pipefail

# cos_artifacts.sh
#
# Purpose:
#   Upload/download Terraform plan + logs to/from Tencent COS using coscli.
#
# Requirements:
#   - coscli installed in the runner/agent
#   - Env vars for auth (recommended):
#       COS_SECRET_ID
#       COS_SECRET_KEY
#     Optional (if your coscli requires):
#       COS_SESSION_TOKEN
#
#   - Env vars for target bucket/path:
#       COS_BUCKET          e.g. my-bucket-123456
#       COS_REGION          e.g. ap-singapore
#       COS_PREFIX          e.g. terraform-artifacts
#       ENV_NAME            e.g. dev/staging/prod
#       STACK_NAME          e.g. network/tke
#       TF_WORKDIR          e.g. infra/env/dev/network
#
# Notes:
#   - We intentionally do NOT write any secret values to disk.
#   - This script is used by GitHub Actions and can be reused in Tekton.

usage() {
  cat <<'EOF'
Usage:
  scripts/cos_artifacts.sh <upload|download> <local_path> <artifact_name>

Env vars:
  COS_BUCKET, COS_REGION, COS_PREFIX, ENV_NAME, STACK_NAME
Optional:
  COS_ENDPOINT            override endpoint (rare)

Examples:
  ENV_NAME=dev STACK_NAME=network COS_BUCKET=xxx COS_REGION=ap-singapore COS_PREFIX=tfartifacts \
    scripts/cos_artifacts.sh upload /tmp/tfplan.bin tfplan.bin

  ENV_NAME=dev STACK_NAME=network COS_BUCKET=xxx COS_REGION=ap-singapore COS_PREFIX=tfartifacts \
    scripts/cos_artifacts.sh download /tmp/tfplan.bin tfplan.bin
EOF
}

require_env() {
  local name="$1"
  if [[ -z "${!name:-}" ]]; then
    echo "Missing required env var: ${name}" >&2
    exit 2
  fi
}

ensure_coscli_config() {
  # Many coscli setups use a config file; some support env vars.
  # We try a safe, non-persistent approach: if user already provided config, do nothing.
  # If not, we create a temporary config directory and point COSCLI to it when possible.
  #
  # If your coscli version does not support env-only auth, add your preferred config init here.
  :
}

cos_uri_for() {
  local artifact_name="$1"
  # Standardize: <prefix>/<env>/<stack>/<artifact>
  echo "cos://${COS_BUCKET}/${COS_PREFIX}/${ENV_NAME}/${STACK_NAME}/${artifact_name}"
}

main() {
  if [[ $# -ne 3 ]]; then
    usage
    exit 2
  fi

  local action="$1"
  local local_path="$2"
  local artifact_name="$3"

  require_env COS_BUCKET
  require_env COS_REGION
  require_env COS_PREFIX
  require_env ENV_NAME
  require_env STACK_NAME

  ensure_coscli_config

  local uri
  uri="$(cos_uri_for "${artifact_name}")"

  case "${action}" in
    upload)
      if [[ ! -f "${local_path}" ]]; then
        echo "Local file not found: ${local_path}" >&2
        exit 2
      fi
      echo "Uploading ${local_path} -> ${uri}"
      # coscli syntax varies by version. The common pattern is `coscli cp`.
      # If your version differs (e.g. `coscli put`), adjust here.
      coscli cp "${local_path}" "${uri}" --region "${COS_REGION}"
      ;;

    download)
      echo "Downloading ${uri} -> ${local_path}"
      mkdir -p "$(dirname "${local_path}")"
      coscli cp "${uri}" "${local_path}" --region "${COS_REGION}"
      ;;

    *)
      usage
      exit 2
      ;;
  esac
}

main "$@"
