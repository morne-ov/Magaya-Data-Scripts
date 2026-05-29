-- Insert site extraction efficiency from: example_siteextractionefficiency.csv
-- 1 records
-- WARNING: No unique constraint — re-running will insert duplicates.
--   Check existing data first: SELECT * FROM "SiteExtractionEfficiency" WHERE "siteId" = '...';
--
-- IMPORTANT: Replace 'REPLACE_WITH_USER_ID' with the actual user ID before running.
--   Find it with: SELECT id FROM "User" WHERE email = 'your-admin@example.com';

INSERT INTO "SiteExtractionEfficiency" ("id", "siteId", "siteName", "extractionEfficiency", "effectiveDate", "createdById", "updatedById", "createdAt", "updatedAt")
VALUES
('cmpqn3rz3977dfn1akuaq2kxb', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Amatola', 0.85, '2024-01-01', 'REPLACE_WITH_USER_ID', 'REPLACE_WITH_USER_ID', '2026-05-29T08:08:16.478Z', '2026-05-29T08:08:16.478Z');
