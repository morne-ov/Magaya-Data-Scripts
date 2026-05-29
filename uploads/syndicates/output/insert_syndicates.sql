-- Insert syndicates from: example_syndicates.csv
-- 4 syndicates
-- Safe to re-run: ON CONFLICT DO NOTHING

INSERT INTO "Syndicate" ("id", "siteId", "name", "createdAt", "updatedAt")
VALUES
('cmpqn3rw7rx272oo6hp9faq7w', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Gold Rush Syndicate', '2026-05-29T08:08:16.375Z', '2026-05-29T08:08:16.375Z'),
('cmpqn3rw745hbtxn0x0tc16h6', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Unity Mining Collective', '2026-05-29T08:08:16.375Z', '2026-05-29T08:08:16.375Z'),
('cmpqn3rw727rueg4jaqackvav', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Northern Prospects', '2026-05-29T08:08:16.375Z', '2026-05-29T08:08:16.375Z'),
('cmpqn3rw7cn7y12fmh8yq6293', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Southern Cross Mining', '2026-05-29T08:08:16.375Z', '2026-05-29T08:08:16.375Z')
ON CONFLICT ("siteId", "name") DO NOTHING;
