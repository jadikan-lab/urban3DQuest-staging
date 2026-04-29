#!/usr/bin/env bash
set -euo pipefail

PROD_DIR="/Users/guilhemnicolas/Documents/PlatformIO/Projects/urban3DQuest"
STG_DIR="/Users/guilhemnicolas/Documents/PlatformIO/Projects/urban3DQuest-staging"

extract_ref() {
  local file="$1"
  grep -E "SUPABASE_URL" "$file" | head -n 1 | sed -E "s/.*https:\/\/([a-z0-9]+)\.supabase\.co.*/\1/"
}

PROD_REF_1="$(extract_ref "$PROD_DIR/index.html")"
PROD_REF_2="$(extract_ref "$PROD_DIR/admin.html")"
STG_REF_1="$(extract_ref "$STG_DIR/index.html")"
STG_REF_2="$(extract_ref "$STG_DIR/admin.html")"

if [[ -z "$PROD_REF_1" || -z "$PROD_REF_2" || -z "$STG_REF_1" || -z "$STG_REF_2" ]]; then
  echo "[env-check][ERROR] unable to extract one or more Supabase refs"
  exit 1
fi

if [[ "$PROD_REF_1" != "$PROD_REF_2" ]]; then
  echo "[env-check][ERROR] prod refs mismatch between index/admin"
  exit 1
fi

if [[ "$STG_REF_1" != "$STG_REF_2" ]]; then
  echo "[env-check][ERROR] staging refs mismatch between index/admin"
  exit 1
fi

if [[ "$PROD_REF_1" == "$STG_REF_1" ]]; then
  echo "[env-check][ERROR] prod and staging use same Supabase ref: $PROD_REF_1"
  exit 1
fi

echo "[env-check] OK"
echo "[env-check] prod ref:    $PROD_REF_1"
echo "[env-check] staging ref: $STG_REF_1"
