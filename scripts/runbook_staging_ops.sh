#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

usage() {
  cat <<'EOF'
Usage: scripts/runbook_staging_ops.sh <command> [args]

Commands:
  quick-checks
    Run fast checks only (preflight + env separation + guard).

  full-checks
    Run full operational chain (all checks + smoke + pre-release).

  reset-reseed
    Reset staging test data then reseed minimal dataset.

  status
    Print complete staging status report.

  safe-link <db_password>
    Link local repo to staging project ref safely and validate guard.
EOF
}

cmd="${1:-}"

case "$cmd" in
  quick-checks)
    "$ROOT_DIR/scripts/preflight_local_env.sh"
    "$ROOT_DIR/scripts/check_env_separation.sh"
    "$ROOT_DIR/scripts/guard_staging_project.sh"
    "$ROOT_DIR/scripts/verify_strict_mode.sh"
    ;;
  full-checks)
    "$ROOT_DIR/scripts/run_all_ops_checks.sh"
    ;;
  reset-reseed)
    "$ROOT_DIR/scripts/reset_staging_test_data.sh"
    supabase db query --linked -f "$ROOT_DIR/seed_staging_minimal.sql"
    ;;
  status)
    "$ROOT_DIR/scripts/report_staging_status.sh"
    ;;
  safe-link)
    if [[ $# -ne 2 ]]; then
      echo "[runbook][ERROR] safe-link requires db_password"
      usage
      exit 1
    fi
    "$ROOT_DIR/scripts/safe_link_staging.sh" "$2"
    ;;
  *)
    usage
    exit 1
    ;;
esac

echo "[runbook] done: $cmd"
