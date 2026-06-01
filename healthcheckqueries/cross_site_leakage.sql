-- Cross-site leakage: rows whose siteId differs from the siteId of a parent
-- record they reference via FK. Walks every FK whose child AND parent table
-- both have a `siteId` column.
-- PostgreSQL.

DO $$
DECLARE
    r           RECORD;
    leak_count  BIGINT;
BEGIN
    DROP TABLE IF EXISTS tmp_cross_site_leakage;
    CREATE TEMP TABLE tmp_cross_site_leakage (
        child_table   TEXT,
        child_column  TEXT,
        parent_table  TEXT,
        mismatched_rows BIGINT
    );

    FOR r IN
        SELECT
            tc.table_schema       AS child_schema,
            tc.table_name         AS child_table,
            kcu.column_name       AS child_column,
            ccu.table_schema      AS parent_schema,
            ccu.table_name        AS parent_table,
            ccu.column_name       AS parent_column
        FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu
          ON tc.constraint_name = kcu.constraint_name
         AND tc.table_schema    = kcu.table_schema
        JOIN information_schema.constraint_column_usage ccu
          ON ccu.constraint_name = tc.constraint_name
         AND ccu.table_schema    = tc.table_schema
        WHERE tc.constraint_type = 'FOREIGN KEY'
          AND tc.table_schema    = 'public'
          AND kcu.column_name <> 'siteId'
          AND EXISTS (
              SELECT 1 FROM information_schema.columns
              WHERE table_schema = tc.table_schema
                AND table_name   = tc.table_name
                AND column_name  = 'siteId'
          )
          AND EXISTS (
              SELECT 1 FROM information_schema.columns
              WHERE table_schema = ccu.table_schema
                AND table_name   = ccu.table_name
                AND column_name  = 'siteId'
          )
    LOOP
        EXECUTE format(
            'SELECT COUNT(*) FROM %I.%I c
             JOIN %I.%I p ON p.%I = c.%I
             WHERE c."siteId" IS NOT NULL
               AND p."siteId" IS NOT NULL
               AND c."siteId" <> p."siteId"',
            r.child_schema, r.child_table,
            r.parent_schema, r.parent_table,
            r.parent_column, r.child_column
        ) INTO leak_count;

        IF leak_count > 0 THEN
            INSERT INTO tmp_cross_site_leakage VALUES (
                r.child_table, r.child_column, r.parent_table, leak_count
            );
        END IF;
    END LOOP;
END $$;

SELECT *
FROM tmp_cross_site_leakage
ORDER BY mismatched_rows DESC, child_table;
