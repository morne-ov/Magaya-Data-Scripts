-- Insert equipment from: example_equipment.csv
-- 8 equipment records
-- Safe to re-run: ON CONFLICT DO NOTHING
-- Valid type values: BUS, COMPACTOR, CRUSHER, DOZER, EXCAVATOR, FORKLIFT, FUEL_BOWSER, FUEL_TANKER,
--   GENERATOR, GRADER, LOADER, MILL, MOTORBIKE, OTHER, POOL, TIPPER, TLB, TRACTOR, WATER_BOWSER, WATER_TANKER
-- Valid location values: AMATOLA, WALDEN, OTHER
-- Valid status values: AVAILABLE, IN_TRANSIT, IN_USE, IN_OPERATION, UNDER_MAINTENANCE, OUT_OF_SERVICE
-- Valid fuelConsumptionUnit values: LITRES_PER_KM, LITRES_PER_HOUR

INSERT INTO "Equipment" ("id", "siteId", "fleetId", "type", "make", "model", "year", "registrationNumber", "vinSerialId", "engineCapacity", "fuelConsumption", "fuelConsumptionUnit", "loadingCarryingCapacityTonnes", "location", "status", "description", "createdAt", "updatedAt")
VALUES
('cmpqmst4l50ljimgwmlma320g', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'FL-001', 'TIPPER', 'Volvo', 'FH16', 2020, 'ABC123GP', 'VIN1234567890001', '16L', 0.35, 'LITRES_PER_KM', 30, 'AMATOLA', 'AVAILABLE', '30-ton tipper for ore transport', '2026-05-29T07:59:44.756Z', '2026-05-29T07:59:44.756Z'),
('cmpqmst4lvgyecg3sf02ouy2y', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'FL-002', 'TIPPER', 'Mercedes-Benz', 'Actros 2645', 2019, 'DEF456GP', 'VIN1234567890002', '15L', 0.38, 'LITRES_PER_KM', 28, 'AMATOLA', 'AVAILABLE', '28-ton tipper for sands', '2026-05-29T07:59:44.756Z', '2026-05-29T07:59:44.756Z'),
('cmpqmst4le6xom29oxc8a6rnj', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'FL-003', 'EXCAVATOR', 'Caterpillar', '330', 2021, 'GHI789GP', 'VIN1234567890003', '9L', 12, 'LITRES_PER_HOUR', NULL, 'AMATOLA', 'AVAILABLE', 'Cat 330 excavator', '2026-05-29T07:59:44.756Z', '2026-05-29T07:59:44.756Z'),
('cmpqmst4l7o9nktvo5ygy34no', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'FL-004', 'LOADER', 'Komatsu', 'WA380', 2018, 'JKL012NW', 'VIN1234567890004', '8L', 10, 'LITRES_PER_HOUR', 5, 'WALDEN', 'AVAILABLE', 'Front-end loader', '2026-05-29T07:59:44.756Z', '2026-05-29T07:59:44.756Z'),
('cmpqmst4lkhg0uryoima20kq8', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'FL-005', 'DOZER', 'Caterpillar', 'D6T', 2022, 'MNO345NW', 'VIN1234567890005', '9L', 14, 'LITRES_PER_HOUR', NULL, 'WALDEN', 'AVAILABLE', 'Medium dozer for dump clearance', '2026-05-29T07:59:44.756Z', '2026-05-29T07:59:44.756Z'),
('cmpqmst4l8mznm5g0721jumj1', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'FL-006', 'WATER_BOWSER', 'Hino', '500', 2017, 'PQR678GP', 'VIN1234567890006', '7L', 0.28, 'LITRES_PER_KM', 18, 'AMATOLA', 'AVAILABLE', '18kl water bowser for dust suppression', '2026-05-29T07:59:44.756Z', '2026-05-29T07:59:44.756Z'),
('cmpqmst4lzxdvkdgqd7x1z7t6', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'FL-007', 'TIPPER', 'Scania', 'R580', 2021, 'STU901GP', 'VIN1234567890007', '16L', 0.36, 'LITRES_PER_KM', 34, 'AMATOLA', 'UNDER_MAINTENANCE', '34-ton tipper - engine service', '2026-05-29T07:59:44.756Z', '2026-05-29T07:59:44.756Z'),
('cmpqmst4ly3p2828meiameusp', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'FL-008', 'GRADER', 'Caterpillar', '140M', 2019, 'VWX234NW', 'VIN1234567890008', '7L', 11, 'LITRES_PER_HOUR', NULL, 'WALDEN', 'AVAILABLE', 'Road grader for haul road maintenance', '2026-05-29T07:59:44.756Z', '2026-05-29T07:59:44.756Z')
ON CONFLICT ("siteId", "fleetId") DO NOTHING;
