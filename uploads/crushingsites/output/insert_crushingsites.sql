-- Insert crushing sites from: example_crushingsites.csv
-- 2 crushing sites
-- Safe to re-run: ON CONFLICT DO NOTHING

INSERT INTO "CrushingSite" ("id", "siteId", "name", "createdAt", "updatedAt")
VALUES
('cmpqn3rvai77kjggdoow4umb4', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Crusher Site 1', '2026-05-29T08:08:16.341Z', '2026-05-29T08:08:16.341Z'),
('cmpqn3rva2a7hexd4bnk1v3f0', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Crusher Site 2', '2026-05-29T08:08:16.341Z', '2026-05-29T08:08:16.341Z')
ON CONFLICT ("siteId", "name") DO NOTHING;
