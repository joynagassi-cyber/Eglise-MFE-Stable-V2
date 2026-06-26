-- role_permissions_seed.sql
-- MAPPING ROLE_PERMISSIONS (normalisé)
BEGIN;
-- Tous les superadmins globaux : toutes permissions, scope = all
INSERT INTO role_permissions (role_id, permission_id, scope_constraint)
SELECT r.id,
    p.id,
    'all'
FROM roles r
    CROSS JOIN permissions p
WHERE r.is_super = true
    AND r.scope = 'global'::role_scope ON CONFLICT DO NOTHING;
-- responsable_groupe
INSERT INTO role_permissions (role_id, permission_id, scope_constraint)
SELECT r.id,
    p.id,
    'group'
FROM roles r
    JOIN permissions p ON p.resource IN ('finance_transaction', 'members', 'events')
WHERE r.code = 'responsable_groupe' ON CONFLICT DO NOTHING;
-- organisateur_evenement
INSERT INTO role_permissions (role_id, permission_id, scope_constraint)
SELECT r.id,
    p.id,
    'group'
FROM roles r
    JOIN permissions p ON (
        (
            p.resource = 'finance_transaction'
            AND p.action IN ('read', 'write')
        )
        OR (
            p.resource = 'members'
            AND p.action = 'read'
        )
        OR (p.resource = 'events')
    )
WHERE r.code = 'organisateur_evenement' ON CONFLICT DO NOTHING;
-- validateur_transaction
INSERT INTO role_permissions (role_id, permission_id, scope_constraint)
SELECT r.id,
    p.id,
    'group'
FROM roles r
    JOIN permissions p ON (
        (
            p.resource = 'finance_transaction'
            AND p.action IN ('read', 'approve')
        )
        OR (p.resource = 'compliance')
    )
WHERE r.code = 'validateur_transaction' ON CONFLICT DO NOTHING;
-- membre_simple : profil self uniquement
INSERT INTO role_permissions (role_id, permission_id, scope_constraint)
SELECT r.id,
    p.id,
    'self'
FROM roles r
    JOIN permissions p ON p.resource = 'members'
    AND p.action = 'read'
WHERE r.code = 'membre_simple' ON CONFLICT DO NOTHING;
COMMIT;