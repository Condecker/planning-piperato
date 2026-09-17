-- ============================================================
-- Planning Piperato · seed data
-- Run AFTER supabase-schema.sql. One-shot: intended for a fresh DB.
-- Re-running will silently skip existing rows via `on conflict do nothing`.
-- ============================================================

begin;

-- ---------- rooms ----------
insert into rooms (id, name, cap, category, features, position) values
  (101, '101 · Ovile Suite',        2, 'Suite',     'ground floor · Jacuzzi',                    0),
  (107, '107 · Suite Deluxe',       3, 'Suite',     'ground floor · Jacuzzi',                    1),
  (108, '108 · Suite Superior',     5, 'Suite',     'ground floor · two separate rooms',         2),
  (204, '204 · Padronale Suite',    2, 'Suite',     'first floor · bathtub · private terrace',   3),
  (102, '102 · Deluxe',             3, 'Deluxe',    'ground floor',                              4),
  (103, '103 · Deluxe',             2, 'Deluxe',    'ground floor · twin option',                5),
  (104, '104 · Deluxe',             2, 'Deluxe',    'ground floor',                              6),
  (105, '105 · Deluxe',             2, 'Deluxe',    'ground floor',                              7),
  (106, '106 · Deluxe',             2, 'Deluxe',    'ground floor · twin option',                8),
  (109, '109 · Deluxe',             3, 'Deluxe',    'ground floor · twin option',                9),
  (201, '201 · Exclusive',          3, 'Exclusive', 'first floor',                              10),
  (202, '202 · Exclusive',          2, 'Exclusive', 'first floor',                              11),
  (203, '203 · Exclusive',          3, 'Exclusive', 'first floor · twin option',                12),
  (205, '205 · Exclusive',          3, 'Exclusive', 'first floor · balcony',                    13),
  (206, '206 · Exclusive',          3, 'Exclusive', 'first floor · twin option · balcony',      14),
  (207, '207 · Exclusive',          3, 'Exclusive', 'first floor · balcony',                    15),
  (208, '208 · Exclusive',          3, 'Exclusive', 'first floor · twin option · balcony',      16),
  (209, '209 · Exclusive',          3, 'Exclusive', 'first floor · balcony',                    17)
on conflict (id) do nothing;

-- ---------- guests ----------
insert into guests (id, name, status, family, bridal, room_id, email, note, position) values
  ( 1, 'Me',                   'likely', false, false, 101,  null, null,  0),
  ( 2, 'Brian',                'likely', false, false, 101,  null, null,  1),
  ( 3, 'Ava',                  'likely', false, false, 204,  null, null,  2),
  ( 4, 'Mommy',                'likely', true,  false, 104,  null, null,  3),
  ( 5, 'Juan',                 'likely', false, false, 104,  null, null,  4),
  ( 6, 'Michael',              'likely', false, false, 106,  null, null,  5),
  ( 7, 'Brian''s dad',         'likely', true,  false, 108,  null, null,  6),
  ( 8, 'Rosie',                'likely', false, false, 108,  null, null,  7),
  ( 9, 'Aunt franca',          'likely', true,  false, 102,  null, null,  8),
  (10, 'uncle joe',            'likely', true,  false, 102,  null, null,  9),
  (11, 'fran',                 'likely', true,  false, 205,  null, null, 10),
  (12, 'mia',                  'likely', true,  false, 205,  null, null, 11),
  (13, 'jayden',               'likely', true,  false, 203,  null, null, 12),
  (14, 'dominque',             'likely', true,  false, 203,  null, null, 13),
  (15, 'doninques husband',    'likely', true,  false, 203,  null, null, 14),
  (16, 'aunt roe',             'likely', true,  false, 103,  null, null, 15),
  (17, 'uncle tom',            'likely', true,  false, 103,  null, null, 16),
  (18, 'tj',                   'likely', true,  false, 105,  null, null, 17),
  (19, 'jeff',                 'likely', true,  false, 105,  null, null, 18),
  (20, 'brian''s grandma',     'likely', true,  false, 108,  null, null, 19),
  (21, 'adrianna',             'likely', true,  false, 108,  null, null, 20),
  (22, 'greg',                 'likely', true,  false, 108,  null, null, 21),
  (23, 'Uncle Ronnie',         'maybe',  true,  false, null, null, null, 22),
  (24, 'Aunt Lisa',            'likely', true,  false, 207,  null, null, 23),
  (25, 'Antonio',              'likely', true,  false, 207,  null, null, 24),
  (26, 'Antonio wife',         'no',     false, false, null, null, null, 25),
  (27, 'Mike',                 'likely', false, true,  109,  null, null, 26),
  (28, 'Kim',                  'likely', false, true,  109,  null, null, 27),
  (29, 'Sam',                  'likely', false, true,  206,  null, null, 28),
  (30, 'Bri',                  'likely', false, true,  201,  null, null, 29),
  (31, 'chris',                'likely', false, true,  201,  null, null, 30),
  (32, 'Tommy',                'likely', false, true,  209,  null, null, 31),
  (33, 'Nikki',                'likely', false, true,  209,  null, null, 32),
  (34, 'Nik',                  'likely', false, true,  208,  null, null, 33),
  (35, 'Sandy',                'likely', false, false, 208,  null, null, 34),
  (36, 'Ken',                  'likely', false, true,  208,  null, null, 35),
  (37, 'Brit',                 'likely', false, false, null, null, null, 36),
  (38, 'Neil',                 'likely', false, false, null, null, null, 37),
  (39, 'Alexa',                'likely', false, false, null, null, null, 38),
  (40, 'Matt',                 'likely', false, false, null, null, null, 39),
  (41, 'Tiff',                 'likely', false, false, null, null, null, 40),
  (42, 'Maddie',               'likely', false, false, null, null, null, 41),
  (43, 'Griffin',              'likely', false, false, null, null, null, 42),
  (44, 'Neal',                 'likely', false, false, 107,  null, null, 43),
  (45, 'Chris',                'likely', false, false, 202,  null, null, 44),
  (46, 'Nicole',               'likely', false, false, 202,  null, null, 45),
  (47, 'Gab Falco',            'maybe',  false, false, null, null, null, 46),
  (48, 'Gab BF',               'maybe',  false, false, null, null, null, 47),
  (49, 'Black kris',           'likely', false, false, null, null, null, 48),
  (50, 'Victoria',             'maybe',  false, false, null, null, null, 49),
  (51, 'Matt',                 'maybe',  false, false, null, null, null, 50),
  (52, 'Wes',                  'likely', false, false, null, null, null, 51),
  (53, 'Kaitlyn',              'likely', false, false, 201,  null, null, 52),
  (54, 'Kevin',                'likely', false, false, null, null, null, 53),
  (55, 'Allie',                'likely', false, false, 206,  null, null, 54),
  (56, 'Siena',                'likely', false, false, 107,  null, null, 55),
  (57, 'Dave',                 'likely', false, false, 107,  null, null, 56),
  (58, 'Calie',                'likely', false, false, null, null, null, 57),
  (59, 'Calie BF',             'likely', false, false, null, null, null, 58),
  (60, 'Paul',                 'no',     false, false, null, null, null, 59),
  (61, 'Karen',                'no',     false, false, null, null, null, 60),
  (62, 'Steve',                'likely', false, false, null, null, null, 61),
  (63, 'Tinamarie',            'likely', false, false, null, null, null, 62),
  (64, 'Joe',                  'likely', false, false, null, null, null, 63),
  (65, 'Michelle (Fran)',      'likely', false, false, 209,  null, null, 64),
  (66, 'Luis',                 'likely', false, false, null, null, null, 65),
  (67, 'Luis GF',              'likely', false, false, null, null, null, 66),
  (68, 'Ricky',                'likely', false, false, null, null, null, 67),
  (69, 'Ricky GF',             'likely', false, false, null, null, null, 68),
  (70, 'Rin',                  'likely', false, false, null, null, null, 69),
  (71, 'Sam D',                'likely', false, false, 109,  null, null, 70),
  (72, 'Ava BF (Frank)',       'likely', false, false, 204,  null, null, 71),
  (73, 'Fran BF',              'likely', false, false, 205,  null, null, 72),
  (74, 'Michael GF',           'likely', false, false, 106,  null, null, 73),
  (75, 'Sam BF',               'likely', false, false, 206,  null, null, 74),
  (76, 'Aunt Lisa Husband',    'likely', false, false, 207,  null, null, 75)
on conflict (id) do nothing;

-- ---------- vendors ----------
-- IDs match the slug function in index.html:
--   (category + '-' + name).toLowerCase().replace(/[^a-z0-9]+/g, '-')
insert into vendors (id, category, name, contact, status, notes) values
  ('florist-caterina-florist',        'Florist',        'Caterina Florist',      'WhatsApp +39 351 647 0522 · info@caterinaruggieri.com',    '', ''),
  ('florist-nunzia-guerino',          'Florist',        'Nunzia Guerino',        '+39 329 586 6389 · info@nunziaguerinoflorist.it',          '', ''),
  ('florist-vincenzo-frascella',      'Florist',        'Vincenzo Frascella',    '+39 099 731 4799',                                         '', ''),
  ('florist-francesco-guida',         'Florist',        'Francesco Guida',       '+39 392 868 1015',                                         '', ''),
  ('florist-zair-art-flower-deco',    'Florist',        'Zair''art flower deco', '+39 349 542 0815 · zairartflowerdeco@gmail.com',           '', ''),
  ('hairdresser-nico-vinci',          'Hairdresser',    'Nico Vinci',            '+39 099 696 2013',                                         '', ''),
  ('hairdresser-tommaso-tristani',    'Hairdresser',    'Tommaso Tristani',      '+39 345 989 5159 · t.tristaniparrucchieri@gmail.com',      '', ''),
  ('make-up-artist-rossella-panarelli','Make-up artist','Rossella Panarelli',    '+39 350 095 5824 · rossellapan.mua@libero.it',             '', ''),
  ('make-up-artist-valentina-galizia', 'Make-up artist','Valentina Galizia',     '+39 347 894 0231',                                         '', ''),
  ('make-up-artist-valentina-liddi',   'Make-up artist','Valentina Liddi',       '+39 327 549 1053 · valentina.liddi@gmail.com',             '', ''),
  ('band-dj-rinaldi-events',          'Band / DJ',      'Rinaldi Events',        '+39 389 014 0132 · rinaldiproduction.it',                  '', ''),
  ('band-dj-mustacchi-brothers',      'Band / DJ',      'Mustacchi Brothers',    '+39 389 548 9206 · info@mustacchibros.it',                 '', ''),
  ('band-dj-just-band',               'Band / DJ',      'Just Band',             '+39 327 592 7596',                                         '', ''),
  ('band-dj-danny-howen',             'Band / DJ',      'Danny Howen',           '+39 340 401 7474',                                         '', ''),
  ('band-dj-alex-sisto-dj',           'Band / DJ',      'Alex Sisto DJ',         '+39 333 2755 135 · alexsisto@hotmail.it',                  '', ''),
  ('band-dj-spaghetti-brothers',      'Band / DJ',      'Spaghetti Brothers',    '+39 333 503 0498 · nickypezzolla@gmail.com',               '', ''),
  ('photographer-francesco-gravina',  'Photographer',   'Francesco Gravina',     '+39 329 112 2720 · fotogravina.it',                        '', ''),
  ('photographer-francesco-francioso','Photographer',   'Francesco Francioso',   '+39 339 159 5956 · francesco@francioso.it',                '', ''),
  ('photographer-andrea-anthoi',      'Photographer',   'Andrea Anthoi',         '+39 346 028 4563 · info@andreantohifotografia.com',        '', ''),
  ('photographer-antonio-luc-',       'Photographer',   'Antonio Lucà',          '+39 389 174 2857 · aellephotography@gmail.com',            '', ''),
  ('photographer-amarillis-fotografi','Photographer',   'Amarillis Fotografi',   '+39 349 239 9457 · info@amarilisphotography.com',          '', '')
on conflict (id) do nothing;

-- ---------- tasks ----------
insert into tasks (id, label, before_days, due_date, done, position) values
  ( 1, 'Pay €5,000 deposit to secure the date',                              400, null, true,   0),
  ( 2, 'Book photographer',                                                  340, null, false,  1),
  ( 3, 'Book florist',                                                       320, null, false,  2),
  ( 4, 'Book band / DJ',                                                     320, null, false,  3),
  ( 5, 'Book hair & makeup',                                                 250, null, false,  4),
  ( 6, 'Decide ceremony type & start paperwork (Nulla Osta if Catholic)',    220, null, false,  5),
  ( 7, 'Send save-the-dates',                                                240, null, false,  6),
  ( 8, 'Menu tasting at Amastuola',                                          120, null, false,  7),
  ( 9, 'Collect guest emails & dietary needs',                               120, null, false,  8),
  (10, 'Send invitations',                                                   110, null, false,  9),
  (11, 'Build rooming list & send to Amastuola',                              75, null, false, 10),
  (12, 'Pay room exclusivity',                                                30, null, false, 11),
  (13, 'Confirm final guest numbers',                                         15, null, false, 12),
  (14, 'Confirm & pay SIAE music licence',                                    15, null, false, 13),
  (15, 'Pay reception & events balance',                                      14, null, false, 14),
  (16, 'Settle extras at check-out',                                           0, null, false, 15)
on conflict (id) do nothing;

-- ---------- timeline ----------
insert into timeline_days (id, label, position) values
  (0, 'Day 1 · Welcome dinner', 0),
  (1, 'Day 2 · Wedding',        1),
  (2, 'Day 3 · Pool party',     2)
on conflict (id) do nothing;

-- Guard against duplicate seed of items (identity PK).
insert into timeline_items (day_id, time_label, activity, position)
select * from (values
  (0, 'From 4 PM',    'Guest check-in at Amastuola',                 0),
  (0, '7:30 PM',      'Welcome dinner among the vines',              1),
  (0, '10 PM',        'Drinks & mingling',                           2),
  (1, 'Morning',      'Hair & makeup',                               0),
  (1, '4:30 PM',      'Welcome drinks before ceremony',              1),
  (1, '5 PM',         'Ceremony (olive grove / lawn)',               2),
  (1, '5:45 PM',      'Aperitif dinner',                             3),
  (1, '8 PM',         'Dinner & speeches',                           4),
  (1, '10 PM',        'Cake & first dance',                          5),
  (1, 'Late',         'Party — open bar (+ extension to ~3 AM)',     6),
  (2, 'Late morning', 'Pool party — BBQ / pizza brunch',             0),
  (2, 'Afternoon',    'Farewell & check-out',                        1)
) as v(day_id, time_label, activity, position)
where not exists (select 1 from timeline_items);

-- ---------- payments ----------
insert into payments (key, paid) values
  ('deposit',      true),
  ('exclusivity',  false),
  ('reception',    false),
  ('extras',       false)
on conflict (key) do nothing;

-- ---------- settings ----------
-- Single JSONB row for the budget config (checkin date, guest count, menu tier,
-- bar choice, welcome-night pick, brunch on/off, ceremony type, room contribution, add-ons).
insert into settings (id, data) values (1, '{
  "checkin":   "2028-06-09",
  "guests":    60,
  "menu":      "ondarosa",
  "abar":      "ck4",
  "ext":       "2",
  "welcome":   "pizza",
  "brunch":    "on",
  "ceremony":  "symbolic",
  "olive":     "on",
  "contrib":   "100",
  "cheese":    "off",
  "panzerotto":"off",
  "spritz":    "off",
  "rawsea":    "off",
  "dessert":   "off",
  "icecream":  "off",
  "rum":       "off",
  "prosecco":  "off",
  "fireworks": "off",
  "kids":      0
}'::jsonb)
on conflict (id) do nothing;

commit;
