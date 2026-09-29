-- ============================================================
-- Planning Piperato · actuals ledger migration
--
-- Adds a `line_items` table for the Actuals tab: every real
-- wedding expense as its own row with amount, category, and
-- who paid (Brian, Claudia, or Other). Powers the settlement
-- summary on the Actuals tab.
-- Idempotent — safe to run more than once.
-- ============================================================

create table if not exists line_items (
  id           bigint generated always as identity primary key,
  label        text not null,
  amount       numeric(10,2) not null default 0,
  currency     text not null default 'EUR',  -- 'EUR' or 'USD' — what the vendor charged in
  category     text,                    -- vendor id ('photo', 'planner', …), 'venue', or 'other'
  paid_by      text,                    -- 'brian' | 'claudia' | 'other'
  paid_by_name text,                    -- optional name when paid_by='other'
  spent_on     date,
  notes        text,
  position     int,
  created_at   timestamptz not null default now()
);

-- Idempotent add for people who ran an earlier version of this migration
-- before the currency column existed. Safe to run any number of times.
alter table line_items add column if not exists currency text not null default 'EUR';

alter table line_items enable row level security;

do $$
begin
  if not exists (
    select 1 from pg_policies where schemaname='public' and tablename='line_items' and policyname='authenticated full access'
  ) then
    create policy "authenticated full access" on line_items for all to authenticated using (true) with check (true);
  end if;
end $$;

do $$
begin
  if not exists (
    select 1 from pg_publication_tables where pubname='supabase_realtime' and schemaname='public' and tablename='line_items'
  ) then
    alter publication supabase_realtime add table line_items;
  end if;
end $$;
