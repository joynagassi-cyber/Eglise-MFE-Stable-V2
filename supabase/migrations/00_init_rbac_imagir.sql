-- 00_init_rbac_imagir.sql
-- Script SQL (Postgres / Supabase) : création des tables RBAC,
-- insertions roles & users initiaux
-- Exécuter dans une seule transaction.
BEGIN;
-- Extension UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
-- ENUM pour scope
DO $$ BEGIN IF NOT EXISTS (
    SELECT 1
    FROM pg_type
    WHERE typname = 'role_scope'
) THEN CREATE TYPE role_scope AS ENUM ('global', 'group', 'self');
END IF;
END $$;
-- ============================================================
-- 1) TABLE ROLES
-- ============================================================
CREATE TABLE IF NOT EXISTS roles (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    code text UNIQUE NOT NULL,
    label text NOT NULL,
    scope role_scope NOT NULL DEFAULT 'group',
    priority_level int NOT NULL DEFAULT 100,
    is_super boolean NOT NULL DEFAULT false,
    permissions jsonb DEFAULT '{}'::jsonb,
    created_at timestamptz NOT NULL DEFAULT now()
);
-- ============================================================
-- 2) TABLE PERMISSIONS (catalogue explicite)
-- ============================================================
CREATE TABLE IF NOT EXISTS permissions (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    resource text NOT NULL,
    action text NOT NULL,
    description text,
    created_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE(resource, action)
);
-- ============================================================
-- 3) TABLE ROLE_PERMISSIONS (mapping normalisé)
-- ============================================================
CREATE TABLE IF NOT EXISTS role_permissions (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    role_id uuid NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    permission_id uuid NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
    scope_constraint text NOT NULL DEFAULT 'all',
    created_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE(role_id, permission_id)
);
-- ============================================================
-- 4) TABLE GROUPS
-- ============================================================
CREATE TABLE IF NOT EXISTS groups (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    code text UNIQUE NOT NULL,
    label text NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now()
);
-- ============================================================
-- 5) TABLE USERS
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    email text UNIQUE,
    name text,
    status text DEFAULT 'active',
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamptz NOT NULL DEFAULT now()
);
-- ============================================================
-- 6) TABLE USER_ROLES
-- ============================================================
CREATE TABLE IF NOT EXISTS user_roles (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role_id uuid NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    group_id uuid NULL REFERENCES groups(id) ON DELETE
    SET NULL,
        assigned_at timestamptz NOT NULL DEFAULT now(),
        UNIQUE(user_id, role_id, group_id)
);
-- ============================================================
-- 7) TABLE USER_SESSIONS
-- ============================================================
CREATE TABLE IF NOT EXISTS user_sessions (
    user_id uuid PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    active_role_id uuid NULL REFERENCES roles(id),
    active_group_id uuid NULL REFERENCES groups(id),
    last_switch timestamptz NOT NULL DEFAULT now()
);
-- ============================================================
-- 8) TABLE AUDIT_USER_ROLES
-- ============================================================
CREATE TABLE IF NOT EXISTS audit_user_roles (
    id bigserial PRIMARY KEY,
    user_role_id uuid,
    actor_user_id uuid,
    action text,
    details jsonb,
    occurred_at timestamptz NOT NULL DEFAULT now()
);
-- ============================================================
-- INDEX
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_user_roles_user ON user_roles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_roles_group ON user_roles(group_id);
CREATE INDEX IF NOT EXISTS idx_roles_code ON roles(code);
-- ============================================================
-- INSERTIONS : CATALOGUE DE PERMISSIONS
-- ============================================================
INSERT INTO permissions (resource, action, description)
VALUES (
        'finance_transaction',
        'read',
        'Lire transactions financières'
    ),
    (
        'finance_transaction',
        'write',
        'Créer/Modifier transactions (draft)'
    ),
    (
        'finance_transaction',
        'approve',
        'Approuver transaction'
    ),
    (
        'finance_transaction',
        'export',
        'Exporter comptabilité / FEC'
    ),
    ('members', 'read', 'Lire profils membres'),
    ('members', 'write', 'Créer/Modifier membres'),
    ('audit', 'view', 'Voir logs d audit'),
    ('audit', 'export', 'Exporter logs'),
    (
        'compliance',
        'validate',
        'Valider conformité (Art.55/57)'
    ),
    (
        'compliance',
        'seal',
        'Sceller pièce justificative'
    ),
    ('events', 'create', 'Créer événement'),
    ('events', 'edit', 'Modifier événement'),
    ('events', 'delete', 'Supprimer événement') ON CONFLICT DO NOTHING;
-- ============================================================
-- INSERTIONS : RÔLES SUPERADMINS
-- ============================================================
INSERT INTO roles (
        code,
        label,
        scope,
        priority_level,
        is_super,
        permissions
    )
VALUES (
        'super_admin',
        'Super Admin',
        'global',
        1,
        true,
        '{
      "finance":{"read":"all","write":"all","approve":"all","export":"all"},
      "members":{"read":"all","write":"all"},
      "audit":{"view":true,"export":true},
      "compliance":{"validate":true,"seal":true},
      "events":{"create":"all","edit":"all","delete":"all"}
    }'::jsonb
    ),
    (
        'president',
        'Président',
        'global',
        2,
        true,
        '{}'::jsonb
    ),
    (
        'vice_president',
        'Vice-Président',
        'global',
        3,
        true,
        '{}'::jsonb
    ),
    (
        'tresorier',
        'Trésorier',
        'global',
        4,
        true,
        '{}'::jsonb
    ),
    (
        'tresorier_adjoint',
        'Trésorier Adjoint',
        'global',
        5,
        true,
        '{}'::jsonb
    ),
    (
        'comptable',
        'Comptable',
        'global',
        6,
        true,
        '{}'::jsonb
    ),
    (
        'comptable_adjoint',
        'Comptable Adjoint',
        'global',
        7,
        true,
        '{}'::jsonb
    ),
    (
        'auditeur',
        'Auditeur Interne',
        'global',
        8,
        true,
        '{}'::jsonb
    ),
    (
        'commissaire_aux_comptes',
        'Commissaire aux Comptes',
        'global',
        9,
        true,
        '{}'::jsonb
    ),
    (
        'commissaire_aux_comptes_adjoint',
        'Commissaire aux Comptes Adjoint',
        'global',
        10,
        true,
        '{}'::jsonb
    ),
    ('pasteur', 'Pasteur', 'global', 11, true, '{}'::jsonb),
    (
        'secretaire_general',
        'Secrétaire Général',
        'global',
        12,
        true,
        '{}'::jsonb
    ),
    (
        'secretaire_adjoint',
        'Secrétaire Adjoint',
        'global',
        13,
        true,
        '{}'::jsonb
    ),
    (
        'conseiller',
        'Conseiller',
        'global',
        14,
        true,
        '{}'::jsonb
    ),
    (
        'conseiller_adjoint',
        'Conseiller Adjoint',
        'global',
        15,
        true,
        '{}'::jsonb
    ) ON CONFLICT (code) DO NOTHING;
-- ============================================================
-- INSERTIONS : RÔLES GROUPE
-- ============================================================
INSERT INTO roles (
        code,
        label,
        scope,
        priority_level,
        is_super,
        permissions
    )
VALUES (
        'responsable_groupe',
        'Responsable de Groupe',
        'group',
        50,
        false,
        '{
      "finance":{"read":"group","write":"draft","approve":"none","export":"none"},
      "members":{"read":"group","write":"group"},
      "audit":{"view":false},
      "events":{"create":"group","edit":"group","delete":"group"},
      "compliance":{"validate":false,"seal":false}
    }'::jsonb
    ),
    (
        'organisateur_evenement',
        'Organisateur événement',
        'group',
        60,
        false,
        '{
      "finance":{"read":"group","write":"draft"},
      "events":{"create":"group","edit":"group","delete":"group"},
      "members":{"read":"group"}
    }'::jsonb
    ),
    (
        'validateur_transaction',
        'Validateur Transaction',
        'group',
        55,
        false,
        '{
      "finance":{"read":"group","approve":"group"},
      "compliance":{"validate":"group","seal":"group"}
    }'::jsonb
    ) ON CONFLICT (code) DO NOTHING;
-- ============================================================
-- INSERTIONS : RÔLE MEMBRE SIMPLE
-- ============================================================
INSERT INTO roles (
        code,
        label,
        scope,
        priority_level,
        is_super,
        permissions
    )
VALUES (
        'membre_simple',
        'Membre simple',
        'self',
        100,
        false,
        '{
      "members":{"read":"self"},
      "events":{"create":"none"}
    }'::jsonb
    ) ON CONFLICT (code) DO NOTHING;
-- ============================================================
-- INSERTIONS : GROUPES
-- ============================================================
INSERT INTO groups (code, label)
VALUES ('chorale', 'Chorale'),
    ('hommes', 'Groupe Hommes'),
    ('femmes', 'Groupe Femmes'),
    ('jeunesse', 'Jeunesse'),
    ('enfants', 'Enfants'),
    ('intercession', 'Intercession') ON CONFLICT DO NOTHING;
-- ============================================================
-- INSERTIONS : UTILISATEURS EXEMPLES
-- ============================================================
INSERT INTO users (id, email, name)
VALUES (
        '11111111-1111-1111-1111-111111111111'::uuid,
        'admin@imagir.local',
        'Admin Super'
    ),
    (
        '22222222-2222-2222-2222-222222222222'::uuid,
        'president@imagir.local',
        'Président Test'
    ),
    (
        '33333333-3333-3333-3333-333333333333'::uuid,
        'chorale@imagir.local',
        'Chef Chorale Test'
    ) ON CONFLICT DO NOTHING;
-- ============================================================
-- AFFECTATION RÔLES AUX UTILISATEURS
-- ============================================================
-- Admin → super_admin
INSERT INTO user_roles (user_id, role_id, group_id)
SELECT '11111111-1111-1111-1111-111111111111'::uuid,
    r.id,
    NULL
FROM roles r
WHERE r.code = 'super_admin' ON CONFLICT DO NOTHING;
-- Président → president (global)
INSERT INTO user_roles (user_id, role_id, group_id)
SELECT '22222222-2222-2222-2222-222222222222'::uuid,
    r.id,
    NULL
FROM roles r
WHERE r.code = 'president' ON CONFLICT DO NOTHING;
-- Chef chorale → responsable_groupe sur chorale
INSERT INTO user_roles (user_id, role_id, group_id)
SELECT '33333333-3333-3333-3333-333333333333'::uuid,
    r.id,
    g.id
FROM roles r
    CROSS JOIN groups g
WHERE r.code = 'responsable_groupe'
    AND g.code = 'chorale' ON CONFLICT DO NOTHING;
-- ============================================================
-- INITIALISATION SESSIONS
-- ============================================================
INSERT INTO user_sessions (user_id, active_role_id, active_group_id)
SELECT u.id,
    (
        SELECT id
        FROM roles
        WHERE code = 'super_admin'
    ),
    NULL
FROM users u
WHERE u.id = '11111111-1111-1111-1111-111111111111' ON CONFLICT (user_id) DO
UPDATE
SET active_role_id = EXCLUDED.active_role_id,
    last_switch = now();
INSERT INTO user_sessions (user_id, active_role_id, active_group_id)
SELECT u.id,
    (
        SELECT id
        FROM roles
        WHERE code = 'president'
    ),
    NULL
FROM users u
WHERE u.id = '22222222-2222-2222-2222-222222222222' ON CONFLICT (user_id) DO
UPDATE
SET active_role_id = EXCLUDED.active_role_id,
    last_switch = now();
INSERT INTO user_sessions (user_id, active_role_id, active_group_id)
SELECT u.id,
    (
        SELECT id
        FROM roles
        WHERE code = 'responsable_groupe'
    ),
    (
        SELECT id
        FROM groups
        WHERE code = 'chorale'
    )
FROM users u
WHERE u.id = '33333333-3333-3333-3333-333333333333' ON CONFLICT (user_id) DO
UPDATE
SET active_role_id = EXCLUDED.active_role_id,
    active_group_id = EXCLUDED.active_group_id,
    last_switch = now();
COMMIT;