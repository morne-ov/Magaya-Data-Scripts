# Equipment updates

Apply spreadsheet changes from `Updated-Table 1.csv` to existing `Equipment` rows.

## Inputs

| File | Source |
|---|---|
| `equipment.csv` | DB export of current equipment |
| `equipmentCompany.csv` | DB export of equipment companies |
| `../Updated-Table 1.csv` | Spreadsheet with target values |

Mills and crushers (`M1`, `CR1`, `5TPH1`, etc.) are **excluded** from updates.

## Generate SQL

```bash
node uploads/equipment/generator/generate_update.js
```

Outputs:

- `output/preview_equipment_updates.sql` — summary comments + DB sanity checks
- `output/preview_equipment_changes.sql` — **all 845 changes as SELECT result sets** (no DB required)
- `output/preview_equipment_changes_live.sql` — same comparison joined to live `Equipment` (ROLLBACK)
- `output/update_equipment.sql` — transactional UPDATE (845 rows)

The update script clears conflicting registration/VIN values within the batch before applying changes, and auto-resolves duplicate registration/VIN targets in the CSV (keeper wins; see preview comments).

## Apply

1. Back up equipment (see `backups/`).
2. Review `output/preview_equipment_changes.sql` — run Query 1 or Query 2 for full change list.
3. Optionally run `output/preview_equipment_changes_live.sql` against the DB (ROLLBACK only).
4. Review `output/preview_equipment_updates.sql` — check auto-resolved conflict warnings.
5. Run on staging first:

```bash
psql "$DATABASE_URL" -f equipment_updates/output/preview_equipment_updates.sql
psql "$DATABASE_URL" -f equipment_updates/output/update_equipment.sql
```

Use `ROLLBACK` instead of `COMMIT` in the update script for a dry run.

## Matching

- Rows matched by **Fleet ID** (CSV → DB).
- Fleet alias: `2HGT835` → `2HGT791` (post-dedup canonical ID).
- Company names resolved via `EquipmentCompany.name` at apply time.
- CSV duplicate fleet IDs: best row kept (prefers real reg/VIN/type over `0`/`n/a` placeholders).
- Registration/VIN conflicts within the batch are auto-resolved; the preview lists skipped field updates.
