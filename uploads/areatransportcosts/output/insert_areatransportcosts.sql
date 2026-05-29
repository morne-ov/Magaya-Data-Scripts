-- Insert area transport costs from: example_areatransportcosts.csv
-- 8 areas
-- Requires: SubArea rows must exist before running this script
-- WARNING: No unique constraint — re-running will insert duplicates.
--   Check existing data first: SELECT * FROM "AreaTransportCosts" WHERE "siteId" = '...';

INSERT INTO "AreaTransportCosts" ("id", "siteId", "areaId", "areaName", "transportCost", "createdAt", "updatedAt")
VALUES
('cmpqn3ry3c799cnijl02mwnl7', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', (SELECT id FROM "SubArea" WHERE "siteId" = 'a1b2c3d4-e5f6-4789-a012-3456789abcde' AND name = 'North Pit'), 'North Pit', 850.00, '2026-05-29T08:08:16.442Z', '2026-05-29T08:08:16.442Z'),
('cmpqn3ry393867wjvc9uerbtb', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', (SELECT id FROM "SubArea" WHERE "siteId" = 'a1b2c3d4-e5f6-4789-a012-3456789abcde' AND name = 'South Dump'), 'South Dump', 620.00, '2026-05-29T08:08:16.442Z', '2026-05-29T08:08:16.442Z'),
('cmpqn3ry3jowsk1xb9rf9er7m', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', (SELECT id FROM "SubArea" WHERE "siteId" = 'a1b2c3d4-e5f6-4789-a012-3456789abcde' AND name = 'East Claim'), 'East Claim', 730.00, '2026-05-29T08:08:16.442Z', '2026-05-29T08:08:16.442Z'),
('cmpqn3ry3kncb1a28e5srbs97', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', (SELECT id FROM "SubArea" WHERE "siteId" = 'a1b2c3d4-e5f6-4789-a012-3456789abcde' AND name = 'West Shaft Area'), 'West Shaft Area', 690.00, '2026-05-29T08:08:16.442Z', '2026-05-29T08:08:16.442Z'),
('cmpqn3ry36tzuc15b4hqzoyqp', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', (SELECT id FROM "SubArea" WHERE "siteId" = 'a1b2c3d4-e5f6-4789-a012-3456789abcde' AND name = 'River Zone'), 'River Zone', 910.00, '2026-05-29T08:08:16.442Z', '2026-05-29T08:08:16.442Z'),
('cmpqn3ry3k3rcgs7tdew5mbia', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', (SELECT id FROM "SubArea" WHERE "siteId" = 'a1b2c3d4-e5f6-4789-a012-3456789abcde' AND name = 'JV Block A'), 'JV Block A', 780.00, '2026-05-29T08:08:16.442Z', '2026-05-29T08:08:16.442Z'),
('cmpqn3ry3bzh4ejcwn81clhik', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', (SELECT id FROM "SubArea" WHERE "siteId" = 'a1b2c3d4-e5f6-4789-a012-3456789abcde' AND name = 'Main Processing Zone'), 'Main Processing Zone', 500.00, '2026-05-29T08:08:16.442Z', '2026-05-29T08:08:16.442Z'),
('cmpqn3ry3lyce5iaytpjfrd33', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', (SELECT id FROM "SubArea" WHERE "siteId" = 'a1b2c3d4-e5f6-4789-a012-3456789abcde' AND name = 'Tailings Dump 1'), 'Tailings Dump 1', 430.00, '2026-05-29T08:08:16.442Z', '2026-05-29T08:08:16.442Z');
