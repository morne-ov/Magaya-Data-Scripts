-- Insert area royalty configurations from: example_arearoyaltyconfigurations.csv
-- 8 areas
-- Requires: SubArea rows must exist before running this script
-- WARNING: No unique constraint — re-running will insert duplicates.
--   Check existing data first: SELECT * FROM "AreaRoyaltyConfiguration" WHERE "siteId" = '...';
--
-- IMPORTANT: Replace 'REPLACE_WITH_USER_ID' with the actual user ID before running.
--   Find it with: SELECT id FROM "User" WHERE email = 'your-admin@example.com';
-- Valid calculationBasis values: tonnage, load_value

INSERT INTO "AreaRoyaltyConfiguration" ("id", "siteId", "areaId", "areaName", "royaltyPercentage", "calculationBasis", "createdById", "updatedById", "createdAt", "updatedAt")
VALUES
('cmpqn3rykksdzwss3gzwlq9jq', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', (SELECT id FROM "SubArea" WHERE "siteId" = 'a1b2c3d4-e5f6-4789-a012-3456789abcde' AND name = 'North Pit'), 'North Pit', 5.0, 'load_value', 'REPLACE_WITH_USER_ID', 'REPLACE_WITH_USER_ID', '2026-05-29T08:08:16.460Z', '2026-05-29T08:08:16.460Z'),
('cmpqn3rykkpzibn6f0diaizhk', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', (SELECT id FROM "SubArea" WHERE "siteId" = 'a1b2c3d4-e5f6-4789-a012-3456789abcde' AND name = 'South Dump'), 'South Dump', 3.5, 'tonnage', 'REPLACE_WITH_USER_ID', 'REPLACE_WITH_USER_ID', '2026-05-29T08:08:16.460Z', '2026-05-29T08:08:16.460Z'),
('cmpqn3ryk4egzr5xsku9wem4h', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', (SELECT id FROM "SubArea" WHERE "siteId" = 'a1b2c3d4-e5f6-4789-a012-3456789abcde' AND name = 'East Claim'), 'East Claim', 4.0, 'load_value', 'REPLACE_WITH_USER_ID', 'REPLACE_WITH_USER_ID', '2026-05-29T08:08:16.460Z', '2026-05-29T08:08:16.460Z'),
('cmpqn3rykhidh12gl8mo6a8pc', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', (SELECT id FROM "SubArea" WHERE "siteId" = 'a1b2c3d4-e5f6-4789-a012-3456789abcde' AND name = 'West Shaft Area'), 'West Shaft Area', 4.5, 'load_value', 'REPLACE_WITH_USER_ID', 'REPLACE_WITH_USER_ID', '2026-05-29T08:08:16.460Z', '2026-05-29T08:08:16.460Z'),
('cmpqn3rykhc8ib5gdwj8fjvth', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', (SELECT id FROM "SubArea" WHERE "siteId" = 'a1b2c3d4-e5f6-4789-a012-3456789abcde' AND name = 'River Zone'), 'River Zone', 5.5, 'load_value', 'REPLACE_WITH_USER_ID', 'REPLACE_WITH_USER_ID', '2026-05-29T08:08:16.460Z', '2026-05-29T08:08:16.460Z'),
('cmpqn3rykj3jmfc0a4fx1nlyf', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', (SELECT id FROM "SubArea" WHERE "siteId" = 'a1b2c3d4-e5f6-4789-a012-3456789abcde' AND name = 'JV Block A'), 'JV Block A', 6.0, 'load_value', 'REPLACE_WITH_USER_ID', 'REPLACE_WITH_USER_ID', '2026-05-29T08:08:16.460Z', '2026-05-29T08:08:16.460Z'),
('cmpqn3rykoykaad5ey5erxpab', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', (SELECT id FROM "SubArea" WHERE "siteId" = 'a1b2c3d4-e5f6-4789-a012-3456789abcde' AND name = 'Main Processing Zone'), 'Main Processing Zone', 3.0, 'tonnage', 'REPLACE_WITH_USER_ID', 'REPLACE_WITH_USER_ID', '2026-05-29T08:08:16.460Z', '2026-05-29T08:08:16.460Z'),
('cmpqn3ryksayw5xl8jfpq4qfj', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', (SELECT id FROM "SubArea" WHERE "siteId" = 'a1b2c3d4-e5f6-4789-a012-3456789abcde' AND name = 'Tailings Dump 1'), 'Tailings Dump 1', 2.5, 'tonnage', 'REPLACE_WITH_USER_ID', 'REPLACE_WITH_USER_ID', '2026-05-29T08:08:16.460Z', '2026-05-29T08:08:16.460Z');
