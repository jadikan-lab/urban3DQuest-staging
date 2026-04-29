#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

"$ROOT_DIR/scripts/guard_staging_project.sh"

echo "[healthcheck] verifying linked Supabase project"
supabase db query --linked "select 'ok' as linked;" >/dev/null

echo "[healthcheck] checking required tables"
supabase db query --linked "select table_name from information_schema.tables where table_schema='public' and table_name in ('treasures','players','events','config','admin_users') order by table_name;"

echo "[healthcheck] checking admin RPC"
supabase db query --linked "select proname from pg_proc p join pg_namespace n on n.oid=p.pronamespace where n.nspname='public' and proname='is_admin';"

echo "[healthcheck] checking unique index"
supabase db query --linked "select indexname from pg_indexes where schemaname='public' and tablename='events' and indexname='uq_events_pseudo_treasure';"

echo "[healthcheck] checking seeded test records"
supabase db query --linked "select id,type,quest,visible from public.treasures where id in ('STG-FIX-001','STG-UNI-001') order by id;"

echo "[healthcheck] complete"
