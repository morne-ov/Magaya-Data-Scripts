-- Insert prefixes from: example_prefixes.csv
-- 8 prefixes
-- Safe to re-run: ON CONFLICT DO NOTHING
-- Valid type values: INTERNAL, EXTERNAL
-- Valid status values: ACTIVE, INACTIVE
-- Valid preferredProductType values: AFTER_MILL_SANDS, DUMP, PARTNER_SANDS, MAIN_SHAFT,
--   OTHER_ORES, OTHER_SANDS, PARTNER_ORES, PARTNER_MILLING

INSERT INTO "Prefix" ("id", "siteId", "code", "type", "description", "status", "preferredProductType", "createdAt", "updatedAt")
VALUES
('cmpqn3rttptwpgafmozfwk3c3', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'IS', 'INTERNAL', 'Internal Sands', 'ACTIVE', 'OTHER_SANDS', '2026-05-29T08:08:16.288Z', '2026-05-29T08:08:16.288Z'),
('cmpqn3rttvhe9aci1gxsk63sw', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'ES', 'EXTERNAL', 'External Sands', 'ACTIVE', 'OTHER_SANDS', '2026-05-29T08:08:16.288Z', '2026-05-29T08:08:16.288Z'),
('cmpqn3rttyf39vnv5kqeo9pxv', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'IC', 'INTERNAL', 'Internal Crusher Ores', 'ACTIVE', 'OTHER_ORES', '2026-05-29T08:08:16.288Z', '2026-05-29T08:08:16.288Z'),
('cmpqn3rtt2kzktd7ah5cme5rq', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'EC', 'EXTERNAL', 'External Crusher Ores', 'ACTIVE', 'OTHER_ORES', '2026-05-29T08:08:16.288Z', '2026-05-29T08:08:16.288Z'),
('cmpqn3rttn0cssc3d53kyjndt', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'HM', 'INTERNAL', 'Hammer Mill Ores', 'ACTIVE', 'OTHER_ORES', '2026-05-29T08:08:16.288Z', '2026-05-29T08:08:16.288Z'),
('cmpqn3rttx0qnwg2varbt2imp', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'BM', 'INTERNAL', 'Ball Mill After-Milling Sands', 'ACTIVE', 'AFTER_MILL_SANDS', '2026-05-29T08:08:16.288Z', '2026-05-29T08:08:16.288Z'),
('cmpqn3rttiwdoyfl5fv79hjjt', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'RM', 'INTERNAL', 'Round Mill After-Milling Sands', 'ACTIVE', 'AFTER_MILL_SANDS', '2026-05-29T08:08:16.288Z', '2026-05-29T08:08:16.288Z'),
('cmpqn3rtto55g4w6gjyupmvqr', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'OD', 'INTERNAL', 'Old Dump Sands', 'ACTIVE', 'DUMP', '2026-05-29T08:08:16.288Z', '2026-05-29T08:08:16.288Z')
ON CONFLICT ("siteId", "code") DO NOTHING;
