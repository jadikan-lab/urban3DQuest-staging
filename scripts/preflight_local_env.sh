#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "[preflight] checking supabase CLI"
if ! command -v supabase >/dev/null 2>&1; then
  echo "[preflight][ERROR] supabase CLI not found"
  exit 1
fi
supabase --version >/dev/null

echo "[preflight] checking CLI authentication"
if ! supabase projects list >/dev/null 2>&1; then
  echo "[preflight][ERROR] Supabase CLI is not authenticated"
  echo "[preflight][HINT] run: supabase login --no-browser"
  exit 1
fi

echo "[preflight] checking linked project guard"
"$ROOT_DIR/scripts/guard_staging_project.sh" >/dev/null

echo "[preflight] OK"
