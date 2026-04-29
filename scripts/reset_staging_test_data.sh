#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

"$ROOT_DIR/scripts/guard_staging_project.sh"

echo "[reset] removing staging test data"
supabase db query --linked -f "$ROOT_DIR/scripts/reset_staging_test_data.sql"

echo "[reset] done"
