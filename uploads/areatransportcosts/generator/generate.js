const fs = require('fs');
const path = require('path');

function cuid() {
  const timestamp = Date.now().toString(36);
  const rand = () => Math.random().toString(36).padEnd(10, '0').slice(2, 10);
  return 'c' + timestamp + rand() + rand();
}

const inputPath = path.join(__dirname, '../data/example_areatransportcosts.csv');
const outputPath = path.join(__dirname, '../output/insert_areatransportcosts.sql');

const csv = fs.readFileSync(inputPath, 'utf8');
const lines = csv.trim().split('\n').slice(1);

const now = new Date().toISOString();

const values = lines.map(line => {
  const parts         = line.trim().split(';');
  const areaName      = parts[0].replace(/'/g, "''");
  const transportCost = parts[1].trim();
  const siteId        = parts[2].trim();
  const id            = cuid();

  // areaId resolved at runtime via SubArea name lookup
  const areaIdExpr = `(SELECT id FROM "SubArea" WHERE "siteId" = '${siteId}' AND name = '${areaName}')`;

  return `('${id}', '${siteId}', ${areaIdExpr}, '${areaName}', ${transportCost}, '${now}', '${now}')`;
});

const sql = `-- Insert area transport costs from: example_areatransportcosts.csv
-- ${values.length} areas
-- Requires: SubArea rows must exist before running this script
-- WARNING: No unique constraint — re-running will insert duplicates.
--   Check existing data first: SELECT * FROM "AreaTransportCosts" WHERE "siteId" = '...';

INSERT INTO "AreaTransportCosts" ("id", "siteId", "areaId", "areaName", "transportCost", "createdAt", "updatedAt")
VALUES
${values.join(',\n')};
`;

fs.writeFileSync(outputPath, sql);
console.log(`Generated ${values.length} rows -> ${outputPath}`);
