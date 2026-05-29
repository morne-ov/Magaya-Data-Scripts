const fs = require('fs');
const path = require('path');

function cuid() {
  const timestamp = Date.now().toString(36);
  const rand = () => Math.random().toString(36).padEnd(10, '0').slice(2, 10);
  return 'c' + timestamp + rand() + rand();
}

const inputPath = path.join(__dirname, '../data/example_arearoyaltyconfigurations.csv');
const outputPath = path.join(__dirname, '../output/insert_arearoyaltyconfigurations.sql');

const csv = fs.readFileSync(inputPath, 'utf8');
const lines = csv.trim().split('\n').slice(1);

const now = new Date().toISOString();

const values = lines.map(line => {
  const parts             = line.trim().split(';');
  const areaName          = parts[0].replace(/'/g, "''");
  const royaltyPercentage = parts[1].trim();
  const calculationBasis  = parts[2].trim();
  const siteId            = parts[3].trim();
  const id                = cuid();

  const areaIdExpr = `(SELECT id FROM "SubArea" WHERE "siteId" = '${siteId}' AND name = '${areaName}')`;

  return `('${id}', '${siteId}', ${areaIdExpr}, '${areaName}', ${royaltyPercentage}, '${calculationBasis}', 'REPLACE_WITH_USER_ID', 'REPLACE_WITH_USER_ID', '${now}', '${now}')`;
});

const sql = `-- Insert area royalty configurations from: example_arearoyaltyconfigurations.csv
-- ${values.length} areas
-- Requires: SubArea rows must exist before running this script
-- WARNING: No unique constraint — re-running will insert duplicates.
--   Check existing data first: SELECT * FROM "AreaRoyaltyConfiguration" WHERE "siteId" = '...';
--
-- IMPORTANT: Replace 'REPLACE_WITH_USER_ID' with the actual user ID before running.
--   Find it with: SELECT id FROM "User" WHERE email = 'your-admin@example.com';
-- Valid calculationBasis values: tonnage, load_value

INSERT INTO "AreaRoyaltyConfiguration" ("id", "siteId", "areaId", "areaName", "royaltyPercentage", "calculationBasis", "createdById", "updatedById", "createdAt", "updatedAt")
VALUES
${values.join(',\n')};
`;

fs.writeFileSync(outputPath, sql);
console.log(`Generated ${values.length} rows -> ${outputPath}`);
