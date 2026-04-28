#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

"$ROOT_DIR/scripts/guard_staging_project.sh"

echo "[full-smoke] reset test data"
"$ROOT_DIR/scripts/reset_staging_test_data.sh"

echo "[full-smoke] reseed minimal data"
supabase db query --linked -f "$ROOT_DIR/seed_staging_minimal.sql"

echo "[full-smoke] db healthcheck"
"$ROOT_DIR/scripts/healthcheck_staging.sh"

echo "[full-smoke] web deployment smoke"
"$ROOT_DIR/scripts/smoke_web_staging.sh"

echo "[full-smoke] done"
