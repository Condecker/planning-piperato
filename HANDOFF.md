# Amastuola Wedding Planner - Handoff for Claude Code

## The goal

Take the existing single-file HTML planner and turn it into a real, hosted web app:

- Host it on **Netlify** (static, no build step needed).
- Move all data into **Supabase** (Postgres) so it syncs across devices and never lives only in one browser.
- Add **simple auth** so only Claudia and Brian can open it.
- Keep everything else working exactly as it does today.

This is a private tool for two people. Do not over-engineer it. The app already works; the job is persistence, auth, and hosting, not a rewrite.

## What is in this folder

| File | What it is |
| --- | --- |
| `index.html` | The entire app. HTML + CSS + vanilla JS, self-contained, no dependencies, no build step. This is the source of truth for all UI and logic. |
| `supabase-schema.sql` | Postgres tables + row-level security + realtime. Run first. |
| `supabase-seed.sql` | Every current default (76 guests, 18 rooms, 21 vendors, 16 tasks, the timeline, payments, budget settings) as INSERT statements. Run second. |
| `HANDOFF.md` | This document. |

## What the app does (five tabs)

- **Budget** - live cost calculator with real 2028 Amastuola pricing. Date picker drives room cost; menu tiers auto-pick the cheaper guaranteed-cover bracket; bar, ceremony, extras, and a guest room-contribution model (0 / 100 / 150 / full price) that reads the room plan.
- **Guests** - 76 preloaded guests, each with attending status (likely/maybe/no), family and bridal tags, room assignment, email, and notes.
- **Rooms** - the 18 real rooms with exact max occupancy. Assign guests, auto-fill, see who is unassigned, and copy a rooming-list export for the venue.
- **Vendors** - recommended supplier list with a status (maybe/contacted/booked) and a notes box per vendor.
- **Plan** - a countdown checklist with due dates, a payments tracker, and a three-day weekend timeline.

## Current architecture (the starting point)

- Everything is in-memory in JS arrays and objects. The UI renders from those.
- Persistence today uses a sandbox API called `window.storage` (`.get`, `.set`, `.delete`). **This API only exists inside the Claude artifact sandbox. It is the one thing that must be replaced with Supabase.**
- The two functions to look at are `persist()` (writes every key) and `hydrate()` (reads every key on load). Find them in the `<script>` block.

## The data model (storage key to table map)

The in-memory objects and their current `window.storage` keys map to the new tables like this:

| In-memory (JS) | Old storage key | New Supabase table |
| --- | --- | --- |
| `guests` array | `guests` | `guests` |
| `rooms` array | `rooms` | `rooms` |
| `vstate` object (vendor status/notes) | `vendors` | `vendors` |
| `tasks` array | `tasks` | `tasks` |
| `timeline` array | `timeline` | `timeline_days` + `timeline_items` |
| `payState` object | `payments` | `payments` |
| `state` object (budget config) | not persisted today | `settings` (single JSONB row) |

Shapes (already reflected in the schema and seed):

- **guest**: `{ id, name, status, family, bridal, room, email, note }`. `room` is a room id (101..209) or null, NOT a guest id.
- **room**: `{ id, name, cap, cat, feat }`.
- **vendor state**: keyed by a slug id, `{ status, notes }`. The vendor catalog (category, name, contact) is static in the JS and also seeded.
- **task**: `{ id, text, before, done }` for preloaded (offset in days before check-in) and `{ id, text, date, done }` for user-added.
- **timeline**: `[ { day, items: [ { time, act } ] } ]`.
- **payState**: `{ deposit, exclusivity, reception, extras }` booleans.

## Step by step

### 1. Supabase project

1. Create a Supabase project.
2. SQL editor: run `supabase-schema.sql`, then `supabase-seed.sql`.
3. Auth settings: enable the Email provider, then **turn off public signups** (this is a two-person app).
4. Create two users by hand (Claudia and Brian) with email + password.
5. Copy the Project URL and the `anon` public key.

### 2. Wire Supabase into `index.html`

- Add the client from a CDN (keeps the no-build-step simplicity):
  `<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>`
- Init: `const db = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);`
  The anon key is safe to ship in client code because row-level security is on and signups are disabled. Only the two accounts can read or write.
- Add a small **login gate**: if there is no session, show an email + password form; on success, load the app. Add a sign-out button somewhere quiet.
- **Replace `hydrate()`**: instead of `window.storage.get`, `select` from each table, then populate the same in-memory arrays/objects the UI already uses, then call the existing render functions. Keeping the in-memory arrays as the working source of truth means almost none of the render code changes.
- **Replace `persist()`**: instead of `window.storage.set`, `upsert` to Supabase. Two acceptable levels:
  - Minimal: on any change, upsert the whole collection and delete rows that no longer exist.
  - Better: upsert only the entity that changed (the click handlers already know which guest/room/task changed). This is cleaner and pairs well with realtime.
- Keep the existing "render from arrays" pattern. Do not rebuild the UI around the database; sync the arrays to the database and back.

### 3. Realtime (recommended)

Subscribe to the tables so if Claudia edits on her phone and Brian on his laptop, both update live. On a change event, refresh the affected array and re-render. The schema already adds the tables to the realtime publication.

### 4. Netlify

- Put `index.html` at the repo root. No build command, publish directory is the root.
- Connect the repo to Netlify and deploy. Add a custom domain later if wanted.
- Config: for a static client-side app the Supabase URL and anon key live in the JS. That is fine with RLS on. If you would rather not commit them, inject them with a tiny Netlify build snippet or a `config.js` that is generated at deploy time. Not required for launch.

## Preserve exactly (do not change)

- The visual design: fonts (Fraunces, Hanken Grotesk, JetBrains Mono), the color tokens, and the layout. It is intentional.
- All five tabs and their current behavior.
- All pricing logic: the menu bracket auto-pick, the contribution options including **Full price**, the **extra-bed math** (50 euro per bed per night, counted from the room plan), and the **date-based room pricing** from the built-in 2028 nightly rate table.
- The contract-accurate numbers: 70-adult guarantee at 235 per person, 22,500 euro room exclusivity, up to 13 extra beds, 6 PM to 2 AM standard duration, guests pay their own rooms and it is deducted from the package.
- The baked data: 76 guests with their statuses/tags/room assignments, the 18 rooms with exact max occupancy, the vendor list, the checklist, and the timeline. The seed file carries all of it.

## Nice-to-have stretch goals (only after the core works)

- Installable PWA so it sits on the phone home screen.
- A public RSVP link (a second tiny page) that lets guests submit their own email and dietary needs, writing into the `guests` table, so the rooming-list export fills itself in.
- CSV or PDF export of the rooming list, in addition to the copy-to-clipboard that exists now.
- A simple change log or "last edited by" using the two accounts.

## Gotchas

- `window.storage` is async and throws when a key is missing. Supabase behaves differently; wrap loads so a fresh/empty table just falls back to the seeded defaults.
- Guest `room` points at a room id (101..209). Keep that relationship intact (`guests.room_id -> rooms.id`).
- Keep list order. The seed sets a `position` column on each table; sort by it when loading.
- Ids: guests and tasks use app-assigned numeric ids. Keep them, or move everything to UUIDs consistently. Do not mix.
- The budget `state` object is not persisted today. Persisting it (the `settings` row) is a small, welcome upgrade so the budget view is the same on every device.
- Do not let a Supabase read failure wipe the in-memory arrays. On error, keep what is on screen.
