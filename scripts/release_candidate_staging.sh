#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

TS="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
STATUS="PASS"
ERROR_STEP=""

run_step() {
  local step="$1"
  shift
  echo "[rc] step=$step status=START"
  if "$@"; then
    echo "[rc] step=$step status=PASS"
  else
    STATUS="FAIL"
    ERROR_STEP="$step"
    echo "[rc] step=$step status=FAIL"
    return 1
  fi
}

if ! run_step preflight "$ROOT_DIR/scripts/preflight_local_env.sh"; then
  :
elif ! run_step quick_checks "$ROOT_DIR/scripts/runbook_staging_ops.sh" quick-checks; then
  :
elif ! run_step full_checks "$ROOT_DIR/scripts/runbook_staging_ops.sh" full-checks; then
  :
fi

if [[ "$STATUS" == "PASS" ]]; then
  echo "RC_STATUS=PASS"
  echo "RC_TIMESTAMP=$TS"
  echo "RC_ERROR_STEP="
  echo '{"rc_status":"PASS","rc_timestamp":"'"$TS"'","rc_error_step":""}'
  exit 0
fi

echo "RC_STATUS=FAIL"
echo "RC_TIMESTAMP=$TS"
echo "RC_ERROR_STEP=$ERROR_STEP"
echo '{"rc_status":"FAIL","rc_timestamp":"'"$TS"'","rc_error_step":"'"$ERROR_STEP"'"}'
exit 1
