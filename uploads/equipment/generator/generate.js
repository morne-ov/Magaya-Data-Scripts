const fs = require('fs');
const path = require('path');

function cuid() {
  const timestamp = Date.now().toString(36);
  const rand = () => Math.random().toString(36).padEnd(10, '0').slice(2, 10);
  return 'c' + timestamp + rand() + rand();
}

const nullable = val => (val && val.trim() !== '' ? `'${val.replace(/'/g, "''")}'` : 'NULL');
const nullableNum = val => (val && val.trim() !== '' ? val.trim() : 'NULL');

const inputPath = path.join(__dirname, '../data/example_equipment.csv');
const outputPath = path.join(__dirname, '../output/insert_equipment.sql');

const csv = fs.readFileSync(inputPath, 'utf8');
const lines = csv.trim().split('\n').slice(1);

const now = new Date().toISOString();

const values = lines.map(line => {
  const parts = line.trim().split(';');
  const fleetId                    = nullable(parts[0]);
  const type                       = nullable(parts[1]);
  const make                       = nullable(parts[2]);
  const model                      = nullable(parts[3]);
  const year                       = nullableNum(parts[4]);
  const registrationNumber         = nullable(parts[5]);
  const vinSerialId                = nullable(parts[6]);
  const engineCapacity             = nullable(parts[7]);
  const fuelConsumption            = nullableNum(parts[8]);
  const fuelConsumptionUnit        = nullable(parts[9]);
  const loadingCarryingCapacityTonnes = nullableNum(parts[10]);
  const location                   = nullable(parts[11]);
  const status                     = parts[12] && parts[12].trim() !== '' ? parts[12].trim() : 'AVAILABLE';
  const description                = nullable(parts[13]);
  const siteId                     = parts[14];
  const id                         = cuid();

  return `('${id}', '${siteId}', ${fleetId}, ${type}, ${make}, ${model}, ${year}, ${registrationNumber}, ${vinSerialId}, ${engineCapacity}, ${fuelConsumption}, ${fuelConsumptionUnit}, ${loadingCarryingCapacityTonnes}, ${location}, '${status}', ${description}, '${now}', '${now}')`;
});

const sql = `-- Insert equipment from: example_equipment.csv
-- ${values.length} equipment records
-- Safe to re-run: ON CONFLICT DO NOTHING
-- Valid type values: BUS, COMPACTOR, CRUSHER, DOZER, EXCAVATOR, FORKLIFT, FUEL_BOWSER, FUEL_TANKER,
--   GENERATOR, GRADER, LOADER, MILL, MOTORBIKE, OTHER, POOL, TIPPER, TLB, TRACTOR, WATER_BOWSER, WATER_TANKER
-- Valid location values: AMATOLA, WALDEN, OTHER
-- Valid status values: AVAILABLE, IN_TRANSIT, IN_USE, IN_OPERATION, UNDER_MAINTENANCE, OUT_OF_SERVICE
-- Valid fuelConsumptionUnit values: LITRES_PER_KM, LITRES_PER_HOUR

INSERT INTO "Equipment" ("id", "siteId", "fleetId", "type", "make", "model", "year", "registrationNumber", "vinSerialId", "engineCapacity", "fuelConsumption", "fuelConsumptionUnit", "loadingCarryingCapacityTonnes", "location", "status", "description", "createdAt", "updatedAt")
VALUES
${values.join(',\n')}
ON CONFLICT ("siteId", "fleetId") DO NOTHING;
`;

fs.writeFileSync(outputPath, sql);
console.log(`Generated ${values.length} rows -> ${outputPath}`);
