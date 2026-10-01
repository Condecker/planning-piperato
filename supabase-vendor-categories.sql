-- ============================================================
-- Planning Piperato · align vendor categories with Budget labels
--
-- The seeded vendor categories ("Hairdresser", "Make-up artist",
-- "Band / DJ", "Photographer") predate the Budget-tab slider labels
-- ("Hair and makeup", "Band and DJ", "Photography"). This migration
-- renames the existing rows so a vendor's category matches the slider
-- it belongs to.
-- Idempotent: no-op on re-run.
-- ============================================================

update vendors set category = 'Hair and makeup' where category in ('Hairdresser','Make-up artist');
update vendors set category = 'Band and DJ'     where category = 'Band / DJ';
update vendors set category = 'Photography'     where category = 'Photographer';
