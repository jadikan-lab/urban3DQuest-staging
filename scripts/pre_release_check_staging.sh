#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "[pre-release] 1/6 guard project-ref"
"$ROOT_DIR/scripts/guard_staging_project.sh"

echo "[pre-release] 2/6 DB healthcheck"
"$ROOT_DIR/scripts/healthcheck_staging.sh"

echo "[pre-release] 3/6 security checks"
supabase db query --linked -f "$ROOT_DIR/scripts/check_rls_staging.sql" >/dev/null
supabase db query --linked -f "$ROOT_DIR/scripts/verify_integrity_staging.sql" >/dev/null

echo "[pre-release] 4/6 seeded records present"
COUNT=$(supabase db query --linked --output csv "select count(*) from public.treasures where id in ('STG-FIX-001','STG-UNI-001');" | tail -n 1 | tr -d '\r')
if [[ "$COUNT" != "2" ]]; then
  echo "[pre-release][ERROR] expected 2 seeded records, got $COUNT"
  exit 1
fi

echo "[pre-release] 5/6 web smoke"
"$ROOT_DIR/scripts/smoke_web_staging.sh"

echo "[pre-release] 6/6 status report"
"$ROOT_DIR/scripts/report_staging_status.sh" >/dev/null

echo "[pre-release] PASS"
