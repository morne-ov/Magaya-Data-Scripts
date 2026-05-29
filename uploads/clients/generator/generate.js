const fs = require('fs');
const path = require('path');

function cuid() {
  const timestamp = Date.now().toString(36);
  const rand = () => Math.random().toString(36).padEnd(10, '0').slice(2, 10);
  return 'c' + timestamp + rand() + rand();
}

const nullable = val => (val && val.trim() !== '' ? `'${val.replace(/'/g, "''")}'` : 'NULL');

// Converts a semicolon-free comma/pipe separated value into a Postgres text[] literal
// CSV stores a single value per cell; use | to separate multiple values e.g. "+27821234567|+27829999999"
const toArray = val => {
  if (!val || val.trim() === '') return "'{}'";
  const items = val.split('|').map(v => `"${v.trim().replace(/"/g, '\\"')}"`);
  return `'{${items.join(',')}}'`;
};

const inputPath = path.join(__dirname, '../data/example_clients.csv');
const outputPath = path.join(__dirname, '../output/insert_clients.sql');

const csv = fs.readFileSync(inputPath, 'utf8');
const lines = csv.trim().split('\n').slice(1);

const now = new Date().toISOString();

const values = lines.map(line => {
  const parts = line.trim().split(';');
  const firstName     = parts[0].replace(/'/g, "''");
  const lastName      = parts[1].replace(/'/g, "''");
  const middleName    = nullable(parts[2]);
  const idNumber      = nullable(parts[3]);
  const address       = nullable(parts[4]);
  const contactNumber = toArray(parts[5]);
  const whatsapp      = toArray(parts[6]);
  const email         = toArray(parts[7]);
  const artisanalMinerId = nullable(parts[8]);
  const status        = parts[9] && parts[9].trim() !== '' ? parts[9].trim() : 'ACTIVE';
  const siteId        = parts[10];
  const id            = cuid();

  return `('${id}', '${siteId}', '${firstName}', '${lastName}', ${middleName}, ${idNumber}, ${address}, ${contactNumber}, ${whatsapp}, ${email}, ${artisanalMinerId}, false, '${status}', '${now}', '${now}')`;
});

const sql = `-- Insert clients from: example_clients.csv
-- ${values.length} clients
-- Safe to re-run: ON CONFLICT DO NOTHING
-- Multiple contactNumber/whatsapp/email values can be pipe-separated in the CSV e.g. "+27821234567|+27829999999"

INSERT INTO "Client" ("id", "siteId", "firstName", "lastName", "middleName", "idNumber", "address", "contactNumber", "whatsapp", "email", "artisanalMinerId", "potentialClient", "status", "createdAt", "updatedAt")
VALUES
${values.join(',\n')}
ON CONFLICT ("siteId", "idNumber") DO NOTHING;
`;

fs.writeFileSync(outputPath, sql);
console.log(`Generated ${values.length} rows -> ${outputPath}`);
