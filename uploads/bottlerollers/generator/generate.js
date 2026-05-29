const fs = require('fs');
const path = require('path');

function cuid() {
  const timestamp = Date.now().toString(36);
  const rand = () => Math.random().toString(36).padEnd(10, '0').slice(2, 10);
  return 'c' + timestamp + rand() + rand();
}

const inputPath = path.join(__dirname, '../data/example_bottlerollers.csv');
const outputPath = path.join(__dirname, '../output/insert_bottlerollers.sql');

const csv = fs.readFileSync(inputPath, 'utf8');
const lines = csv.trim().split('\n').slice(1);

const now = new Date().toISOString();

const values = lines.map(line => {
  const parts        = line.trim().split(';');
  const rollerNumber = parts[0].replace(/'/g, "''");
  const siteId       = parts[1].trim();
  const id           = cuid();
  return `('${id}', '${siteId}', '${rollerNumber}', 'IDLE', '${now}', '${now}')`;
});

const sql = `-- Insert bottle rollers from: example_bottlerollers.csv
-- ${values.length} bottle rollers
-- WARNING: No unique constraint on BottleRoller — re-running will insert duplicates.
--   Check existing data first: SELECT * FROM "BottleRoller" WHERE "siteId" = '...';

INSERT INTO "BottleRoller" ("id", "siteId", "rollerNumber", "status", "createdAt", "updatedAt")
VALUES
${values.join(',\n')};
`;

fs.writeFileSync(outputPath, sql);
console.log(`Generated ${values.length} rows -> ${outputPath}`);
