-- Integrity checks for event deduplication and admin RPC.
select indexname
from pg_indexes
where schemaname='public'
  and tablename='events'
  and indexname='uq_events_pseudo_treasure';

select proname
from pg_proc p
join pg_namespace n on n.oid=p.pronamespace
where n.nspname='public'
  and proname='is_admin';
