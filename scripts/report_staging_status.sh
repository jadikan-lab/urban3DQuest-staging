#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "=== STAGING STATUS REPORT ==="
echo "Date: $(date -u +"%Y-%m-%d %H:%M:%S UTC")"
echo

echo "[1/5] Linked project check"
supabase db query --linked "select 'ok' as linked;"
echo

echo "[2/5] RLS enabled on core tables"
supabase db query --linked "select c.relname as table_name, c.relrowsecurity as rls_enabled from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname='public' and c.relname in ('treasures','players','events','config','admin_users') order by c.relname;"
echo

echo "[3/5] Active policies"
supabase db query --linked "select tablename, policyname, cmd from pg_policies where schemaname='public' and tablename in ('treasures','players','events','config','admin_users') order by tablename, policyname;"
echo

echo "[4/5] Integrity objects"
supabase db query --linked "select indexname from pg_indexes where schemaname='public' and tablename='events' and indexname='uq_events_pseudo_treasure';"
supabase db query --linked "select proname from pg_proc p join pg_namespace n on n.oid=p.pronamespace where n.nspname='public' and proname='is_admin';"
echo

echo "[5/5] Seed records"
supabase db query --linked "select id,type,quest,visible from public.treasures where id like 'STG-%' order by id;"
echo

echo "=== END OF REPORT ==="
