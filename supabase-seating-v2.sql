-- ============================================================
-- Planning Piperato · long-table seating (v2)
--
-- Adds a `dinner_seat` column so each guest holds a specific
-- seat position within their table, not just the table itself.
--
-- Also resets the 10 default round tables from v1 down to 2
-- long tables of 40 seats each — matches the new UI. If you've
-- already made seating assignments you want to keep, run ONLY
-- the ALTER TABLE line and skip everything below it.
-- ============================================================

alter table guests add column if not exists dinner_seat int;

-- ── reset: 2 long tables of 40 seats ──
-- Comment out the block below if you want to keep existing tables.
update guests set dinner_table = null, dinner_seat = null;
delete from dinner_tables;
insert into dinner_tables (id, name, seats, position) values
  (1, 'Long table 1', 40, 0),
  (2, 'Long table 2', 40, 1);
