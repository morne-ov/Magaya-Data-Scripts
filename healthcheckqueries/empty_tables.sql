-- Empty tables in the public schema — features that have never been used,
-- or models that may be obsolete and could be dropped.
-- PostgreSQL.

DO $$
DECLARE
    r           RECORD;
    row_count   BIGINT;
BEGIN
    DROP TABLE IF EXISTS tmp_empty_tables;
    CREATE TEMP TABLE tmp_empty_tables (table_name TEXT);

    FOR r IN
        SELECT table_schema, table_name
        FROM information_schema.tables
        WHERE table_schema = 'public'
          AND table_type   = 'BASE TABLE'
    LOOP
        EXECUTE format('SELECT COUNT(*) FROM %I.%I', r.table_schema, r.table_name)
        INTO row_count;

        IF row_count = 0 THEN
            INSERT INTO tmp_empty_tables VALUES (r.table_name);
        END IF;
    END LOOP;
END $$;

SELECT * FROM tmp_empty_tables ORDER BY table_name;
