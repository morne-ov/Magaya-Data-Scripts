const fs = require('fs');
const path = require('path');

function cuid() {
  const timestamp = Date.now().toString(36);
  const rand = () => Math.random().toString(36).padEnd(10, '0').slice(2, 10);
  return 'c' + timestamp + rand() + rand();
}

const nullable = val => (val && val.trim() !== '' ? `'${val.replace(/'/g, "''")}'` : 'NULL');

const inputPath = path.join(__dirname, '../data/example_users.csv');
const outputPath = path.join(__dirname, '../output/insert_users.sql');

const csv = fs.readFileSync(inputPath, 'utf8');
const lines = csv.trim().split('\n').slice(1);

const now = new Date().toISOString();

// roleId resolved at runtime via subquery on UserRole name
const values = lines.map(line => {
  const parts        = line.trim().split(';');
  const firstName    = parts[0].replace(/'/g, "''");
  const lastName     = parts[1].replace(/'/g, "''");
  const email        = parts[2].trim();
  const contactNumber = nullable(parts[3]);
  const roleName     = parts[4].trim();
  const status       = parts[5] && parts[5].trim() !== '' ? parts[5].trim() : 'ACTIVE';
  const siteId       = parts[6].trim();
  const id           = cuid();

  const roleIdExpr = roleName
    ? `(SELECT id FROM "UserRole" WHERE "siteId" = '${siteId}' AND name = '${roleName.replace(/'/g, "''")}')`
    : 'NULL';

  return `('${id}', '${siteId}', '${firstName}', '${lastName}', '${email}', ${contactNumber}, ${roleIdExpr}, '${status}', '${now}', '${now}')`;
});

const sql = `-- Insert users from: example_users.csv
-- ${values.length} users
-- Requires: UserRole rows must exist before running this script
-- Passwords are NOT set here — users must set their password via the setup token flow
-- Safe to re-run: ON CONFLICT (siteId, email) DO NOTHING

INSERT INTO "User" ("id", "siteId", "firstName", "lastName", "email", "contactNumber", "roleId", "status", "createdAt", "updatedAt")
VALUES
${values.join(',\n')}
ON CONFLICT ("siteId", "email") DO NOTHING;
`;

fs.writeFileSync(outputPath, sql);
console.log(`Generated ${values.length} rows -> ${outputPath}`);
