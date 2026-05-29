const fs = require('fs');
const path = require('path');

function cuid() {
  const timestamp = Date.now().toString(36);
  const rand = () => Math.random().toString(36).padEnd(10, '0').slice(2, 10);
  return 'c' + timestamp + rand() + rand();
}

const inputPath = path.join(__dirname, '../data/Amatola Sands Ground Bays.csv');
const outputPath = path.join(__dirname, '../output/insert_loadbays.sql');

const csv = fs.readFileSync(inputPath, 'utf8');
const lines = csv.trim().split('\n').slice(1);

const now = new Date().toISOString();

const values = lines.map(line => {
  const parts = line.trim().split(';');
  const name = parts[0].replace(/'/g, "''");
  const maxTonnage = parts[1];
  const maxLoads = parts[2];
  const siteId = parts[3];
  const id = cuid();
  return `('${id}', '${siteId}', '${name}', ${maxTonnage}, ${maxLoads}, 'AVAILABLE', '${now}', '${now}')`;
});

const sql = `-- Insert loadbays from: Amatola Sands Ground Bays.csv
-- ${values.length} bays for siteId: a1b2c3d4-e5f6-4789-a012-3456789abcde
-- Safe to re-run: ON CONFLICT DO NOTHING

INSERT INTO "Loadbay" ("id", "siteId", "name", "maxTonnage", "maxNumberOfLoads", "status", "createdAt", "updatedAt")
VALUES
${values.join(',\n')}
ON CONFLICT ("siteId", "name") DO NOTHING;
`;

fs.writeFileSync(outputPath, sql);
console.log(`Generated ${values.length} rows -> ${outputPath}`);
