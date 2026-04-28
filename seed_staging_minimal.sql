begin;

-- Minimal staging seed: 1 fixed + 1 unique treasure and one active quest.
insert into public.treasures (id, type, lat, lng, label, hint, visible, photo_url, found_by, found_at, quest)
values
  ('STG-FIX-001', 'fixed', 48.8566, 2.3522, 'Balise Test Fixe', 'Près du point de départ staging', true, '', '', null, 'STAGING_DEMO'),
  ('STG-UNI-001', 'unique', 48.8571, 2.3530, 'Balise Test Unique', 'Accessible depuis le parcours de test', true, '', '', null, 'STAGING_DEMO')
on conflict (id) do update set
  type = excluded.type,
  lat = excluded.lat,
  lng = excluded.lng,
  label = excluded.label,
  hint = excluded.hint,
  visible = excluded.visible,
  photo_url = excluded.photo_url,
  found_by = excluded.found_by,
  found_at = excluded.found_at,
  quest = excluded.quest;

insert into public.config(key, value)
values
  ('quests', '["STAGING_DEMO"]'),
  ('activeQuests', '["STAGING_DEMO"]'),
  ('rewardMessage_STAGING_DEMO', 'Bravo, quête de test terminée !')
on conflict (key) do update set
  value = excluded.value;

commit;
