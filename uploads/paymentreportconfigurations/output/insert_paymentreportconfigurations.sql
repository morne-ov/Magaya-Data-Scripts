-- Insert payment report configurations from: example_paymentreportconfigurations.csv
-- 4 configurations
-- WARNING: No unique constraint — re-running will insert duplicates.
--   Check existing data first: SELECT * FROM "PaymentReportConfiguration" WHERE "siteId" = '...';
-- Valid paymentType values: STANDARD, SPECIAL, PRICE_PER_TON, PRICE_PER_GRAM, FLAT_RATE
-- Valid transportMethod values: MILEAGE, AREA, NONE, FLAT_FEE_PERCENTAGE

INSERT INTO "PaymentReportConfiguration" ("id", "siteId", "paymentType", "transportMethod", "pricePerGram", "extractionEfficiency", "costs", "customerProfitPercentage", "ratePerTon", "ratePerGram", "fixedAmount", "createdAt", "updatedAt")
VALUES
('cmpqn3rzlyc44zhjuy6buhmiv', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'STANDARD', 'MILEAGE', 1540.00, 0.85, 120.00, 60.0, NULL, NULL, NULL, '2026-05-29T08:08:16.497Z', '2026-05-29T08:08:16.497Z'),
('cmpqn3rzljky8ctlh6c86vfns', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'SPECIAL', 'AREA', 1596.00, 0.87, 110.00, 62.0, NULL, NULL, NULL, '2026-05-29T08:08:16.497Z', '2026-05-29T08:08:16.497Z'),
('cmpqn3rzlocr2zd460uvrn9wu', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'PRICE_PER_TON', 'NONE', NULL, NULL, NULL, NULL, 850.00, NULL, NULL, '2026-05-29T08:08:16.497Z', '2026-05-29T08:08:16.497Z'),
('cmpqn3rzlzcb3mr5v37abi2c0', 'a1b2c3d4-e5f6-4789-a012-3456789abcde', 'FLAT_RATE', 'NONE', NULL, NULL, NULL, NULL, NULL, NULL, 1200.00, '2026-05-29T08:08:16.497Z', '2026-05-29T08:08:16.497Z');
