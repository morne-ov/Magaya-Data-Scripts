-- Users whose passwordSetupExpires is in the past, but who still have no password.
-- They cannot finish onboarding and cannot log in — they need a fresh invite.
-- PostgreSQL.

SELECT
    id,
    "siteId",
    email,
    "firstName",
    "lastName",
    "passwordSetupExpires",
    NOW() - "passwordSetupExpires" AS expired_for
FROM "User"
WHERE ("password" IS NULL OR "password" = '')
  AND "passwordSetupExpires" IS NOT NULL
  AND "passwordSetupExpires" < NOW()
ORDER BY "passwordSetupExpires" ASC;
