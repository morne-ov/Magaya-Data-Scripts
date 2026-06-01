-- Find rows whose FK columns point to ids that no longer exist in the parent table.
-- Walks every FK declared in information_schema and emits a count per FK.
-- PostgreSQL.

DO $$
DECLARE
    r            RECORD;
    orphan_count BIGINT;
BEGIN
    DROP TABLE IF EXISTS tmp_orphan_fks;
    CREATE TEMP TABLE tmp_orphan_fks (
        child_table    TEXT,
        child_column   TEXT,
        parent_table   TEXT,
        parent_column  TEXT,
        orphan_count   BIGINT
    );

    FOR r IN
        SELECT
            tc.table_schema  AS child_schema,
            tc.table_name    AS child_table,
            kcu.column_name  AS child_column,
            ccu.table_schema AS parent_schema,
            ccu.table_name   AS parent_table,
            ccu.column_name  AS parent_column
        FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu
          ON tc.constraint_name = kcu.constraint_name
         AND tc.table_schema    = kcu.table_schema
        JOIN information_schema.constraint_column_usage ccu
          ON ccu.constraint_name = tc.constraint_name
         AND ccu.table_schema    = tc.table_schema
        WHERE tc.constraint_type = 'FOREIGN KEY'
          AND tc.table_schema    = 'public'
    LOOP
        EXECUTE format(
            'SELECT COUNT(*) FROM %I.%I c
             WHERE c.%I IS NOT NULL
               AND NOT EXISTS (SELECT 1 FROM %I.%I p WHERE p.%I = c.%I)',
            r.child_schema, r.child_table, r.child_column,
            r.parent_schema, r.parent_table, r.parent_column, r.child_column
        ) INTO orphan_count;

        IF orphan_count > 0 THEN
            INSERT INTO tmp_orphan_fks VALUES (
                r.child_table, r.child_column,
                r.parent_table, r.parent_column,
                orphan_count
            );
        END IF;
    END LOOP;
END $$;

SELECT *
FROM tmp_orphan_fks
ORDER BY orphan_count DESC, child_table, child_column;
