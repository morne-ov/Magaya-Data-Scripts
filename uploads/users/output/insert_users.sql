-- Insert users from: example_users.csv
-- 6 users
-- Requires: UserRole rows must exist before running this script
-- Passwords are NOT set here — users must set their password via the setup token flow
-- Safe to re-run: ON CONFLICT (siteId, email) DO NOTHING

INSERT INTO "User" ("id", "siteId", "firstName", "lastName", "email", "contactNumber", "roleId", "status", "createdAt", "updatedAt")
VALUES
('cmpqn3rtbeqnj8d3avo1dd65y', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Alice', 'Botha', 'alice.botha@example.com', '+27821110001', (SELECT id FROM "UserRole" WHERE "siteId" = 'a1b2c3d4-e5f6-4789-a012-3456789abcde' AND name = 'Admin'), 'ACTIVE', '2026-05-29T08:08:16.270Z', '2026-05-29T08:08:16.270Z'),
('cmpqn3rtbtxsqir6f5pfp44gn', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Brian', 'Dlamini', 'brian.dlamini@example.com', '+27821110002', (SELECT id FROM "UserRole" WHERE "siteId" = 'a1b2c3d4-e5f6-4789-a012-3456789abcde' AND name = 'Supervisor'), 'ACTIVE', '2026-05-29T08:08:16.270Z', '2026-05-29T08:08:16.270Z'),
('cmpqn3rtbpv86nrz0k5idpmt2', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Carol', 'Ferreira', 'carol.ferreira@example.com', '+27821110003', (SELECT id FROM "UserRole" WHERE "siteId" = 'a1b2c3d4-e5f6-4789-a012-3456789abcde' AND name = 'Agent'), 'ACTIVE', '2026-05-29T08:08:16.270Z', '2026-05-29T08:08:16.270Z'),
('cmpqn3rtbazt8v296u2cm49j4', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Daniel', 'Govender', 'daniel.govender@example.com', '+27821110004', (SELECT id FROM "UserRole" WHERE "siteId" = 'a1b2c3d4-e5f6-4789-a012-3456789abcde' AND name = 'Lab Technician'), 'ACTIVE', '2026-05-29T08:08:16.270Z', '2026-05-29T08:08:16.270Z'),
('cmpqn3rtb81j2c9pgjohqi5nw', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Elna', 'Hartmann', 'elna.hartmann@example.com', '+27821110005', (SELECT id FROM "UserRole" WHERE "siteId" = 'a1b2c3d4-e5f6-4789-a012-3456789abcde' AND name = 'Ground Operator'), 'ACTIVE', '2026-05-29T08:08:16.270Z', '2026-05-29T08:08:16.270Z'),
('cmpqn3rtbv3q7tqjdwa7f642u', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Frank', 'Jacobs', 'frank.jacobs@example.com', '+27821110006', (SELECT id FROM "UserRole" WHERE "siteId" = 'a1b2c3d4-e5f6-4789-a012-3456789abcde' AND name = 'Viewer'), 'INACTIVE', '2026-05-29T08:08:16.270Z', '2026-05-29T08:08:16.270Z')
ON CONFLICT ("siteId", "email") DO NOTHING;
