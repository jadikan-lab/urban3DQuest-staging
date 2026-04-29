#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <db_password>"
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

EXPECTED_REF="uuofsgcwznuwcsaqsmzc"
DB_PASSWORD="$1"

echo "[safe-link] linking to staging project: $EXPECTED_REF"
supabase link --project-ref "$EXPECTED_REF" --password "$DB_PASSWORD"

echo "[safe-link] validating linked ref"
"$ROOT_DIR/scripts/guard_staging_project.sh"

echo "[safe-link] done"
