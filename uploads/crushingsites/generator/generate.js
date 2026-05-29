const fs = require('fs');
const path = require('path');

function cuid() {
  const timestamp = Date.now().toString(36);
  const rand = () => Math.random().toString(36).padEnd(10, '0').slice(2, 10);
  return 'c' + timestamp + rand() + rand();
}

const inputPath = path.join(__dirname, '../data/example_crushingsites.csv');
const outputPath = path.join(__dirname, '../output/insert_crushingsites.sql');

const csv = fs.readFileSync(inputPath, 'utf8');
const lines = csv.trim().split('\n').slice(1);

const now = new Date().toISOString();

const values = lines.map(line => {
  const parts  = line.trim().split(';');
  const name   = parts[0].replace(/'/g, "''");
  const siteId = parts[1].trim();
  const id     = cuid();
  return `('${id}', '${siteId}', '${name}', '${now}', '${now}')`;
});

const sql = `-- Insert crushing sites from: example_crushingsites.csv
-- ${values.length} crushing sites
-- Safe to re-run: ON CONFLICT DO NOTHING

INSERT INTO "CrushingSite" ("id", "siteId", "name", "createdAt", "updatedAt")
VALUES
${values.join(',\n')}
ON CONFLICT ("siteId", "name") DO NOTHING;
`;

fs.writeFileSync(outputPath, sql);
console.log(`Generated ${values.length} rows -> ${outputPath}`);
