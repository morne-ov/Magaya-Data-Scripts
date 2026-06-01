-- For every public table that has a `createdAt` column, report:
--   - the most recent createdAt
--   - rows inserted in the last 30 / 90 days
-- Useful for finding tables nothing writes to anymore.
-- PostgreSQL.

DO $$
DECLARE
    r              RECORD;
    last_created   TIMESTAMP;
    last_30        BIGINT;
    last_90        BIGINT;
    total          BIGINT;
BEGIN
    DROP TABLE IF EXISTS tmp_stale_tables;
    CREATE TEMP TABLE tmp_stale_tables (
        table_name      TEXT,
        row_count       BIGINT,
        last_created_at TIMESTAMP,
        rows_last_30d   BIGINT,
        rows_last_90d   BIGINT
    );

    FOR r IN
        SELECT c.table_schema, c.table_name
        FROM information_schema.columns c
        JOIN information_schema.tables t
          ON t.table_schema = c.table_schema
         AND t.table_name   = c.table_name
        WHERE c.column_name  = 'createdAt'
          AND c.table_schema = 'public'
          AND t.table_type   = 'BASE TABLE'
    LOOP
        EXECUTE format(
            'SELECT COUNT(*),
                    MAX("createdAt"),
                    COUNT(*) FILTER (WHERE "createdAt" >= NOW() - INTERVAL ''30 days''),
                    COUNT(*) FILTER (WHERE "createdAt" >= NOW() - INTERVAL ''90 days'')
             FROM %I.%I',
            r.table_schema, r.table_name
        ) INTO total, last_created, last_30, last_90;

        INSERT INTO tmp_stale_tables VALUES (
            r.table_name, total, last_created, last_30, last_90
        );
    END LOOP;
END $$;

SELECT *
FROM tmp_stale_tables
ORDER BY last_created_at NULLS FIRST, table_name;
