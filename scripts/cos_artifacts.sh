#!/usr/bin/env bash
set -euo pipefail

# cos_artifacts.sh
#
# Purpose:
#   Upload/download Terraform plan + logs to/from Tencent COS using coscli.
#
# Dev/Test mode (no bucket required):
#   If DEV_MODE=1 (or CI_MOCK=1), operations are performed on the local filesystem
#   under $DEV_ARTIFACTS_DIR, mirroring COS paths. This is for CI lint/tests.
#
# Requirements (real COS mode):
#   - coscli installed in the runner/agent
#   - Env vars for auth (recommended):
#       COS_SECRET_ID
#       COS_SECRET_KEY
#     Optional (if your coscli requires):
#       COS_SESSION_TOKEN
#
#   - Env vars for target bucket/path:
#       COS_BUCKET        e.g. my-bucket-123456
#       COS_REGION        e.g. ap-singapore
#       COS_PREFIX        e.g. terraform-artifacts
#       ENV_NAME          e.g. dev/staging/prod
#       STACK_NAME        e.g. network/tke

usage() {
  cat <<'EOF'
Usage:
  scripts/cos_artifacts.sh <upload|download> <local_path> <artifact_name>

Env vars (common):
  ENV_NAME, STACK_NAME, COS_PREFIX

Real COS mode env vars:
  COS_BUCKET, COS_REGION

Dev/Test mode (no COS needed):
  DEV_MODE=1 (or CI_MOCK=1)
  DEV_ARTIFACTS_DIR  (optional; default: ./.artifacts)

Examples (real):
  ENV_NAME=dev STACK_NAME=network COS_BUCKET=xxx COS_REGION=ap-singapore COS_PREFIX=tfartifacts \
    scripts/cos_artifacts.sh upload /tmp/tfplan.bin tfplan.bin

Examples (dev/test):
  DEV_MODE=1 ENV_NAME=dev STACK_NAME=network COS_PREFIX=tfartifacts \
    scripts/cos_artifacts.sh upload /tmp/tfplan.bin tfplan.bin
EOF
}

require_env() {
  local name="$1"
  if [[ -z "${!name:-}" ]]; then
    echo "Missing required env var: ${name}" >&2
    exit 2
  fi
}

is_dev_mode() {
  [[ "${DEV_MODE:-}" == "1" || "${CI_MOCK:-}" == "1" || "${DEV_MODE:-}" == "true" || "${CI_MOCK:-}" == "true" ]]
}

cos_key_for() {
  local artifact_name="$1"
  echo "${COS_PREFIX}/${ENV_NAME}/${STACK_NAME}/${artifact_name}"
}

cos_uri_for() {
  local artifact_name="$1"
  echo "cos://${COS_BUCKET}/$(cos_key_for "${artifact_name}")"
}

local_mock_path_for() {
  local artifact_name="$1"
  local base="${DEV_ARTIFACTS_DIR:-.artifacts}"
  echo "${base}/$(cos_key_for "${artifact_name}")"
}

ensure_coscli_config() {
  # Intentionally no-op: setup varies by coscli version.
  # If your coscli needs explicit config, add it here (without persisting secrets).
  :
}

main() {
  if [[ $# -ne 3 ]]; then
    usage
    exit 2
  fi

  local action="$1"
  local local_path="$2"
  local artifact_name="$3"

  require_env COS_PREFIX
  require_env ENV_NAME
  require_env STACK_NAME

  if is_dev_mode; then
    local mock_path
    mock_path="$(local_mock_path_for "${artifact_name}")"
    mkdir -p "$(dirname "${mock_path}")"

    case "${action}" in
      upload)
        [[ -f "${local_path}" ]] || { echo "Local file not found: ${local_path}" >&2; exit 2; }
        echo "[DEV_MODE] Storing ${local_path} -> ${mock_path}"
        cp -f "${local_path}" "${mock_path}"
        ;;
      download)
        [[ -f "${mock_path}" ]] || { echo "[DEV_MODE] Mock artifact not found: ${mock_path}" >&2; exit 3; }
        mkdir -p "$(dirname "${local_path}")"
        echo "[DEV_MODE] Restoring ${mock_path} -> ${local_path}"
        cp -f "${mock_path}" "${local_path}"
        ;;
      *)
        usage
        exit 2
        ;;
    esac

    exit 0
  fi

  # Real COS mode
  require_env COS_BUCKET
  require_env COS_REGION

  ensure_coscli_config

  local uri
  uri="$(cos_uri_for "${artifact_name}")"

  case "${action}" in
    upload)
      [[ -f "${local_path}" ]] || { echo "Local file not found: ${local_path}" >&2; exit 2; }
      echo "Uploading ${local_path} -> ${uri}"
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
