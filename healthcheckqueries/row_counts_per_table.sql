-- Row count for every base table in the public schema.
-- Uses dynamic SQL (exact COUNT(*)) so the numbers are accurate, not estimates.
-- For a faster, approximate version use pg_class.reltuples.
-- PostgreSQL.

DO $$
DECLARE
    r           RECORD;
    row_count   BIGINT;
BEGIN
    DROP TABLE IF EXISTS tmp_row_counts;
    CREATE TEMP TABLE tmp_row_counts (
        table_schema TEXT,
        table_name   TEXT,
        row_count    BIGINT
    );

    FOR r IN
        SELECT table_schema, table_name
        FROM information_schema.tables
        WHERE table_schema = 'public'
          AND table_type   = 'BASE TABLE'
    LOOP
        EXECUTE format('SELECT COUNT(*) FROM %I.%I', r.table_schema, r.table_name)
        INTO row_count;

        INSERT INTO tmp_row_counts VALUES (r.table_schema, r.table_name, row_count);
    END LOOP;
END $$;

SELECT *
FROM tmp_row_counts
ORDER BY row_count DESC, table_name;

-- Fast estimate alternative (uses planner stats — refresh with ANALYZE):
-- SELECT relname AS table_name, reltuples::BIGINT AS estimated_rows
-- FROM pg_class c
-- JOIN pg_namespace n ON n.oid = c.relnamespace
-- WHERE n.nspname = 'public' AND c.relkind = 'r'
-- ORDER BY reltuples DESC;
