-- Insert milling sites from: example_millingsites.csv
-- 3 milling sites
-- Safe to re-run: ON CONFLICT DO NOTHING

INSERT INTO "MillingSite" ("id", "siteId", "name", "createdAt", "updatedAt")
VALUES
('cmpqn3rutplxb9ur3wo7fvspl', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Mill Site A', '2026-05-29T08:08:16.324Z', '2026-05-29T08:08:16.324Z'),
('cmpqn3rut63ncrat2s3iprrij', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Mill Site B', '2026-05-29T08:08:16.324Z', '2026-05-29T08:08:16.324Z'),
('cmpqn3rut6gbp5ai471kimalk', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Mill Site C', '2026-05-29T08:08:16.324Z', '2026-05-29T08:08:16.324Z')
ON CONFLICT ("siteId", "name") DO NOTHING;
