-- ============================================================
-- Planning Piperato · reception seating migration
-- Adds a `dinner_tables` table + a `dinner_table` column on guests
-- so guests can be assigned to a table for the wedding dinner
-- (separate from their room assignment on the Rooms tab).
-- Idempotent — safe to run more than once.
-- ============================================================

create table if not exists dinner_tables (
  id       int primary key,
  name     text not null,
  seats    int not null default 8,
  position int
);

alter table guests add column if not exists dinner_table int references dinner_tables(id) on delete set null;

alter table dinner_tables enable row level security;

do $$
begin
  if not exists (
    select 1 from pg_policies where schemaname='public' and tablename='dinner_tables' and policyname='authenticated full access'
  ) then
    create policy "authenticated full access" on dinner_tables for all to authenticated using (true) with check (true);
  end if;
end $$;

do $$
begin
  if not exists (
    select 1 from pg_publication_tables where pubname='supabase_realtime' and schemaname='public' and tablename='dinner_tables'
  ) then
    alter publication supabase_realtime add table dinner_tables;
  end if;
end $$;

-- Seed 10 tables of 8 (adjust in-app once you know the venue's actual layout).
insert into dinner_tables (id, name, seats, position) values
  ( 1, 'Table 1',  8, 0),
  ( 2, 'Table 2',  8, 1),
  ( 3, 'Table 3',  8, 2),
  ( 4, 'Table 4',  8, 3),
  ( 5, 'Table 5',  8, 4),
  ( 6, 'Table 6',  8, 5),
  ( 7, 'Table 7',  8, 6),
  ( 8, 'Table 8',  8, 7),
  ( 9, 'Table 9',  8, 8),
  (10, 'Table 10', 8, 9)
on conflict (id) do nothing;
