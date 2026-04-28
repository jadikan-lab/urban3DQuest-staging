-- RLS compliance check for core tables in staging.
select c.relname as table_name, c.relrowsecurity as rls_enabled
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where n.nspname='public'
  and c.relname in ('treasures','players','events','config','admin_users')
order by c.relname;

select tablename, policyname, permissive, roles, cmd
from pg_policies
where schemaname='public'
  and tablename in ('treasures','players','events','config','admin_users')
order by tablename, policyname;
