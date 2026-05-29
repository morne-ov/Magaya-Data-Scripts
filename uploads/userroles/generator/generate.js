const fs = require('fs');
const path = require('path');

function cuid() {
  const timestamp = Date.now().toString(36);
  const rand = () => Math.random().toString(36).padEnd(10, '0').slice(2, 10);
  return 'c' + timestamp + rand() + rand();
}

const nullable = val => (val && val.trim() !== '' ? `'${val.replace(/'/g, "''")}'` : 'NULL');

const inputPath = path.join(__dirname, '../data/example_userroles.csv');
const outputPath = path.join(__dirname, '../output/insert_userroles.sql');

const csv = fs.readFileSync(inputPath, 'utf8');
const lines = csv.trim().split('\n').slice(1);

const now = new Date().toISOString();

const values = lines.map(line => {
  const parts = line.trim().split(';');
  const name        = parts[0].replace(/'/g, "''");
  const description = nullable(parts[1]);
  const isSystem    = parts[2].trim() === 'true' ? 'true' : 'false';
  const isActive    = parts[3].trim() === 'true' ? 'true' : 'false';
  const siteId      = parts[4].trim();
  const id          = cuid();
  return `('${id}', '${siteId}', '${name}', ${description}, ${isSystem}, ${isActive}, '${now}', '${now}')`;
});

const sql = `-- Insert user roles from: example_userroles.csv
-- ${values.length} roles
-- Safe to re-run: ON CONFLICT DO NOTHING

INSERT INTO "UserRole" ("id", "siteId", "name", "description", "isSystem", "isActive", "createdAt", "updatedAt")
VALUES
${values.join(',\n')}
ON CONFLICT ("siteId", "name") DO NOTHING;
`;

fs.writeFileSync(outputPath, sql);
console.log(`Generated ${values.length} rows -> ${outputPath}`);
