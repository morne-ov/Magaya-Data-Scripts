-- Insert clusters from: example_clusters.csv
-- 6 clusters
-- Safe to re-run: ON CONFLICT DO NOTHING

INSERT INTO "Cluster" ("id", "siteId", "name", "createdAt", "updatedAt")
VALUES
('cmpqmst2yt0k7s70ego0le0hf', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Alpha Cluster', '2026-05-29T07:59:44.697Z', '2026-05-29T07:59:44.697Z'),
('cmpqmst2yp4j7e21kyzm89l3x', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Beta Cluster', '2026-05-29T07:59:44.697Z', '2026-05-29T07:59:44.697Z'),
('cmpqmst2ypeac1dwit7j75qbm', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Gamma Cluster', '2026-05-29T07:59:44.697Z', '2026-05-29T07:59:44.697Z'),
('cmpqmst2ygji4h4h458tkj2zp', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Delta Cluster', '2026-05-29T07:59:44.697Z', '2026-05-29T07:59:44.697Z'),
('cmpqmst2ylkxxfpieoqmdgn27', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Epsilon Cluster', '2026-05-29T07:59:44.697Z', '2026-05-29T07:59:44.697Z'),
('cmpqmst2y0zgu2zbwo9qnz3r8', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'Zeta Cluster', '2026-05-29T07:59:44.697Z', '2026-05-29T07:59:44.697Z')
ON CONFLICT ("siteId", "name") DO NOTHING;
