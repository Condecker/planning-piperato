-- ============================================================
-- Planning Piperato · notes log migration
-- Adds a `notes` table for the Notes tab. Run this once, after the
-- initial schema. Idempotent-ish: re-running will error on the create,
-- but the policy and realtime lines are guarded.
-- ============================================================

create table if not exists notes (
  id           bigint generated always as identity primary key,
  body         text not null,
  author_email text,
  author_id    uuid references auth.users(id) on delete set null,
  created_at   timestamptz not null default now()
);

alter table notes enable row level security;

do $$
begin
  if not exists (
    select 1 from pg_policies where schemaname='public' and tablename='notes' and policyname='authenticated full access'
  ) then
    create policy "authenticated full access" on notes for all to authenticated using (true) with check (true);
  end if;
end $$;

do $$
begin
  if not exists (
    select 1 from pg_publication_tables where pubname='supabase_realtime' and schemaname='public' and tablename='notes'
  ) then
    alter publication supabase_realtime add table notes;
  end if;
end $$;
