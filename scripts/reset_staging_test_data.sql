begin;

-- Remove only test treasures introduced by staging seed scripts.
delete from public.treasures
where id in ('STG-FIX-001','STG-UNI-001')
   or id like 'STG-%';

-- Remove only staging demo config keys.
delete from public.config
where key in ('quests','activeQuests','rewardMessage_STAGING_DEMO')
   and (value like '%STAGING_DEMO%' or key='rewardMessage_STAGING_DEMO');

commit;
