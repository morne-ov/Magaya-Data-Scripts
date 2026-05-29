const fs = require('fs');
const path = require('path');

function cuid() {
  const timestamp = Date.now().toString(36);
  const rand = () => Math.random().toString(36).padEnd(10, '0').slice(2, 10);
  return 'c' + timestamp + rand() + rand();
}

const inputPath = path.join(__dirname, '../data/example_siteextractionefficiency.csv');
const outputPath = path.join(__dirname, '../output/insert_siteextractionefficiency.sql');

const csv = fs.readFileSync(inputPath, 'utf8');
const lines = csv.trim().split('\n').slice(1);

const now = new Date().toISOString();

const values = lines.map(line => {
  const parts               = line.trim().split(';');
  const siteName            = parts[0].replace(/'/g, "''");
  const extractionEfficiency = parts[1].trim();
  const effectiveDate       = parts[2].trim();
  const siteId              = parts[3].trim();
  const id                  = cuid();
  return `('${id}', '${siteId}', '${siteName}', ${extractionEfficiency}, '${effectiveDate}', 'REPLACE_WITH_USER_ID', 'REPLACE_WITH_USER_ID', '${now}', '${now}')`;
});

const sql = `-- Insert site extraction efficiency from: example_siteextractionefficiency.csv
-- ${values.length} records
-- WARNING: No unique constraint — re-running will insert duplicates.
--   Check existing data first: SELECT * FROM "SiteExtractionEfficiency" WHERE "siteId" = '...';
--
-- IMPORTANT: Replace 'REPLACE_WITH_USER_ID' with the actual user ID before running.
--   Find it with: SELECT id FROM "User" WHERE email = 'your-admin@example.com';

INSERT INTO "SiteExtractionEfficiency" ("id", "siteId", "siteName", "extractionEfficiency", "effectiveDate", "createdById", "updatedById", "createdAt", "updatedAt")
VALUES
${values.join(',\n')};
`;

fs.writeFileSync(outputPath, sql);
console.log(`Generated ${values.length} rows -> ${outputPath}`);
