-- ============================================================
-- Planning Piperato · dietary tracking, invite tracking,
-- and vendor payment schedule (one migration for all)
--
-- All ALTER TABLE statements use IF NOT EXISTS — safe to re-run.
-- ============================================================

-- ── guests: dietary + invite pipeline ──
alter table guests add column if not exists dietary         text default 'none';
alter table guests add column if not exists dietary_notes   text;
alter table guests add column if not exists std_sent        boolean not null default false;
alter table guests add column if not exists invite_sent     boolean not null default false;
alter table guests add column if not exists rsvp_received   boolean not null default false;

-- ── vendors: deposit + balance payment schedule ──
alter table vendors add column if not exists deposit_amount   numeric(10,2);
alter table vendors add column if not exists deposit_currency text default 'EUR';
alter table vendors add column if not exists deposit_due      date;
alter table vendors add column if not exists deposit_paid     boolean not null default false;
alter table vendors add column if not exists balance_amount   numeric(10,2);
alter table vendors add column if not exists balance_currency text default 'EUR';
alter table vendors add column if not exists balance_due      date;
alter table vendors add column if not exists balance_paid     boolean not null default false;
