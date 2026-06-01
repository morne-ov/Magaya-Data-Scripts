-- Users that have no role assigned, OR a role with no permissions attached.
-- These users effectively can't do anything in the app.
-- PostgreSQL.

-- 1) Users with no roleId at all
SELECT
    'no_role'           AS issue,
    u.id,
    u."siteId",
    u.email,
    u."roleId",
    NULL::text          AS role_name,
    0::bigint           AS permission_count
FROM "User" u
WHERE u."roleId" IS NULL

UNION ALL

-- 2) Users whose role exists but has zero UserPermission rows
SELECT
    'role_has_no_permissions' AS issue,
    u.id,
    u."siteId",
    u.email,
    u."roleId",
    r.name              AS role_name,
    COUNT(p.id)         AS permission_count
FROM "User" u
JOIN "UserRole" r        ON r.id = u."roleId"
LEFT JOIN "UserPermission" p ON p."roleId" = r.id
GROUP BY u.id, u."siteId", u.email, u."roleId", r.name
HAVING COUNT(p.id) = 0

ORDER BY issue, "siteId", email;
