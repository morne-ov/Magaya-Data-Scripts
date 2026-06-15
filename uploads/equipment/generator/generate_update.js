const fs = require('fs');
const path = require('path');

const REPO_ROOT = path.join(__dirname, '../../..');
const DATA_DIR = path.join(REPO_ROOT, 'equipment_updates');
const OUTPUT_DIR = path.join(DATA_DIR, 'output');

const UPDATED_CSV = path.join(REPO_ROOT, 'Updated-Table 1.csv');
const DB_CSV = path.join(DATA_DIR, 'equipment.csv');
const COMPANIES_CSV = path.join(DATA_DIR, 'equipmentCompany.csv');

const PREVIEW_SQL = path.join(OUTPUT_DIR, 'preview_equipment_updates.sql');
const PREVIEW_CHANGES_SQL = path.join(OUTPUT_DIR, 'preview_equipment_changes.sql');
const PREVIEW_CHANGES_LIVE_SQL = path.join(OUTPUT_DIR, 'preview_equipment_changes_live.sql');
const UPDATE_SQL = path.join(OUTPUT_DIR, 'update_equipment.sql');

const TYPE_MAP = {
  Tipper: 'TIPPER',
  Loader: 'LOADER',
  Generator: 'GENERATOR',
  Motorbike: 'MOTORBIKE',
  Excavator: 'EXCAVATOR',
  'Hydraulic Excavator': 'EXCAVATOR',
  Pool: 'POOL',
  Tractor: 'TRACTOR',
  TLB: 'TLB',
  Bus: 'BUS',
  'Mini Bus': 'BUS',
  Dozer: 'DOZER',
  Compactor: 'COMPACTOR',
  Grader: 'GRADER',
  'Water Bowser': 'WATER_BOWSER',
  'Water Tank': 'WATER_TANKER',
  Forklift: 'FORKLIFT',
  Tellehandler: 'FORKLIFT',
  'Fuel Bowser': 'FUEL_BOWSER',
  'Fuel Tanker': 'FUEL_TANKER',
};

const COMPANY_ALIASES = {
  'earth shift': 'Earth Shift',
  harveygood: 'HarvGood',
  'u-link freight': 'U-freight link',
  logitrans: 'Logi Trans',
};

// CSV fleet IDs that differ from DB canonical fleetId after deduplication
const FLEET_ALIASES = {
  '2HGT835': '2HGT791',
};

function resolveFleetId(fleetId) {
  const trimmed = fleetId.trim();
  return FLEET_ALIASES[trimmed.toUpperCase()] ?? trimmed;
}

const ROAD_TYPES = new Set([
  'TIPPER', 'POOL', 'BUS', 'MOTORBIKE', 'TRACTOR',
  'WATER_BOWSER', 'WATER_TANKER', 'OTHER',
]);

const MILL_CRUSHER_FLEET = /^(M\d+|N\d+|CR\d+|A1|\d+TPH\d+)$/i;

function escapeSql(val) {
  return String(val).replace(/'/g, "''");
}

function sqlStr(val) {
  if (val === null || val === undefined) return 'NULL';
  return `'${escapeSql(val)}'`;
}

function sqlNum(val) {
  if (val === null || val === undefined) return 'NULL';
  return String(val);
}

function sqlEnum(val) {
  if (val === null || val === undefined) return 'NULL';
  return `'${escapeSql(val)}'`;
}

function isSentinel(val) {
  const v = (val ?? '').trim().toLowerCase();
  return v === '' || v === 'n/a' || v === '0';
}

function normStr(val) {
  if (isSentinel(val)) return null;
  return val.trim();
}

function normReg(val) {
  if (isSentinel(val)) return null;
  return val.trim();
}

function parseFuel(val) {
  if (isSentinel(val)) return null;
  const n = parseFloat(val.trim().replace(',', '.'));
  return Number.isFinite(n) ? n : null;
}

function parseCapacity(val) {
  if (isSentinel(val)) return null;
  const m = val.trim().replace(',', '.').match(/([\d.]+)/);
  return m ? parseFloat(m[1]) : null;
}

function mapType(csvType) {
  const t = (csvType ?? '').trim();
  if (t.toLowerCase() === 'n/a') return null;
  return TYPE_MAP[t] ?? 'OTHER';
}

function mapLocation(loc) {
  const raw = (loc ?? '').trim();
  if (isSentinel(raw)) return { location: 'OTHER', locationOtherText: null };

  const compact = raw.toUpperCase().replace(/\s+/g, '');
  if (compact === 'AMATOLA') return { location: 'AMATOLA', locationOtherText: null };
  if (compact === 'WALDEN') return { location: 'WALDEN', locationOtherText: null };
  if (compact === 'WALDENCIP' || compact === 'WALDENMILLING') {
    return { location: 'WALDEN', locationOtherText: raw };
  }
  return { location: 'OTHER', locationOtherText: raw };
}

function fuelUnit(equipmentType, fuelConsumption) {
  if (fuelConsumption === null) return null;
  return ROAD_TYPES.has(equipmentType) ? 'LITRES_PER_KM' : 'LITRES_PER_HOUR';
}

function parseCsvLine(line) {
  const result = [];
  let current = '';
  let inQuotes = false;

  for (let i = 0; i < line.length; i++) {
    const ch = line[i];
    if (ch === '"') {
      if (inQuotes && line[i + 1] === '"') {
        current += '"';
        i++;
      } else {
        inQuotes = !inQuotes;
      }
    } else if (ch === ',' && !inQuotes) {
      result.push(current);
      current = '';
    } else {
      current += ch;
    }
  }
  result.push(current);
  return result;
}

function readDbCsv(filePath) {
  const text = fs.readFileSync(filePath, 'utf8').replace(/^\uFEFF/, '');
  const lines = text.trim().split('\n');
  const headers = parseCsvLine(lines[0]);
  return lines.slice(1).map(line => {
    const values = parseCsvLine(line);
    const row = {};
    headers.forEach((h, i) => { row[h] = values[i] ?? ''; });
    return row;
  });
}

function readUpdatedCsv(filePath) {
  const text = fs.readFileSync(filePath, 'utf8').replace(/^\uFEFF/, '');
  const lines = text.trim().split('\n');
  const headers = lines[0].split(';').map(h => h.trim());
  return lines.slice(1).map(line => {
    const values = line.split(';');
    const row = {};
    headers.forEach((h, i) => { row[h] = (values[i] ?? '').trim(); });
    return row;
  });
}

function readCompanies(filePath) {
  if (!fs.existsSync(filePath)) return new Map();

  const rows = readDbCsv(filePath);
  const byName = new Map();
  for (const row of rows) {
    const key = row.name.trim().toLowerCase();
    if (!byName.has(key)) byName.set(key, []);
    byName.get(key).push(row);
  }
  return byName;
}

function resolveCompanyId(companyName, siteId, companiesByName) {
  if (!companyName || isSentinel(companyName)) return null;

  const alias = COMPANY_ALIASES[companyName.trim().toLowerCase()];
  const lookupName = alias ?? companyName.trim();
  const matches = companiesByName.get(lookupName.toLowerCase());
  if (!matches || matches.length === 0) return { id: null, name: lookupName };

  if (siteId) {
    const sameSite = matches.find(m => m.siteId === siteId);
    if (sameSite) return { id: sameSite.id, name: lookupName };
  }
  return { id: matches[0].id, name: lookupName };
}

function regMatches(a, b) {
  const na = normReg(a);
  const nb = normReg(b);
  if (!na || !nb) return false;
  return na.toUpperCase() === nb.toUpperCase();
}

function rowRichness(row) {
  let score = 0;
  if (row.type) score += 4;
  if (row.registrationNumber) score += 2;
  if (row.vinSerialId) score += 2;
  if (row.make || row.model) score += 1;
  if (row.companyId) score += 1;
  return score;
}

function pickDbRow(rows, csvRow) {
  if (rows.length === 1) return { row: rows[0], reason: 'single match' };

  const csvReg = csvRow['Reg Number'] ?? csvRow['Reg Number '] ?? '';
  const regMatch = rows.find(r => regMatches(r.registrationNumber, csvReg));
  if (regMatch) return { row: regMatch, reason: 'registration match' };

  const ranked = [...rows].sort((a, b) => {
    const richness = rowRichness(b) - rowRichness(a);
    if (richness !== 0) return richness;
    const site = (b.siteId ? 1 : 0) - (a.siteId ? 1 : 0);
    if (site !== 0) return site;
    return (b.updatedAt || '').localeCompare(a.updatedAt || '');
  });

  const best = ranked[0];
  if (rowRichness(best) > rowRichness(ranked[1])) {
    return { row: best, reason: 'richest existing row' };
  }
  if (best.siteId && !ranked[1].siteId) {
    return { row: best, reason: 'only row with siteId' };
  }
  return { row: best, reason: 'most recent updatedAt' };
}

function isMillCrusherCsvRow(row) {
  const type = (row.Type ?? '').trim().toLowerCase();
  const fleetId = (row['Fleet ID'] ?? '').trim();
  return type === 'n/a' || MILL_CRUSHER_FLEET.test(fleetId);
}

function isMillCrusherDbRow(row) {
  return row.type === 'MILL' || row.type === 'CRUSHER';
}

function csvRowScore(row) {
  const regCol = row['Reg Number'] ?? row['Reg Number '] ?? '';
  let score = 0;
  if (!isSentinel(regCol)) score += 20;
  const type = (row.Type ?? '').trim();
  if (!isSentinel(type) && type.toLowerCase() !== 'n/a') score += 20;
  if (!isSentinel(row['Vin/Serial ID'])) score += 15;
  for (const key of ['Make', 'Model', 'Company', 'Location']) {
    if (!isSentinel(row[key])) score += 2;
  }
  return score;
}

function dedupeCsvRows(rows) {
  const byFleet = new Map();
  const duplicates = [];

  for (const row of rows) {
    const fleetId = resolveFleetId(row['Fleet ID']);
    const score = csvRowScore(row);
    if (!byFleet.has(fleetId)) {
      byFleet.set(fleetId, { row, score });
      continue;
    }
    duplicates.push(fleetId);
    const prev = byFleet.get(fleetId);
    if (score > prev.score) {
      byFleet.set(fleetId, { row, score });
    }
  }

  return {
    rows: [...byFleet.values()].map(v => v.row),
    duplicateFleets: [...new Set(duplicates)].sort(),
  };
}

function normalizeUnique(val) {
  if (val === null || val === undefined) return null;
  const trimmed = String(val).trim();
  return trimmed ? trimmed.toUpperCase() : null;
}

function siteKey(siteId) {
  return siteId || '__NULL__';
}

function resolveUniqueConflicts(updates, field, resolvedConflicts) {
  let changed = true;

  while (changed) {
    changed = false;
    const bySiteValue = new Map();

    for (const u of updates) {
      const val = normalizeUnique(u.new[field]);
      if (!val) continue;
      const key = `${siteKey(u.siteId)}\0${val}`;
      if (!bySiteValue.has(key)) bySiteValue.set(key, []);
      bySiteValue.get(key).push(u);
    }

    for (const group of bySiteValue.values()) {
      if (group.length <= 1) continue;

      const withExisting = group.filter(
        u => normalizeUnique(u.old[field]) === normalizeUnique(u.new[field]),
      );
      let winner;
      if (withExisting.length >= 1) {
        winner = [...withExisting].sort((a, b) => a.fleetId.localeCompare(b.fleetId))[0];
      } else {
        winner = [...group].sort((a, b) => a.fleetId.localeCompare(b.fleetId))[0];
      }

      for (const u of group) {
        if (u === winner) continue;
        if (u.new[field] === u.old[field]) continue;
        u.new[field] = u.old[field];
        resolvedConflicts.push({
          field,
          value: normalizeUnique(winner.new[field]),
          winner: winner.fleetId,
          skipped: u.fleetId,
        });
        changed = true;
      }
    }
  }
}

function collectUniqueConflicts(updates, field) {
  const bySiteValue = new Map();
  for (const u of updates) {
    const val = normalizeUnique(u.new[field]);
    if (!val) continue;
    const key = `${siteKey(u.siteId)}\0${val}`;
    if (!bySiteValue.has(key)) bySiteValue.set(key, []);
    bySiteValue.get(key).push(u.fleetId);
  }
  return [...bySiteValue.values()].filter(fleets => fleets.length > 1);
}

function dbUniqueField(row, field) {
  return field === 'registrationNumber' ? row.registrationNumber : row.vinSerialId;
}

function fleetIdFromDbRow(row) {
  return row.fleetId.replace(/^"|"$/g, '');
}

// Skip unique-field updates blocked by another Equipment row at the same site.
// Batch handoffs (holder in CSV, giving up the value) are left to pre-clear SQL.
function resolveExternalDbConflicts(updates, dbRows, field, resolvedConflicts) {
  const updateById = new Map(updates.map(u => [u.id, u]));

  for (const u of updates) {
    const targetVal = normalizeUnique(u.new[field]);
    if (!targetVal) continue;
    if (normalizeUnique(u.old[field]) === targetVal) continue;

    for (const dbRow of dbRows) {
      if (isMillCrusherDbRow(dbRow)) continue;
      if (dbRow.id === u.id) continue;
      if (siteKey(dbRow.siteId || null) !== siteKey(u.siteId)) continue;
      if (normalizeUnique(dbUniqueField(dbRow, field)) !== targetVal) continue;

      const holderUpdate = updateById.get(dbRow.id);

      if (holderUpdate) {
        const holderOld = normalizeUnique(holderUpdate.old[field]);
        const holderNew = normalizeUnique(holderUpdate.new[field]);
        if (holderOld === targetVal && holderNew !== targetVal) continue;
        if (holderNew === targetVal) {
          if (u.new[field] === u.old[field]) continue;
          u.new[field] = u.old[field];
          resolvedConflicts.push({
            field,
            value: targetVal,
            winner: holderUpdate.fleetId,
            skipped: u.fleetId,
            reason: 'holder keeps value',
          });
          break;
        }
        continue;
      }

      u.new[field] = u.old[field];
      resolvedConflicts.push({
        field,
        value: targetVal,
        winner: fleetIdFromDbRow(dbRow),
        skipped: u.fleetId,
        reason: 'external holder (not in CSV batch)',
      });
      break;
    }
  }
}

function buildUniquePreClearSql(column) {
  const quoted = `"${column}"`;
  return `-- Free ${column} values being reassigned within this batch
UPDATE "Equipment" e
SET ${quoted} = NULL, "updatedAt" = NOW()
FROM tmp_equipment_update s
WHERE e.id = s.id
  AND e.${quoted} IS NOT NULL
  AND EXISTS (
    SELECT 1
    FROM tmp_equipment_update s2
    WHERE s2.id <> e.id
      AND s2.${quoted} IS NOT NULL
      AND UPPER(TRIM(s2.${quoted})) = UPPER(TRIM(e.${quoted}))
  )
  AND (
    s.${quoted} IS NULL
    OR UPPER(TRIM(s.${quoted})) IS DISTINCT FROM UPPER(TRIM(e.${quoted}))
  );`;
}

function transformCsvRow(csvRow) {
  const regCol = csvRow['Reg Number'] ?? csvRow['Reg Number '] ?? '';
  const equipmentType = mapType(csvRow.Type);
  const fuelConsumption = parseFuel(csvRow['Fuel Consumption']);
  const loc = mapLocation(csvRow.Location);

  return {
    fleetId: csvRow['Fleet ID'].trim(),
    type: equipmentType,
    make: normStr(csvRow.Make),
    model: normStr(csvRow.Model),
    registrationNumber: normReg(regCol),
    vinSerialId: normStr(csvRow['Vin/Serial ID']),
    engineCapacity: normStr(csvRow['Engine Capacity']),
    fuelConsumption,
    fuelConsumptionUnit: fuelUnit(equipmentType, fuelConsumption),
    loadingCarryingCapacityTonnes: parseCapacity(csvRow['Loading/Carrying Capacity (Tonnes)']),
    location: loc.location,
    locationOtherText: loc.locationOtherText,
    companyName: normStr(csvRow.Company),
    status: normStr(csvRow.Status),
  };
}

function dbSnapshot(row) {
  return {
    type: row.type || null,
    make: row.make || null,
    model: row.model || null,
    registrationNumber: row.registrationNumber || null,
    vinSerialId: row.vinSerialId || null,
    engineCapacity: row.engineCapacity || null,
    fuelConsumption: row.fuelConsumption ? parseFloat(row.fuelConsumption) : null,
    fuelConsumptionUnit: row.fuelConsumptionUnit || null,
    loadingCarryingCapacityTonnes: row.loadingCarryingCapacityTonnes
      ? parseFloat(row.loadingCarryingCapacityTonnes) : null,
    location: row.location || null,
    locationOtherText: row.locationOtherText || null,
    companyId: row.companyId || null,
    status: row.status || 'AVAILABLE',
  };
}

function hasDiff(oldVals, newVals) {
  const keys = [
    'type', 'make', 'model', 'registrationNumber', 'vinSerialId',
    'engineCapacity', 'fuelConsumption', 'fuelConsumptionUnit',
    'loadingCarryingCapacityTonnes', 'location', 'locationOtherText',
  ];
  return keys.some(k => oldVals[k] !== newVals[k]);
}

const PREVIEW_SCALAR_FIELDS = [
  'type', 'make', 'model', 'registrationNumber', 'vinSerialId',
  'engineCapacity', 'fuelConsumption', 'fuelConsumptionUnit',
  'loadingCarryingCapacityTonnes', 'location', 'locationOtherText', 'status',
];

function formatPreviewVal(val) {
  if (val === null || val === undefined) return 'NULL';
  return sqlStr(String(val));
}

function buildTmpEquipmentUpdateDdl() {
  return [
    'CREATE TEMP TABLE tmp_equipment_update (',
    '  id                            TEXT PRIMARY KEY,',
    '  type                          TEXT,',
    '  make                          TEXT,',
    '  model                         TEXT,',
    '  "registrationNumber"          TEXT,',
    '  "vinSerialId"                 TEXT,',
    '  "engineCapacity"              TEXT,',
    '  "fuelConsumption"             DOUBLE PRECISION,',
    '  "fuelConsumptionUnit"         TEXT,',
    '  "loadingCarryingCapacityTonnes" DOUBLE PRECISION,',
    '  location                      TEXT,',
    '  "locationOtherText"           TEXT,',
    '  company_name                  TEXT,',
    '  status                        TEXT',
    ');',
  ];
}

function buildInsertValueRows(updates) {
  return updates.map(u => {
    const n = u.new;
    return `  (${sqlStr(u.id)}, ${sqlEnum(n.type)}, ${sqlStr(n.make)}, ${sqlStr(n.model)}, ${sqlStr(n.registrationNumber)}, ${sqlStr(n.vinSerialId)}, ${sqlStr(n.engineCapacity)}, ${sqlNum(n.fuelConsumption)}, ${sqlEnum(n.fuelConsumptionUnit)}, ${sqlNum(n.loadingCarryingCapacityTonnes)}, ${sqlEnum(n.location)}, ${sqlStr(n.locationOtherText)}, ${sqlStr(n.companyName)}, ${sqlEnum(n.status)})`;
  });
}

function buildPreviewChangesSql(updates) {
  const wideCols = PREVIEW_SCALAR_FIELDS.flatMap(f => [`old_${f}`, `new_${f}`]);
  wideCols.push('old_company_id', 'new_company_name');

  const wideRows = updates.map(u => {
    const cols = PREVIEW_SCALAR_FIELDS.flatMap(f => [
      formatPreviewVal(u.old[f]),
      formatPreviewVal(u.new[f]),
    ]);
    cols.push(formatPreviewVal(u.old.companyId), formatPreviewVal(u.new.companyName));
    return `  (${sqlStr(u.id)}, ${sqlStr(u.fleetId)}, ${cols.join(', ')})`;
  });

  const detailRows = [];
  for (const u of updates) {
    for (const field of PREVIEW_SCALAR_FIELDS) {
      if (u.old[field] !== u.new[field]) {
        detailRows.push(
          `  (${sqlStr(u.id)}, ${sqlStr(u.fleetId)}, ${sqlStr(field)}, ${formatPreviewVal(u.old[field])}, ${formatPreviewVal(u.new[field])})`,
        );
      }
    }
    if (u.old.companyId !== u.new.companyId) {
      detailRows.push(
        `  (${sqlStr(u.id)}, ${sqlStr(u.fleetId)}, ${sqlStr('companyId')}, ${formatPreviewVal(u.old.companyId)}, ${formatPreviewVal(u.new.companyName)})`,
      );
    }
  }

  return [
    '-- Planned equipment changes from Updated-Table 1.csv',
    `-- ${updates.length} equipment rows, ${detailRows.length} field-level changes`,
    '-- PostgreSQL — read-only, no writes',
    '',
    '-- Query 1: one row per equipment (side-by-side old vs new)',
    'SELECT * FROM (VALUES',
    wideRows.join(',\n'),
    `) AS t(
  id,
  fleet_id,
  ${wideCols.join(',\n  ')}
)
ORDER BY fleet_id;`,
    '',
    `-- Query 2: one row per changed field (${detailRows.length} rows)`,
    'SELECT * FROM (VALUES',
    detailRows.join(',\n'),
    `) AS t(
  id,
  fleet_id,
  field_name,
  old_value,
  new_value
)
ORDER BY fleet_id, field_name;`,
  ].join('\n');
}

function buildLivePreviewSql(valueRows) {
  const changePredicates = [
    'e.type::text IS DISTINCT FROM s.type',
    'e.make IS DISTINCT FROM s.make',
    'e.model IS DISTINCT FROM s.model',
    'e."registrationNumber" IS DISTINCT FROM s."registrationNumber"',
    'e."vinSerialId" IS DISTINCT FROM s."vinSerialId"',
    'e."engineCapacity" IS DISTINCT FROM s."engineCapacity"',
    'e."fuelConsumption" IS DISTINCT FROM s."fuelConsumption"',
    'e."fuelConsumptionUnit"::text IS DISTINCT FROM s."fuelConsumptionUnit"',
    'e."loadingCarryingCapacityTonnes" IS DISTINCT FROM s."loadingCarryingCapacityTonnes"',
    'e.location::text IS DISTINCT FROM s.location',
    'e."locationOtherText" IS DISTINCT FROM s."locationOtherText"',
    'e.status::text IS DISTINCT FROM s.status',
    `e."companyId" IS DISTINCT FROM (
      SELECT ec.id
      FROM "EquipmentCompany" ec
      WHERE LOWER(TRIM(ec.name)) = LOWER(TRIM(s.company_name))
      ORDER BY CASE WHEN ec."siteId" IS NOT DISTINCT FROM e."siteId" THEN 0 ELSE 1 END
      LIMIT 1
    )`,
  ];

  return [
    '-- Live preview: compare planned changes against current Equipment rows',
    `-- ${valueRows.length} equipment rows`,
    '-- PostgreSQL — loads temp data, SELECT only, ROLLBACK at end',
    '',
    'BEGIN;',
    '',
    ...buildTmpEquipmentUpdateDdl(),
    '',
    'INSERT INTO tmp_equipment_update (',
    '  id, type, make, model, "registrationNumber", "vinSerialId", "engineCapacity",',
    '  "fuelConsumption", "fuelConsumptionUnit", "loadingCarryingCapacityTonnes",',
    '  location, "locationOtherText", company_name, status',
    ') VALUES',
    valueRows.join(',\n') + ';',
    '',
    'SELECT',
    '  e.id,',
    '  e."fleetId" AS fleet_id,',
    '  e.type AS db_type,',
    '  s.type AS new_type,',
    '  e.make AS db_make,',
    '  s.make AS new_make,',
    '  e.model AS db_model,',
    '  s.model AS new_model,',
    '  e."registrationNumber" AS db_registration,',
    '  s."registrationNumber" AS new_registration,',
    '  e."vinSerialId" AS db_vin,',
    '  s."vinSerialId" AS new_vin,',
    '  e."fuelConsumption" AS db_fuel_consumption,',
    '  s."fuelConsumption" AS new_fuel_consumption,',
    '  e.location::text AS db_location,',
    '  s.location AS new_location,',
    '  e."companyId" AS db_company_id,',
    '  s.company_name AS new_company_name,',
    '  e.status::text AS db_status,',
    '  s.status AS new_status',
    'FROM "Equipment" e',
    'JOIN tmp_equipment_update s ON s.id = e.id',
    'WHERE',
    `  (${changePredicates.join('\n  OR ')})`,
    'ORDER BY e."fleetId";',
    '',
    'ROLLBACK;',
  ].join('\n');
}

function main() {
  const updatedRows = readUpdatedCsv(UPDATED_CSV);
  const dbRows = readDbCsv(DB_CSV);
  const companiesByName = readCompanies(COMPANIES_CSV);

  const dbByFleet = new Map();
  for (const row of dbRows) {
    if (isMillCrusherDbRow(row)) continue;
    const fleetId = row.fleetId.replace(/^"|"$/g, '');
    if (!dbByFleet.has(fleetId)) dbByFleet.set(fleetId, []);
    dbByFleet.get(fleetId).push(row);
  }

  const excludedCsv = updatedRows.filter(isMillCrusherCsvRow);
  const eligibleRaw = updatedRows.filter(r => !isMillCrusherCsvRow(r));
  const { rows: eligibleCsv, duplicateFleets: csvDuplicateFleets } = dedupeCsvRows(eligibleRaw);

  const updates = [];
  const unmatchedFleet = [];
  const duplicateResolutions = [];
  const unmatchedCompanies = new Map();
  const regConflicts = [];
  const vinConflicts = [];

  for (const csvRow of eligibleCsv) {
    const fleetId = resolveFleetId(csvRow['Fleet ID']);
    const dbMatches = dbByFleet.get(fleetId);
    if (!dbMatches || dbMatches.length === 0) {
      unmatchedFleet.push(fleetId);
      continue;
    }

    const { row: dbRow, reason } = pickDbRow(dbMatches, csvRow);
    if (dbMatches.length > 1 && !duplicateResolutions.some(d => d.fleetId === fleetId)) {
      duplicateResolutions.push({ fleetId, chosenId: dbRow.id, reason, count: dbMatches.length });
    }

    const newVals = transformCsvRow(csvRow);
    const oldVals = dbSnapshot(dbRow);
    const company = resolveCompanyId(newVals.companyName, dbRow.siteId || null, companiesByName);

    if (newVals.companyName && !company.id && companiesByName.size > 0) {
      unmatchedCompanies.set(company.name, (unmatchedCompanies.get(company.name) || 0) + 1);
    }

    const finalVals = {
      ...newVals,
      companyId: company.id,
      status: newVals.status ?? oldVals.status,
    };

    const diff = hasDiff(oldVals, finalVals)
      || finalVals.companyId !== oldVals.companyId
      || (newVals.status && newVals.status !== oldVals.status);

    if (!diff) continue;

    updates.push({
      id: dbRow.id,
      fleetId,
      siteId: dbRow.siteId || null,
      old: oldVals,
      new: finalVals,
    });
  }

  const resolvedConflicts = [];
  resolveUniqueConflicts(updates, 'registrationNumber', resolvedConflicts);
  resolveUniqueConflicts(updates, 'vinSerialId', resolvedConflicts);
  resolveExternalDbConflicts(updates, dbRows, 'registrationNumber', resolvedConflicts);
  resolveExternalDbConflicts(updates, dbRows, 'vinSerialId', resolvedConflicts);

  for (const fleets of collectUniqueConflicts(updates, 'registrationNumber')) {
    regConflicts.push({ fleets });
  }
  for (const fleets of collectUniqueConflicts(updates, 'vinSerialId')) {
    vinConflicts.push({ fleets });
  }

  if (regConflicts.length > 0 || vinConflicts.length > 0) {
    console.error('ERROR: Unresolved registration/VIN conflicts remain. Fix the CSV before applying.');
    process.exit(1);
  }

  fs.mkdirSync(OUTPUT_DIR, { recursive: true });

  const previewLines = [
    '-- Preview: equipment updates from Updated-Table 1.csv',
    '-- Read-only summary generated by generate_update.js',
    '-- PostgreSQL',
    '',
    `-- CSV rows total:              ${updatedRows.length}`,
    `-- CSV mill/crusher excluded:   ${excludedCsv.length}`,
    `-- CSV duplicate fleet IDs:     ${csvDuplicateFleets.length} (best row kept)`,
    `-- DB mill/crusher excluded:    ${dbRows.filter(isMillCrusherDbRow).length}`,
    `-- Updates to apply:            ${updates.length}`,
    `-- Unmatched fleet IDs:         ${unmatchedFleet.length}`,
    `-- Duplicate fleet resolutions: ${duplicateResolutions.length}`,
    `-- Unmatched company names:     ${unmatchedCompanies.size} (when equipment_companies.csv provided)`,
    `-- Registration conflicts:      ${regConflicts.length}`,
    `-- VIN conflicts:               ${vinConflicts.length}`,
    '',
  ];

  if (csvDuplicateFleets.length > 0) {
    previewLines.push('-- Duplicate fleet IDs in CSV (best row kept)');
    for (const f of csvDuplicateFleets) {
      previewLines.push(`--   ${f}`);
    }
    previewLines.push('');
  }

  if (resolvedConflicts.length > 0) {
    previewLines.push('-- Unique field conflicts auto-resolved (skipped field update on loser)');
    for (const c of resolvedConflicts) {
      const reason = c.reason ? ` (${c.reason})` : '';
      previewLines.push(`--   ${c.field}: ${c.value} -> kept ${c.winner}, skipped ${c.skipped}${reason}`);
    }
    previewLines.push('');
  }

  if (duplicateResolutions.length > 0) {
    previewLines.push('-- Duplicate fleetId in DB (chosen row)');
    for (const d of duplicateResolutions) {
      previewLines.push(`--   ${d.fleetId}: chose id ${d.chosenId} (${d.reason}, ${d.count} rows)`);
    }
    previewLines.push('');
  }

  if (unmatchedFleet.length > 0) {
    previewLines.push('-- Unmatched fleet IDs (no DB row)');
    for (const f of unmatchedFleet) previewLines.push(`--   ${f}`);
    previewLines.push('');
  }

  if (unmatchedCompanies.size > 0) {
    previewLines.push('-- Unmatched company names');
    for (const [name, count] of [...unmatchedCompanies.entries()].sort()) {
      previewLines.push(`--   ${count}x ${name}`);
    }
    previewLines.push('');
  }

  if (regConflicts.length > 0) {
    previewLines.push('-- Registration number conflicts within batch (same siteId)');
    for (const c of regConflicts) {
      previewLines.push(`--   ${c.fleets.join(', ')}`);
    }
    previewLines.push('');
  }

  if (vinConflicts.length > 0) {
    previewLines.push('-- VIN conflicts within batch (same siteId)');
    for (const c of vinConflicts) {
      previewLines.push(`--   ${c.fleets.join(', ')}`);
    }
    previewLines.push('');
  }

  previewLines.push('-- Sample changes (first 20)');
  for (const u of updates.slice(0, 20)) {
    previewLines.push(`-- ${u.fleetId} (${u.id})`);
    for (const field of ['type', 'make', 'model', 'registrationNumber', 'location', 'companyName']) {
      const oldV = field === 'companyName' ? u.old.companyId : u.old[field];
      const newV = field === 'companyName' ? (u.new.companyName ?? u.new.companyId) : u.new[field];
      if (oldV !== newV) {
        previewLines.push(`--   ${field}: ${JSON.stringify(oldV)} -> ${JSON.stringify(newV)}`);
      }
    }
  }
  previewLines.push('');

  previewLines.push('-- Live DB checks (run against target database)');
  previewLines.push(`
-- Companies in CSV not found in EquipmentCompany
WITH csv_companies(company_name) AS (
  VALUES
${[...new Set(updates.map(u => u.new.companyName).filter(Boolean))]
  .sort()
  .map(n => `    (${sqlStr(n)})`)
  .join(',\n')}
)
SELECT cc.company_name
FROM csv_companies cc
WHERE NOT EXISTS (
  SELECT 1 FROM "EquipmentCompany" ec
  WHERE LOWER(TRIM(ec.name)) = LOWER(TRIM(cc.company_name))
)
ORDER BY 1;
`);

  previewLines.push(`
-- Post-update registration uniqueness risks (same siteId, different equipment id)
SELECT e."siteId", e."registrationNumber", COUNT(*) AS cnt, array_agg(e."fleetId") AS fleet_ids
FROM "Equipment" e
WHERE e."registrationNumber" IS NOT NULL
  AND (e.type IS NULL OR e.type NOT IN ('MILL', 'CRUSHER'))
GROUP BY e."siteId", e."registrationNumber"
HAVING COUNT(*) > 1;
`);

  fs.writeFileSync(PREVIEW_SQL, previewLines.join('\n'));

  const valueRows = buildInsertValueRows(updates);

  fs.writeFileSync(PREVIEW_CHANGES_SQL, buildPreviewChangesSql(updates));
  fs.writeFileSync(PREVIEW_CHANGES_LIVE_SQL, buildLivePreviewSql(valueRows));

  const updateLines = [
    '-- Update equipment from: Updated-Table 1.csv',
    `-- ${updates.length} rows (mills/crushers excluded)`,
    '-- PostgreSQL',
    '',
    'BEGIN;',
    '',
    ...buildTmpEquipmentUpdateDdl(),
    '',
    'INSERT INTO tmp_equipment_update (',
    '  id, type, make, model, "registrationNumber", "vinSerialId", "engineCapacity",',
    '  "fuelConsumption", "fuelConsumptionUnit", "loadingCarryingCapacityTonnes",',
    '  location, "locationOtherText", company_name, status',
    ') VALUES',
  ];

  updateLines.push(valueRows.join(',\n') + ';');
  updateLines.push('');
  updateLines.push(buildUniquePreClearSql('registrationNumber'));
  updateLines.push('');
  updateLines.push(buildUniquePreClearSql('vinSerialId'));
  updateLines.push('');
  updateLines.push(`UPDATE "Equipment" e
SET
  type                          = s.type::"EquipmentType",
  make                          = s.make,
  model                         = s.model,
  "registrationNumber"          = s."registrationNumber",
  "vinSerialId"                 = s."vinSerialId",
  "engineCapacity"              = s."engineCapacity",
  "fuelConsumption"             = s."fuelConsumption",
  "fuelConsumptionUnit"         = s."fuelConsumptionUnit"::"FuelConsumptionUnit",
  "loadingCarryingCapacityTonnes" = s."loadingCarryingCapacityTonnes",
  location                      = s.location::"EquipmentLocation",
  "locationOtherText"           = s."locationOtherText",
  "companyId"                   = CASE
    WHEN s.company_name IS NULL THEN e."companyId"
    ELSE (
      SELECT ec.id
      FROM "EquipmentCompany" ec
      WHERE LOWER(TRIM(ec.name)) = LOWER(TRIM(s.company_name))
      ORDER BY CASE WHEN ec."siteId" IS NOT DISTINCT FROM e."siteId" THEN 0 ELSE 1 END
      LIMIT 1
    )
  END,
  status                        = s.status::"EquipmentStatus",
  "updatedAt"                   = NOW()
FROM tmp_equipment_update s
WHERE e.id = s.id
  AND (e.type IS NULL OR e.type NOT IN ('MILL', 'CRUSHER'));`);
  updateLines.push('');
  updateLines.push('DROP TABLE tmp_equipment_update;');
  updateLines.push('');
  updateLines.push('COMMIT;');

  fs.writeFileSync(UPDATE_SQL, updateLines.join('\n'));

  console.log(`Excluded CSV mill/crusher rows: ${excludedCsv.length}`);
  console.log(`Updates generated:              ${updates.length}`);
  console.log(`Duplicate fleet resolutions:    ${duplicateResolutions.length}`);
  console.log(`Unmatched fleet IDs:            ${unmatchedFleet.length}`);
  console.log(`Unmatched companies (offline):  ${unmatchedCompanies.size}`);
  console.log(`Unique conflicts resolved:      ${resolvedConflicts.length}`);
  console.log(`Registration conflicts:         ${regConflicts.length}`);
  console.log(`VIN conflicts:                  ${vinConflicts.length}`);
  console.log(`Preview -> ${PREVIEW_SQL}`);
  console.log(`Changes -> ${PREVIEW_CHANGES_SQL}`);
  console.log(`Live    -> ${PREVIEW_CHANGES_LIVE_SQL}`);
  console.log(`Update  -> ${UPDATE_SQL}`);
}

main();
