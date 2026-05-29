-- Insert user roles from: example_userroles.csv
-- 6 roles
-- Safe to re-run: ON CONFLICT DO NOTHING

INSERT INTO "UserRole" ("id", "siteId", "name", "description", "isSystem", "isActive", "createdAt", "updatedAt")
VALUES
('cmpqn3rsrt83qun9b7tpbqmpd', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Admin', 'Full system access - all resources and actions', true, true, '2026-05-29T08:08:16.250Z', '2026-05-29T08:08:16.250Z'),
('cmpqn3rsr7qr17xg2i0z14f8g', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Supervisor', 'Can approve and reject payment reports', false, true, '2026-05-29T08:08:16.250Z', '2026-05-29T08:08:16.250Z'),
('cmpqn3rsr4erc70bcw5a9j79d', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Agent', 'Can create and manage weighbridge entries', false, true, '2026-05-29T08:08:16.250Z', '2026-05-29T08:08:16.250Z'),
('cmpqn3rsrags0hi0lcoeaipkk', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Lab Technician', 'Can receive samples and record grading results', false, true, '2026-05-29T08:08:16.250Z', '2026-05-29T08:08:16.250Z'),
('cmpqn3rsrwfvtbl0jna2e1mej', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Ground Operator', 'Can capture and process ground operations data', false, true, '2026-05-29T08:08:16.250Z', '2026-05-29T08:08:16.250Z'),
('cmpqn3rsrnqvpsdfqahufrhrf', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Viewer', 'Read-only access to reports and dashboards', false, true, '2026-05-29T08:08:16.250Z', '2026-05-29T08:08:16.250Z')
ON CONFLICT ("siteId", "name") DO NOTHING;
