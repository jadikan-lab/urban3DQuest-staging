#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

"$ROOT_DIR/scripts/guard_staging_project.sh"

mkdir -p "$ROOT_DIR/backups"
TS="$(date +%Y%m%d_%H%M%S)"
OUT_FILE="$ROOT_DIR/backups/staging_public_schema_snapshot_${TS}.csv"

echo "[snapshot] writing $OUT_FILE"
supabase db query --linked --output csv "select table_name,column_name,data_type,is_nullable,column_default from information_schema.columns where table_schema='public' order by table_name,ordinal_position;" > "$OUT_FILE"

echo "[snapshot] done"
