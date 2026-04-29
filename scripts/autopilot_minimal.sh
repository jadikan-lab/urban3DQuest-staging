#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

REPORT_FILE="$ROOT_DIR/backups/online_test_v1_latest.txt"
mkdir -p "$ROOT_DIR/backups"

echo "[autopilot] running one-shot online test preparation"
"$ROOT_DIR/scripts/prepare_online_test_v1.sh" | tee "$REPORT_FILE"

echo "[autopilot] report saved: $REPORT_FILE"

echo "[autopilot] quick links"
echo "https://jadikan-lab.github.io/urban3DQuest-staging/"
echo "https://jadikan-lab.github.io/urban3DQuest-staging/admin.html"
