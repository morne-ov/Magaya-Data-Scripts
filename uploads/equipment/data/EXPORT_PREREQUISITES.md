# Equipment update — DB export prerequisites

Run these against PostgreSQL before generating or applying equipment updates.

## 1. Equipment companies (optional — generator resolves companies via SQL subquery at apply time)

```sql
COPY (
  SELECT id, name, "siteId"
  FROM "EquipmentCompany"
  ORDER BY name
) TO STDOUT WITH CSV HEADER;
```

Save as `equipment_updates/equipmentCompany.csv`.

## 2. Current equipment snapshot

```sql
COPY (
  SELECT
    id, description, type, "fleetId", make, model, year,
    "registrationNumber", "vinSerialId", "companyId", status,
    "createdAt", "updatedAt", "siteId", "engineCapacity",
    "loadingCarryingCapacityTonnes", "fuelConsumptionUnit",
    "fuelConsumption", "locationOtherText", location,
    "millingSiteId", "lastAssessedAt", "crushingSiteId"
  FROM "Equipment"
  ORDER BY "fleetId"
) TO STDOUT WITH CSV HEADER;
```

Save as `equipment_updates/equipment.csv`.

## 3. Generate and apply

```bash
node uploads/equipment/generator/generate_update.js
psql $DATABASE_URL -f equipment_updates/output/preview_equipment_updates.sql
psql $DATABASE_URL -f equipment_updates/output/update_equipment.sql
```

Run the preview on staging/dev first. Mills and crushers are excluded from updates.
