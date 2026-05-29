const fs = require('fs');
const path = require('path');

function cuid() {
  const timestamp = Date.now().toString(36);
  const rand = () => Math.random().toString(36).padEnd(10, '0').slice(2, 10);
  return 'c' + timestamp + rand() + rand();
}

const nullable = val => (val && val.trim() !== '' ? `'${val.replace(/'/g, "''")}'` : 'NULL');

const inputPath = path.join(__dirname, '../data/example_prefixes.csv');
const outputPath = path.join(__dirname, '../output/insert_prefixes.sql');

const csv = fs.readFileSync(inputPath, 'utf8');
const lines = csv.trim().split('\n').slice(1);

const now = new Date().toISOString();

const values = lines.map(line => {
  const parts               = line.trim().split(';');
  const code                = parts[0].replace(/'/g, "''");
  const type                = parts[1].trim();
  const description         = nullable(parts[2]);
  const status              = parts[3] && parts[3].trim() !== '' ? parts[3].trim() : 'ACTIVE';
  const preferredProductType = nullable(parts[4]);
  const siteId              = parts[5].trim();
  const id                  = cuid();
  return `('${id}', '${siteId}', '${code}', '${type}', ${description}, '${status}', ${preferredProductType}, '${now}', '${now}')`;
});

const sql = `-- Insert prefixes from: example_prefixes.csv
-- ${values.length} prefixes
-- Safe to re-run: ON CONFLICT DO NOTHING
-- Valid type values: INTERNAL, EXTERNAL
-- Valid status values: ACTIVE, INACTIVE
-- Valid preferredProductType values: AFTER_MILL_SANDS, DUMP, PARTNER_SANDS, MAIN_SHAFT,
--   OTHER_ORES, OTHER_SANDS, PARTNER_ORES, PARTNER_MILLING

INSERT INTO "Prefix" ("id", "siteId", "code", "type", "description", "status", "preferredProductType", "createdAt", "updatedAt")
VALUES
${values.join(',\n')}
ON CONFLICT ("siteId", "code") DO NOTHING;
`;

fs.writeFileSync(outputPath, sql);
console.log(`Generated ${values.length} rows -> ${outputPath}`);
