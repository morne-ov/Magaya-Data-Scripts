-- Find columns in the current schema where every row is NULL (or the table is empty).
-- PostgreSQL. Generates a row per column with a boolean `all_null` flag.
--
-- Usage: run as-is to scan the 'public' schema, or change the schema filter below.

DO $$
DECLARE
    r              RECORD;
    null_count     BIGINT;
    total_count    BIGINT;
BEGIN
    DROP TABLE IF EXISTS tmp_all_null_columns;
    CREATE TEMP TABLE tmp_all_null_columns (
        table_schema TEXT,
        table_name   TEXT,
        column_name  TEXT,
        row_count    BIGINT,
        non_null_count BIGINT,
        all_null     BOOLEAN
    );

    FOR r IN
        SELECT c.table_schema, c.table_name, c.column_name
        FROM information_schema.columns c
        JOIN information_schema.tables t
          ON t.table_schema = c.table_schema
         AND t.table_name   = c.table_name
        WHERE c.table_schema NOT IN ('pg_catalog', 'information_schema')
          AND c.table_schema = 'public'           -- adjust schema here
          AND t.table_type   = 'BASE TABLE'
        ORDER BY c.table_schema, c.table_name, c.ordinal_position
    LOOP
        EXECUTE format(
            'SELECT COUNT(*), COUNT(%I) FROM %I.%I',
            r.column_name, r.table_schema, r.table_name
        ) INTO total_count, null_count;

        INSERT INTO tmp_all_null_columns VALUES (
            r.table_schema,
            r.table_name,
            r.column_name,
            total_count,
            null_count,
            (null_count = 0)
        );
    END LOOP;
END $$;

SELECT *
FROM tmp_all_null_columns
WHERE all_null = TRUE
  AND row_count > 0   -- exclude empty tables; remove this line to include them
ORDER BY table_schema, table_name, column_name;
