-- ============================================================
-- Amastuola Wedding Planner - Supabase schema
-- Run this FIRST, then run supabase-seed.sql
-- ============================================================

-- ---------- tables ----------

create table rooms (
  id        int primary key,          -- real room numbers: 101..209
  name      text not null,
  cap       int  not null,            -- max occupancy
  category  text,                     -- Deluxe | Exclusive | Suite
  features  text,
  position  int
);

create table guests (
  id         bigint primary key,      -- app-assigned numeric id
  name       text not null,
  status     text not null default 'likely',  -- likely | maybe | no
  family     boolean not null default false,
  bridal     boolean not null default false,
  room_id    int references rooms(id) on delete set null,
  email      text,
  note       text,
  position   int,
  updated_at timestamptz default now()
);

create table vendors (
  id        text primary key,         -- slug, e.g. florist-caterina-florist
  category  text,
  name      text,
  contact   text,
  status    text default '',          -- '' | maybe | contacted | booked
  notes     text default ''
);

create table tasks (
  id           bigint primary key,
  label        text not null,
  before_days  int,                   -- offset before check-in (use this OR due_date)
  due_date     date,
  done         boolean not null default false,
  position     int
);

create table timeline_days (
  id        int primary key,          -- 0,1,2
  label     text,
  position  int
);

create table timeline_items (
  id         bigint generated always as identity primary key,
  day_id     int references timeline_days(id) on delete cascade,
  time_label text,
  activity   text,
  position   int
);

create table payments (
  key   text primary key,             -- deposit | exclusivity | reception | extras
  paid  boolean not null default false
);

-- budget config as a single JSONB row (checkin date, guests, menu, bar, extras, contrib, etc.)
create table settings (
  id    int primary key default 1,
  data  jsonb not null default '{}'::jsonb
);

-- ---------- row level security ----------
-- Only signed-in users can touch the data. There will be exactly two accounts
-- (Claudia + Brian), and public signups are disabled in Auth settings, so a
-- simple "any authenticated user" policy is safe.

alter table rooms          enable row level security;
alter table guests         enable row level security;
alter table vendors        enable row level security;
alter table tasks          enable row level security;
alter table timeline_days  enable row level security;
alter table timeline_items enable row level security;
alter table payments       enable row level security;
alter table settings       enable row level security;

do $$
declare t text;
begin
  foreach t in array array['rooms','guests','vendors','tasks','timeline_days','timeline_items','payments','settings']
  loop
    execute format(
      'create policy "authenticated full access" on %I for all to authenticated using (true) with check (true);', t
    );
  end loop;
end $$;

-- ---------- realtime (optional but recommended) ----------
-- lets both phones/laptops update live
alter publication supabase_realtime add table guests, rooms, vendors, tasks, timeline_days, timeline_items, payments, settings;
