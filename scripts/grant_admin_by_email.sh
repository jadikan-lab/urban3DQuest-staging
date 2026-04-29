#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <email>"
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

"$ROOT_DIR/scripts/guard_staging_project.sh"

EMAIL_RAW="$1"
EMAIL_SQL="${EMAIL_RAW//\'/\'\'}"

echo "[admin] granting admin role to: $EMAIL_RAW"
supabase db query --linked "insert into public.admin_users(user_id) select id from auth.users where email='${EMAIL_SQL}' on conflict do nothing;"

echo "[admin] resulting admin_users rows for email"
supabase db query --linked "select a.user_id, u.email from public.admin_users a join auth.users u on u.id=a.user_id where u.email='${EMAIL_SQL}';"

echo "[admin] done"
