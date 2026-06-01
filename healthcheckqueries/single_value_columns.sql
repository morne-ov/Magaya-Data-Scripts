-- Find columns where every non-null row holds the same value
-- (i.e. COUNT(DISTINCT col) <= 1 across a non-empty table).
-- PostgreSQL.

DO $$
DECLARE
    r              RECORD;
    distinct_count BIGINT;
    non_null_count BIGINT;
    total_count    BIGINT;
    sample_value   TEXT;
BEGIN
    DROP TABLE IF EXISTS tmp_single_value_columns;
    CREATE TEMP TABLE tmp_single_value_columns (
        table_schema   TEXT,
        table_name     TEXT,
        column_name    TEXT,
        row_count      BIGINT,
        non_null_count BIGINT,
        distinct_count BIGINT,
        sample_value   TEXT
    );

    FOR r IN
        SELECT c.table_schema, c.table_name, c.column_name
        FROM information_schema.columns c
        JOIN information_schema.tables t
          ON t.table_schema = c.table_schema
         AND t.table_name   = c.table_name
        WHERE c.table_schema = 'public'
          AND t.table_type   = 'BASE TABLE'
        ORDER BY c.table_schema, c.table_name, c.ordinal_position
    LOOP
        EXECUTE format(
            'SELECT COUNT(*), COUNT(%1$I), COUNT(DISTINCT %1$I), MAX(%1$I::TEXT)
             FROM %2$I.%3$I',
            r.column_name, r.table_schema, r.table_name
        ) INTO total_count, non_null_count, distinct_count, sample_value;

        IF total_count > 0 AND non_null_count > 0 AND distinct_count = 1 THEN
            INSERT INTO tmp_single_value_columns VALUES (
                r.table_schema, r.table_name, r.column_name,
                total_count, non_null_count, distinct_count, sample_value
            );
        END IF;
    END LOOP;
END $$;

SELECT *
FROM tmp_single_value_columns
ORDER BY table_schema, table_name, column_name;
