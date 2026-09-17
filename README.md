# Planning Piperato

Private wedding planner for Claudia & Brian. Single-page app, no build step. Data lives in Supabase (Postgres) so both phones/laptops stay in sync.

## Repo layout

| File | What it is |
| --- | --- |
| `index.html` | The whole app: UI, logic, Supabase wiring, login gate. Edit this to change anything. |
| `supabase-schema.sql` | Tables + row-level security + realtime publication. **Run first** in the Supabase SQL editor. |
| `supabase-seed.sql` | All the defaults (76 guests, 18 rooms, 21 vendors, 16 tasks, timeline, payments, budget config). **Run second.** |
| `HANDOFF.md` | Original design/context doc. Keep for reference. |

---

## First-time setup

### 1 · Create the Supabase project

1. Go to <https://supabase.com>, sign up / log in, click **New project**.
2. Name it `planning-piperato` (or whatever). Pick a strong DB password (you won't need it day-to-day but Supabase makes you set one). Region: pick something close — `East US` or `EU West`.
3. Wait ~2 minutes for it to provision.

### 2 · Run the SQL

In the Supabase dashboard sidebar, click **SQL editor → New query**.

1. Copy the entire contents of `supabase-schema.sql` into the editor. Click **Run**. You should see "Success. No rows returned."
2. Clear the editor. Copy the entire contents of `supabase-seed.sql` in. Click **Run**. It'll insert all the defaults in a single transaction.
3. Sanity check: sidebar → **Table editor** → click `guests`. You should see 76 rows. `rooms` should have 18. `vendors` should have 21.

### 3 · Set up auth (two accounts, no public signup)

1. Sidebar → **Authentication → Providers**. Confirm **Email** is enabled. Turn **off** "Confirm email" (private tool, no verification loop). Save.
2. Sidebar → **Authentication → Sign In / Providers** (or **Settings** on older UIs). Set **Allow new users to sign up** to **off**. Save.
3. Sidebar → **Authentication → Users → Add user → Create new user**. Do this twice:
   - Claudia's email + a password
   - Brian's email + a password

   (You can also let each other set a password later via **Send magic link** or password reset — for a private tool with two people, just pick passwords and share them in 1Password or similar.)

### 4 · Get the API keys

Sidebar → **Project Settings → API**. Copy:

- **Project URL** — looks like `https://abcdefgh.supabase.co`
- **anon public** key — a long JWT-looking string

The anon key is safe to commit and ship in client-side JS: row-level security is on and public signup is off, so only the two accounts you just created can read or write anything.

### 5 · Paste them into `index.html`

Open `index.html`, find near the top of the `<script>` block (around line 5–6 of the script):

```js
const SUPABASE_URL      = 'https://YOUR-PROJECT-REF.supabase.co';
const SUPABASE_ANON_KEY = 'YOUR-ANON-PUBLIC-KEY';
```

Replace both values with what you copied. Save the file.

### 6 · Try it locally

Just double-click `index.html` and open it in a browser. You should see the sign-in modal. Sign in with one of the two accounts. The app loads with all the seeded data.

Open it in a second browser or on your phone (Ava's laptop, etc.), sign in with the other account, and try editing something — the other tab should update within a second (realtime is on).

---

## Deploy to Netlify

### First deploy

1. Push this folder to a GitHub repo:
   ```bash
   cd ~/planning-piperato
   git add .
   git commit -m "Initial planning-piperato"
   gh repo create planning-piperato --private --source=. --push
   # or if you're not using gh: create the repo on github.com, then
   # git remote add origin git@github.com:YOUR-USERNAME/planning-piperato.git
   # git branch -M main
   # git push -u origin main
   ```
2. Go to <https://app.netlify.com> → **Add new site → Import an existing project → GitHub**.
3. Pick `planning-piperato`. Build settings: **leave everything blank** (no build command, publish directory = `.` or blank). Click **Deploy**.
4. Netlify gives you a URL like `some-name.netlify.app`. Open it, sign in, done.
5. (Optional) **Site settings → Domain management** → add a custom domain.

### Subsequent deploys

Push to `main` and Netlify auto-deploys. That's it.

```bash
git add index.html
git commit -m "tweak room capacity"
git push
```

---

## How persistence works

- **In-memory arrays** (`guests`, `rooms`, `vstate`, `tasks`, `timeline`, `payState`, `state`) are the working source of truth. The UI renders from them.
- Each mutation site calls a specific `saveX()` / `deleteX()` helper defined at the top of the script, which upserts to Supabase in the background.
- On load (after sign-in), `hydrate()` selects every table and repopulates the arrays, then re-renders.
- Realtime subscriptions listen on all tables. When any change fires, the app re-hydrates and re-renders — that's how the "both devices stay in sync" behavior works.
- The budget config (menu tier, checkin date, guest count, presets, etc.) persists to a single JSONB row in the `settings` table.

## Gotchas

- **Don't run the seed twice on the same fresh project.** It uses `on conflict do nothing`, so re-running is a no-op for existing rows — but the timeline-items insert is guarded by `where not exists (select 1 from timeline_items)`, meaning it only seeds items on a truly empty table. Fine in practice; just noting it.
- **If you fork the schema or add a table**, remember to (a) enable RLS on it, (b) add the "authenticated full access" policy, (c) add it to the `supabase_realtime` publication if you want live updates.
- **The anon key rotates if you regenerate it in Supabase.** If you ever do that, update `index.html` and redeploy.
- **Local file:// won't do realtime.** If you open `index.html` by double-clicking, sign-in works but realtime WebSockets may not (browser security). Not a problem on Netlify — https origin, all good.

## Adding a third person later

1. Supabase dashboard → **Authentication → Users → Add user → Create new user**.
2. Share the URL + email + password. That's it. RLS lets any authenticated user read/write; no other config needed.
