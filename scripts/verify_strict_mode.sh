#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SCRIPTS_DIR="$ROOT_DIR/scripts"

missing=0

while IFS= read -r -d '' file; do
  if [[ "$file" == *.sql ]]; then
    continue
  fi
  if ! grep -q "set -euo pipefail" "$file"; then
    echo "[strict][ERROR] missing strict mode: $file"
    missing=1
  fi
done < <(find "$SCRIPTS_DIR" -type f -name "*.sh" -print0)

if [[ $missing -ne 0 ]]; then
  exit 1
fi

echo "[strict] OK: all shell scripts use set -euo pipefail"
