-- Rows in Stockpile / Job / Execution with createdAt that is either in the
-- future or absurdly old (before 2020-01-01) — likely seed or import bugs.
-- PostgreSQL.

WITH bounds AS (
    SELECT
        TIMESTAMP '2020-01-01' AS too_old,
        NOW()                  AS now_ts
)
SELECT 'Stockpile' AS table_name, id, "siteId", "createdAt",
       CASE
           WHEN "createdAt" > (SELECT now_ts FROM bounds)  THEN 'future'
           WHEN "createdAt" < (SELECT too_old FROM bounds) THEN 'absurdly_old'
       END AS issue
FROM "Stockpile"
WHERE "createdAt" > (SELECT now_ts FROM bounds)
   OR "createdAt" < (SELECT too_old FROM bounds)

UNION ALL
SELECT 'Job', id, "siteId", "createdAt",
       CASE
           WHEN "createdAt" > NOW()                     THEN 'future'
           WHEN "createdAt" < TIMESTAMP '2020-01-01'    THEN 'absurdly_old'
       END
FROM "Job"
WHERE "createdAt" > NOW()
   OR "createdAt" < TIMESTAMP '2020-01-01'

UNION ALL
SELECT 'Execution', id, "siteId", "createdAt",
       CASE
           WHEN "createdAt" > NOW()                     THEN 'future'
           WHEN "createdAt" < TIMESTAMP '2020-01-01'    THEN 'absurdly_old'
       END
FROM "Execution"
WHERE "createdAt" > NOW()
   OR "createdAt" < TIMESTAMP '2020-01-01'

ORDER BY table_name, "createdAt";
