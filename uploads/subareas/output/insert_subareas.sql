-- Insert subareas from: example_subareas.csv
-- 8 subareas
-- Safe to re-run: ON CONFLICT DO NOTHING
-- Valid operationType values: DUMP, EXTERNAL, INTERNAL, JV, CLAIM, MINING

INSERT INTO "SubArea" ("id", "siteId", "name", "operationType", "createdAt", "updatedAt")
VALUES
('cmpqmst3kpbewifjt6qjq2zbl', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'North Pit', 'MINING', '2026-05-29T07:59:44.719Z', '2026-05-29T07:59:44.719Z'),
('cmpqmst3kr4df29okph5maxcy', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'South Dump', 'DUMP', '2026-05-29T07:59:44.719Z', '2026-05-29T07:59:44.719Z'),
('cmpqmst3k51dn6zm0pg8ox7ur', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'East Claim', 'CLAIM', '2026-05-29T07:59:44.719Z', '2026-05-29T07:59:44.719Z'),
('cmpqmst3k93jgjkpnyxpi1clm', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'West Shaft Area', 'INTERNAL', '2026-05-29T07:59:44.719Z', '2026-05-29T07:59:44.719Z'),
('cmpqmst3kyj60u00mos7s4j77', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'River Zone', 'EXTERNAL', '2026-05-29T07:59:44.719Z', '2026-05-29T07:59:44.719Z'),
('cmpqmst3kfjpo6k6dg3dg0s12', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'JV Block A', 'JV', '2026-05-29T07:59:44.719Z', '2026-05-29T07:59:44.719Z'),
('cmpqmst3k5zc079b0x2br2oil', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Main Processing Zone', 'MINING', '2026-05-29T07:59:44.719Z', '2026-05-29T07:59:44.719Z'),
('cmpqmst3kwovsbdeytqc0p7ao', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Tailings Dump 1', 'DUMP', '2026-05-29T07:59:44.719Z', '2026-05-29T07:59:44.719Z')
ON CONFLICT ("siteId", "name") DO NOTHING;
