-- Insert transport pricing from: example_transportpricing.csv
-- 5 km bands
-- WARNING: No unique constraint — re-running will insert duplicates.
--   Check existing data first: SELECT * FROM "TransportPricing" WHERE "siteId" = '...';
--
-- IMPORTANT: Replace 'REPLACE_WITH_USER_ID' with the actual user ID before running.
--   Find it with: SELECT id FROM "User" WHERE email = 'your-admin@example.com';

INSERT INTO "TransportPricing" ("id", "siteId", "startKm", "endKm", "costPerKm", "createdById", "updatedById", "createdAt", "updatedAt")
VALUES
('cmpqn3rxm0hgnn29lmlsf8j6d', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 0, 10, 2.50, 'REPLACE_WITH_USER_ID', 'REPLACE_WITH_USER_ID', '2026-05-29T08:08:16.425Z', '2026-05-29T08:08:16.425Z'),
('cmpqn3rxmbr5q4q9mlaz5znnm', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 10, 25, 2.20, 'REPLACE_WITH_USER_ID', 'REPLACE_WITH_USER_ID', '2026-05-29T08:08:16.425Z', '2026-05-29T08:08:16.425Z'),
('cmpqn3rxmzz9i65i9neu6yn63', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 25, 50, 2.00, 'REPLACE_WITH_USER_ID', 'REPLACE_WITH_USER_ID', '2026-05-29T08:08:16.425Z', '2026-05-29T08:08:16.425Z'),
('cmpqn3rxmiygsr6zmz7quo5sm', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 50, 100, 1.80, 'REPLACE_WITH_USER_ID', 'REPLACE_WITH_USER_ID', '2026-05-29T08:08:16.425Z', '2026-05-29T08:08:16.425Z'),
('cmpqn3rxmyhapy48z8isfa7df', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 100, 999, 1.60, 'REPLACE_WITH_USER_ID', 'REPLACE_WITH_USER_ID', '2026-05-29T08:08:16.425Z', '2026-05-29T08:08:16.425Z');
