const fs = require('fs');
const path = require('path');

function cuid() {
  const timestamp = Date.now().toString(36);
  const rand = () => Math.random().toString(36).padEnd(10, '0').slice(2, 10);
  return 'c' + timestamp + rand() + rand();
}

const nullableNum = val => (val && val.trim() !== '' ? val.trim() : 'NULL');
const nullable = val => (val && val.trim() !== '' ? `'${val.replace(/'/g, "''")}'` : 'NULL');

const inputPath = path.join(__dirname, '../data/example_paymentreportconfigurations.csv');
const outputPath = path.join(__dirname, '../output/insert_paymentreportconfigurations.sql');

const csv = fs.readFileSync(inputPath, 'utf8');
const lines = csv.trim().split('\n').slice(1);

const now = new Date().toISOString();

const values = lines.map(line => {
  const parts                  = line.trim().split(';');
  const paymentType            = parts[0].trim();
  const transportMethod        = nullable(parts[1]);
  const pricePerGram           = nullableNum(parts[2]);
  const extractionEfficiency   = nullableNum(parts[3]);
  const costs                  = nullableNum(parts[4]);
  const customerProfitPercentage = nullableNum(parts[5]);
  const ratePerTon             = nullableNum(parts[6]);
  const ratePerGram            = nullableNum(parts[7]);
  const fixedAmount            = nullableNum(parts[8]);
  const siteId                 = parts[9].trim();
  const id                     = cuid();
  return `('${id}', '${siteId}', '${paymentType}', ${transportMethod}, ${pricePerGram}, ${extractionEfficiency}, ${costs}, ${customerProfitPercentage}, ${ratePerTon}, ${ratePerGram}, ${fixedAmount}, '${now}', '${now}')`;
});

const sql = `-- Insert payment report configurations from: example_paymentreportconfigurations.csv
-- ${values.length} configurations
-- WARNING: No unique constraint — re-running will insert duplicates.
--   Check existing data first: SELECT * FROM "PaymentReportConfiguration" WHERE "siteId" = '...';
-- Valid paymentType values: STANDARD, SPECIAL, PRICE_PER_TON, PRICE_PER_GRAM, FLAT_RATE
-- Valid transportMethod values: MILEAGE, AREA, NONE, FLAT_FEE_PERCENTAGE

INSERT INTO "PaymentReportConfiguration" ("id", "siteId", "paymentType", "transportMethod", "pricePerGram", "extractionEfficiency", "costs", "customerProfitPercentage", "ratePerTon", "ratePerGram", "fixedAmount", "createdAt", "updatedAt")
VALUES
${values.join(',\n')};
`;

fs.writeFileSync(outputPath, sql);
console.log(`Generated ${values.length} rows -> ${outputPath}`);
