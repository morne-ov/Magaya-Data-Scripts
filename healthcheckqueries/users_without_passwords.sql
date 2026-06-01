-- Users that have no password set (NULL or empty string).
-- PostgreSQL.

SELECT
    id,
    "siteId",
    email,
    "password" IS NULL                  AS password_is_null,
    COALESCE("password", '') = ''       AS password_is_blank,
    "passwordSetupToken"   IS NOT NULL  AS has_setup_token,
    "passwordSetupExpires"
FROM "User"
WHERE "password" IS NULL
   OR "password" = ''
ORDER BY "siteId", email;
