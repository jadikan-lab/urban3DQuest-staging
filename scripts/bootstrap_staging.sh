#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "[bootstrap] applying base schema"
supabase db query --linked -f setup.sql

echo "[bootstrap] applying secure RLS baseline"
supabase db query --linked -f setup_secure_rls.sql

echo "[bootstrap] applying minimal seed"
supabase db query --linked -f seed_staging_minimal.sql

echo "[bootstrap] running healthcheck"
"$ROOT_DIR/scripts/healthcheck_staging.sh"

echo "[bootstrap] done"
