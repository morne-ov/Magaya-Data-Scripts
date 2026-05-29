-- Insert shafts from: example_shafts.csv
-- 8 shafts
-- Safe to re-run: ON CONFLICT DO NOTHING

INSERT INTO "Shaft" ("id", "siteId", "name", "createdAt", "updatedAt")
VALUES
('cmpqn3rvqfnvypvdtnz6ksgsl', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Shaft 1', '2026-05-29T08:08:16.358Z', '2026-05-29T08:08:16.358Z'),
('cmpqn3rvqsrn5u4elwopic88b', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Shaft 2', '2026-05-29T08:08:16.358Z', '2026-05-29T08:08:16.358Z'),
('cmpqn3rvq0x2ws5ng5fkh0w3w', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Shaft 3', '2026-05-29T08:08:16.358Z', '2026-05-29T08:08:16.358Z'),
('cmpqn3rvq9sfuunth8z62no3f', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Shaft 4', '2026-05-29T08:08:16.358Z', '2026-05-29T08:08:16.358Z'),
('cmpqn3rvq44ms537f0cdwj48h', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Shaft 5', '2026-05-29T08:08:16.358Z', '2026-05-29T08:08:16.358Z'),
('cmpqn3rvqf550qiy4ef8wt6tz', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Shaft 6', '2026-05-29T08:08:16.358Z', '2026-05-29T08:08:16.358Z'),
('cmpqn3rvqynzomcn9zxrgm7ox', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Shaft 7', '2026-05-29T08:08:16.358Z', '2026-05-29T08:08:16.358Z'),
('cmpqn3rvq782ilhw46izya4nh', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Shaft 8', '2026-05-29T08:08:16.358Z', '2026-05-29T08:08:16.358Z')
ON CONFLICT ("siteId", "name") DO NOTHING;
