#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

ADMIN_URL="https://jadikan-lab.github.io/urban3DQuest-staging/admin.html"
PLAYER_URL="https://jadikan-lab.github.io/urban3DQuest-staging/"
ADMIN_PASSWORD="Urban2026!"

echo "[prepare-v1] step 1: preflight"
"$ROOT_DIR/scripts/preflight_local_env.sh"

echo "[prepare-v1] step 2: reset + reseed"
"$ROOT_DIR/scripts/reset_staging_test_data.sh"
supabase db query --linked -f "$ROOT_DIR/seed_staging_minimal.sql"

echo "[prepare-v1] step 3: operational checks"
"$ROOT_DIR/scripts/run_all_ops_checks.sh"

echo "[prepare-v1] step 4: release candidate gate"
"$ROOT_DIR/scripts/release_candidate_staging.sh" >/tmp/urban3dq_rc_v1.log

echo
echo "========== ONLINE TEST V1 READY =========="
echo "ADMIN_URL=$ADMIN_URL"
echo "PLAYER_URL=$PLAYER_URL"
echo "ADMIN_PASSWORD=$ADMIN_PASSWORD"
echo "TEST_FIXED_ID=STG-FIX-001"
echo "TEST_UNIQUE_ID=STG-UNI-001"
echo "QUEST=STAGING_DEMO"
echo "RC_RESULT=$(grep 'RC_STATUS=' /tmp/urban3dq_rc_v1.log | tail -n1 | cut -d= -f2-)"
echo "=========================================="

