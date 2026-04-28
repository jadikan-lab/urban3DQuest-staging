#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
EXPECTED_REF="uuofsgcwznuwcsaqsmzc"
REF_FILE="$ROOT_DIR/supabase/.temp/project-ref"

if [[ ! -f "$REF_FILE" ]]; then
  echo "[guard][ERROR] missing $REF_FILE"
  echo "[guard][HINT] run: supabase link --project-ref $EXPECTED_REF --password '<DB_PASSWORD>'"
  exit 1
fi

ACTUAL_REF="$(tr -d '[:space:]' < "$REF_FILE")"

if [[ "$ACTUAL_REF" != "$EXPECTED_REF" ]]; then
  echo "[guard][ERROR] linked project ref mismatch"
  echo "[guard][ERROR] expected: $EXPECTED_REF"
  echo "[guard][ERROR] actual:   $ACTUAL_REF"
  exit 1
fi

echo "[guard] project ref OK: $ACTUAL_REF"
