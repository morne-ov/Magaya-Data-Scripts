-- For every table in the public schema that has a `siteId` column,
-- report how many rows have siteId IS NULL.
-- PostgreSQL.

DO $$
DECLARE
    r            RECORD;
    null_count   BIGINT;
    total_count  BIGINT;
BEGIN
    DROP TABLE IF EXISTS tmp_null_siteid;
    CREATE TEMP TABLE tmp_null_siteid (
        table_schema   TEXT,
        table_name     TEXT,
        row_count      BIGINT,
        null_siteid    BIGINT
    );

    FOR r IN
        SELECT c.table_schema, c.table_name
        FROM information_schema.columns c
        JOIN information_schema.tables t
          ON t.table_schema = c.table_schema
         AND t.table_name   = c.table_name
        WHERE c.column_name  = 'siteId'
          AND c.table_schema = 'public'
          AND t.table_type   = 'BASE TABLE'
    LOOP
        EXECUTE format(
            'SELECT COUNT(*), COUNT(*) FILTER (WHERE "siteId" IS NULL) FROM %I.%I',
            r.table_schema, r.table_name
        ) INTO total_count, null_count;

        INSERT INTO tmp_null_siteid VALUES (
            r.table_schema, r.table_name, total_count, null_count
        );
    END LOOP;
END $$;

SELECT *
FROM tmp_null_siteid
WHERE null_siteid > 0
ORDER BY null_siteid DESC, table_name;
