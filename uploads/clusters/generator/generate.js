const fs = require('fs');
const path = require('path');

function cuid() {
  const timestamp = Date.now().toString(36);
  const rand = () => Math.random().toString(36).padEnd(10, '0').slice(2, 10);
  return 'c' + timestamp + rand() + rand();
}

const inputPath = path.join(__dirname, '../data/example_clusters.csv');
const outputPath = path.join(__dirname, '../output/insert_clusters.sql');

const csv = fs.readFileSync(inputPath, 'utf8');
const lines = csv.trim().split('\n').slice(1);

const now = new Date().toISOString();

const values = lines.map(line => {
  const parts = line.trim().split(';');
  const name = parts[0].replace(/'/g, "''");
  const siteId = parts[1];
  const id = cuid();
  return `('${id}', '${siteId}', '${name}', '${now}', '${now}')`;
});

const sql = `-- Insert clusters from: example_clusters.csv
-- ${values.length} clusters
-- Safe to re-run: ON CONFLICT DO NOTHING

INSERT INTO "Cluster" ("id", "siteId", "name", "createdAt", "updatedAt")
VALUES
${values.join(',\n')}
ON CONFLICT ("siteId", "name") DO NOTHING;
`;

fs.writeFileSync(outputPath, sql);
console.log(`Generated ${values.length} rows -> ${outputPath}`);
