-- ============================================================
-- Planning Piperato · view-only (anonymous read) policies
--
-- Lets anyone with the anon key (which is already in the client
-- bundle) read every table, but keeps writes locked to authenticated
-- users only. Powers the "View only" button on the sign-in screen.
-- Safe to re-run.
-- ============================================================

do $$
declare t text;
begin
  foreach t in array array[
    'rooms','guests','vendors','tasks','timeline_days','timeline_items',
    'payments','settings','notes','dinner_tables','line_items'
  ]
  loop
    execute format('drop policy if exists "anon can view" on %I;', t);
    execute format('create policy "anon can view" on %I for select to anon using (true);', t);
  end loop;
end $$;
