const fs = require('fs');
const path = require('path');

function cuid() {
  const timestamp = Date.now().toString(36);
  const rand = () => Math.random().toString(36).padEnd(10, '0').slice(2, 10);
  return 'c' + timestamp + rand() + rand();
}

const nullable = val => (val && val.trim() !== '' ? `'${val.replace(/'/g, "''")}'` : 'NULL');
const nullableInt = val => (val && val.trim() !== '' ? val.trim() : 'NULL');

const inputPath = path.join(__dirname, '../data/example_equipmentcompanies.csv');
const outputPath = path.join(__dirname, '../output/insert_equipmentcompanies.sql');

const csv = fs.readFileSync(inputPath, 'utf8');
const lines = csv.trim().split('\n').slice(1);

const now = new Date().toISOString();

const values = lines.map(line => {
  const parts              = line.trim().split(';');
  const name               = parts[0].replace(/'/g, "''");
  const companyType        = nullable(parts[1]);
  const businessType       = nullable(parts[2]);
  const natureOfBusiness   = nullable(parts[3]);
  const yearEstablished    = nullableInt(parts[4]);
  const registrationNumber = nullable(parts[5]);
  const tel                = nullable(parts[6]);
  const contactName        = nullable(parts[7]);
  const email              = nullable(parts[8]);
  const physicalAddress    = nullable(parts[9]);
  const siteId             = parts[10].trim();
  const id                 = cuid();
  return `('${id}', '${siteId}', '${name}', ${companyType}, ${businessType}, ${natureOfBusiness}, ${yearEstablished}, ${registrationNumber}, ${tel}, ${contactName}, ${email}, ${physicalAddress}, '${now}', '${now}')`;
});

const sql = `-- Insert equipment companies from: example_equipmentcompanies.csv
-- ${values.length} companies
-- Safe to re-run: ON CONFLICT DO NOTHING
-- Valid companyType values: INTERNAL, EXTERNAL
-- Valid businessType values: CORPORATE_LIMITED, PARTNERSHIP, OTHER
-- Valid natureOfBusiness values: TRANSPORTING, TRUCKING

INSERT INTO "EquipmentCompany" ("id", "siteId", "name", "companyType", "businessType", "natureOfBusiness", "yearEstablished", "registrationNumber", "tel", "contactName", "email", "physicalAddress", "createdAt", "updatedAt")
VALUES
${values.join(',\n')}
ON CONFLICT ("siteId", "name") DO NOTHING;
`;

fs.writeFileSync(outputPath, sql);
console.log(`Generated ${values.length} rows -> ${outputPath}`);
