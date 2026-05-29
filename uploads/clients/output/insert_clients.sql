-- Insert clients from: example_clients.csv
-- 6 clients
-- Safe to re-run: ON CONFLICT DO NOTHING
-- Multiple contactNumber/whatsapp/email values can be pipe-separated in the CSV e.g. "+27821234567|+27829999999"

INSERT INTO "Client" ("id", "siteId", "firstName", "lastName", "middleName", "idNumber", "address", "contactNumber", "whatsapp", "email", "artisanalMinerId", "potentialClient", "status", "createdAt", "updatedAt")
VALUES
('cmpqmst43a957bjrss71czax4', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'John', 'Dube', NULL, '8501015026083', '12 Shaft Road, Amatola', '{"+27821234567"}', '{"+27821234567"}', '{"john.dube@example.com"}', 'AM-001', false, 'ACTIVE', '2026-05-29T07:59:44.738Z', '2026-05-29T07:59:44.738Z'),
('cmpqmst43e5ha3lsex55k4g61', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Mary', 'Nkosi', 'Jane', '9203204567089', '45 Mine View, Welkom', '{"+27834567890"}', '{"+27834567890"}', '{"mary.nkosi@example.com"}', 'AM-002', false, 'ACTIVE', '2026-05-29T07:59:44.738Z', '2026-05-29T07:59:44.738Z'),
('cmpqmst43coeu47ro6ywfnd7q', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Peter', 'Sithole', NULL, '7812105034082', '7 Gold Street, Johannesburg', '{"+27761112233"}', '{}', '{"peter.sithole@example.com"}', 'AM-003', false, 'ACTIVE', '2026-05-29T07:59:44.738Z', '2026-05-29T07:59:44.738Z'),
('cmpqmst43texu87ysgcc6pgib', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Sarah', 'Mokoena', 'Anne', '0001014034081', '22 River Lane, Orkney', '{"+27729998877"}', '{"+27729998877"}', '{}', 'AM-004', false, 'ACTIVE', '2026-05-29T07:59:44.738Z', '2026-05-29T07:59:44.738Z'),
('cmpqmst43hczr56o5lmigaht7', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'David', 'Zulu', NULL, '8807086543087', '3 Reef Road, Klerksdorp', '{"+27853334455"}', '{"+27853334455"}', '{"david.zulu@example.com"}', 'AM-005', false, 'ACTIVE', '2026-05-29T07:59:44.738Z', '2026-05-29T07:59:44.738Z'),
('cmpqmst43m7e5e7x5wqofhr3b', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Thandi', 'Khumalo', 'Rose', '9505145678083', '88 Diamond Ave, Potchefstroom', '{"+27812223344"}', '{}', '{"thandi.khumalo@example.com"}', 'AM-006', false, 'INACTIVE', '2026-05-29T07:59:44.738Z', '2026-05-29T07:59:44.738Z')
ON CONFLICT ("siteId", "idNumber") DO NOTHING;
