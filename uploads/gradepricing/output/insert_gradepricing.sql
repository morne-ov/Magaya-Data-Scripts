-- Insert grade pricing from: example_gradepricing.csv
-- 8 pricing tiers
-- WARNING: No unique constraint — re-running will insert duplicates.
--   Check existing data first: SELECT * FROM "GradePricing" WHERE "siteId" = '...';
--
-- IMPORTANT: Replace 'REPLACE_WITH_USER_ID' with the actual user ID before running.
--   Find it with: SELECT id FROM "User" WHERE email = 'your-admin@example.com';

INSERT INTO "GradePricing" ("id", "siteId", "grade", "worldPrice", "percentage", "pricePerTon", "createdById", "updatedById", "createdAt", "updatedAt")
VALUES
('cmpqn3rx5dbo4ps4i46d4re7y', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 1.0, 2800.00, 55.0, 1540.00, 'REPLACE_WITH_USER_ID', 'REPLACE_WITH_USER_ID', '2026-05-29T08:08:16.409Z', '2026-05-29T08:08:16.409Z'),
('cmpqn3rx58kf64m5y8gkbevrc', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 2.0, 2800.00, 57.0, 1596.00, 'REPLACE_WITH_USER_ID', 'REPLACE_WITH_USER_ID', '2026-05-29T08:08:16.409Z', '2026-05-29T08:08:16.409Z'),
('cmpqn3rx5yyl6pibqd0jset2r', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 3.0, 2800.00, 59.0, 1652.00, 'REPLACE_WITH_USER_ID', 'REPLACE_WITH_USER_ID', '2026-05-29T08:08:16.409Z', '2026-05-29T08:08:16.409Z'),
('cmpqn3rx5z155x6s2vt7f8idd', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 4.0, 2800.00, 61.0, 1708.00, 'REPLACE_WITH_USER_ID', 'REPLACE_WITH_USER_ID', '2026-05-29T08:08:16.409Z', '2026-05-29T08:08:16.409Z'),
('cmpqn3rx5tsc7tqe8551vb8vl', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 5.0, 2800.00, 63.0, 1764.00, 'REPLACE_WITH_USER_ID', 'REPLACE_WITH_USER_ID', '2026-05-29T08:08:16.409Z', '2026-05-29T08:08:16.409Z'),
('cmpqn3rx5ir1xmu109zp4ym51', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 6.0, 2800.00, 65.0, 1820.00, 'REPLACE_WITH_USER_ID', 'REPLACE_WITH_USER_ID', '2026-05-29T08:08:16.409Z', '2026-05-29T08:08:16.409Z'),
('cmpqn3rx5yg7xb2t0rsrhqjco', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 7.0, 2800.00, 67.0, 1876.00, 'REPLACE_WITH_USER_ID', 'REPLACE_WITH_USER_ID', '2026-05-29T08:08:16.409Z', '2026-05-29T08:08:16.409Z'),
('cmpqn3rx59khunfsqzfpgmskk', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 8.0, 2800.00, 69.0, 1932.00, 'REPLACE_WITH_USER_ID', 'REPLACE_WITH_USER_ID', '2026-05-29T08:08:16.409Z', '2026-05-29T08:08:16.409Z');
