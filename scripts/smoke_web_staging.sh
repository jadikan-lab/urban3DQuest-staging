#!/usr/bin/env bash
set -euo pipefail

STAGING_URL="https://jadikan-lab.github.io/urban3DQuest-staging/"
PROJECT_REF="uuofsgcwznuwcsaqsmzc"

TMP_FILE="$(mktemp)"
trap 'rm -f "$TMP_FILE"' EXIT

echo "[smoke] fetching $STAGING_URL"
curl -fsSL "$STAGING_URL" > "$TMP_FILE"

echo "[smoke] checking Supabase project ref in deployed app"
if ! grep -q "$PROJECT_REF" "$TMP_FILE"; then
  echo "[smoke][ERROR] staging deploy does not reference expected project: $PROJECT_REF"
  exit 1
fi

echo "[smoke] checking no unresolved placeholder remains"
if grep -q "STAGING_PROJECT_ID" "$TMP_FILE"; then
  echo "[smoke][ERROR] unresolved STAGING_PROJECT_ID placeholder found in deployed app"
  exit 1
fi

echo "[smoke] web staging checks passed"
