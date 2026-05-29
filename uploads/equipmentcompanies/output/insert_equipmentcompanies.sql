-- Insert equipment companies from: example_equipmentcompanies.csv
-- 3 companies
-- Safe to re-run: ON CONFLICT DO NOTHING
-- Valid companyType values: INTERNAL, EXTERNAL
-- Valid businessType values: CORPORATE_LIMITED, PARTNERSHIP, OTHER
-- Valid natureOfBusiness values: TRANSPORTING, TRUCKING

INSERT INTO "EquipmentCompany" ("id", "siteId", "name", "companyType", "businessType", "natureOfBusiness", "yearEstablished", "registrationNumber", "tel", "contactName", "email", "physicalAddress", "createdAt", "updatedAt")
VALUES
('cmpqn3rwoxtv7sb0qxpuv29i1', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Rapid Haulage (Pty) Ltd', 'EXTERNAL', 'CORPORATE_LIMITED', 'TRANSPORTING', 2015, '2015/123456/07', '+27114445555', 'James Steyn', 'james@rapidhaulage.co.za', '12 Industrial Road, Johannesburg', '2026-05-29T08:08:16.392Z', '2026-05-29T08:08:16.392Z'),
('cmpqn3rwofswhv918fr7zpmfh', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Goldfields Transport CC', 'EXTERNAL', 'PARTNERSHIP', 'TRUCKING', 2008, '2008/654321/23', '+27183336666', 'Maria Venter', 'maria@goldfieldscc.co.za', '7 Mine Road, Welkom', '2026-05-29T08:08:16.392Z', '2026-05-29T08:08:16.392Z'),
('cmpqn3rwo5c2qe4avi2w8zzjo', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Site Logistics Internal', 'INTERNAL', 'CORPORATE_LIMITED', 'TRANSPORTING', 2010, '2010/111222/07', '+27561112222', 'Henry Kruger', 'henry@sitelogistics.co.za', 'On-site, Amatola Mine', '2026-05-29T08:08:16.392Z', '2026-05-29T08:08:16.392Z')
ON CONFLICT ("siteId", "name") DO NOTHING;
