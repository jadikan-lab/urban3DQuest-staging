#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "[ops] 1/3 environment separation"
"$ROOT_DIR/scripts/check_env_separation.sh"

echo "[ops] 2/3 full smoke"
"$ROOT_DIR/scripts/full_smoke_staging.sh"

echo "[ops] 3/3 pre-release gate"
"$ROOT_DIR/scripts/pre_release_check_staging.sh"

echo "[ops] ALL CHECKS PASSED"
