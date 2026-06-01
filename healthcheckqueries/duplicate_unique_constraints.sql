-- Verify @@unique constraints actually hold: groups by the unique columns
-- (treating NULL as a value) and reports any group with > 1 row.
-- Picks up both single- and multi-column UNIQUE constraints.
-- PostgreSQL.

DO $$
DECLARE
    r            RECORD;
    dup_count    BIGINT;
    col_list     TEXT;
    group_list   TEXT;
BEGIN
    DROP TABLE IF EXISTS tmp_duplicate_uniques;
    CREATE TEMP TABLE tmp_duplicate_uniques (
        table_name       TEXT,
        constraint_name  TEXT,
        columns          TEXT,
        duplicate_groups BIGINT
    );

    FOR r IN
        SELECT
            tc.table_schema,
            tc.table_name,
            tc.constraint_name,
            array_agg(kcu.column_name ORDER BY kcu.ordinal_position) AS cols
        FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu
          ON tc.constraint_name = kcu.constraint_name
         AND tc.table_schema    = kcu.table_schema
        WHERE tc.constraint_type = 'UNIQUE'
          AND tc.table_schema    = 'public'
        GROUP BY tc.table_schema, tc.table_name, tc.constraint_name
    LOOP
        SELECT string_agg(format('%I', c), ', '),
               string_agg(format('%I', c), ', ')
        INTO col_list, group_list
        FROM unnest(r.cols) AS c;

        EXECUTE format(
            'SELECT COUNT(*) FROM (
                 SELECT 1 FROM %I.%I
                 GROUP BY %s
                 HAVING COUNT(*) > 1
             ) d',
            r.table_schema, r.table_name, group_list
        ) INTO dup_count;

        IF dup_count > 0 THEN
            INSERT INTO tmp_duplicate_uniques VALUES (
                r.table_name, r.constraint_name, col_list, dup_count
            );
        END IF;
    END LOOP;
END $$;

SELECT *
FROM tmp_duplicate_uniques
ORDER BY duplicate_groups DESC, table_name;
