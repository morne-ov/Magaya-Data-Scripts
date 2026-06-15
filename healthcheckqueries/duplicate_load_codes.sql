-- Duplicate load codes in Weighbridge: same siteId + loadCode on more than one row.
-- Load codes should be unique per site.
-- PostgreSQL.

SELECT
    "siteId",
    "loadCode",
    COUNT(*)                                    AS duplicate_count,
    array_agg(id ORDER BY "createdAt", id)      AS weighbridge_ids,
    MIN("createdAt")                            AS first_created_at,
    MAX("createdAt")                            AS last_created_at
FROM "Weighbridge"
GROUP BY "siteId", "loadCode"
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC, "siteId", "loadCode";
