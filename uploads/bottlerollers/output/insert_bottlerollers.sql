-- Insert bottle rollers from: example_bottlerollers.csv
-- 6 bottle rollers
-- WARNING: No unique constraint on BottleRoller — re-running will insert duplicates.
--   Check existing data first: SELECT * FROM "BottleRoller" WHERE "siteId" = '...';

INSERT INTO "BottleRoller" ("id", "siteId", "rollerNumber", "status", "createdAt", "updatedAt")
VALUES
('cmpqn3rub8gqp031i1oevbuhh', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'BR-01', 'IDLE', '2026-05-29T08:08:16.307Z', '2026-05-29T08:08:16.307Z'),
('cmpqn3rubvjk8ngygogj9cvvx', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'BR-02', 'IDLE', '2026-05-29T08:08:16.307Z', '2026-05-29T08:08:16.307Z'),
('cmpqn3rubud5clukm7bs08dn4', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'BR-03', 'IDLE', '2026-05-29T08:08:16.307Z', '2026-05-29T08:08:16.307Z'),
('cmpqn3rubdp23ti80bgd7kkul', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'BR-04', 'IDLE', '2026-05-29T08:08:16.307Z', '2026-05-29T08:08:16.307Z'),
('cmpqn3rub55cryd4zmid3hynt', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'BR-05', 'IDLE', '2026-05-29T08:08:16.307Z', '2026-05-29T08:08:16.307Z'),
('cmpqn3rubmjkeioh6nd8oe96j', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'BR-06', 'IDLE', '2026-05-29T08:08:16.307Z', '2026-05-29T08:08:16.307Z');
