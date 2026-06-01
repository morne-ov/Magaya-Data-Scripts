-- Sessions whose expiresAt is in the past — should have been cleaned up.
-- PostgreSQL.

SELECT
    s.id,
    s."siteId",
    s."userId",
    u.email,
    s."expiresAt",
    NOW() - s."expiresAt" AS expired_for
FROM "Session" s
LEFT JOIN "User" u ON u.id = s."userId"
WHERE s."expiresAt" < NOW()
ORDER BY s."expiresAt" ASC;

-- Summary aggregate
SELECT
    COUNT(*)                         AS expired_session_count,
    MIN("expiresAt")                 AS oldest,
    MAX("expiresAt")                 AS most_recent
FROM "Session"
WHERE "expiresAt" < NOW();
