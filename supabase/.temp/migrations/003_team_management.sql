-- ============================================================================
-- MIGRATION 003: Team Management System
-- ============================================================================
-- Tables pour la gestion des équipes, rôles, invitations et membres
-- ============================================================================
-- ============================================================================
-- TABLE: teams
-- Équipes/organisations (églises)
-- ============================================================================
CREATE TABLE IF NOT EXISTS teams (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    -- URL-friendly identifier
    description TEXT,
    owner_user_id UUID NOT NULL REFERENCES auth.users(id),
    logo_url TEXT,
    metadata JSONB DEFAULT '{}',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
-- Index
CREATE INDEX IF NOT EXISTS idx_teams_owner ON teams(owner_user_id);
CREATE INDEX IF NOT EXISTS idx_teams_slug ON teams(slug);
CREATE INDEX IF NOT EXISTS idx_teams_active ON teams(is_active)
WHERE is_active = TRUE;
-- Commentaires
COMMENT ON TABLE teams IS 'Équipes/organisations (églises) dans le système';
COMMENT ON COLUMN teams.slug IS 'Identifiant URL-friendly unique pour l''équipe';
-- ============================================================================
-- TABLE: team_roles
-- Rôles configurables avec permissions
-- ============================================================================
CREATE TABLE IF NOT EXISTS team_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    display_name TEXT,
    permissions JSONB NOT NULL DEFAULT '{}',
    is_default BOOLEAN DEFAULT FALSE,
    -- Rôle attribué par défaut aux nouveaux membres
    is_system BOOLEAN DEFAULT FALSE,
    -- Rôle système non supprimable
    priority INTEGER DEFAULT 0,
    -- Pour le tri (owner=100, admin=50, member=10)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT unique_team_role UNIQUE (team_id, name)
);
-- Index
CREATE INDEX IF NOT EXISTS idx_team_roles_team ON team_roles(team_id);
-- Commentaires
COMMENT ON TABLE team_roles IS 'Rôles personnalisables par équipe avec permissions JSONB';
COMMENT ON COLUMN team_roles.permissions IS 'Permissions JSON: {"members.read": true, "members.write": false, ...}';
-- ============================================================================
-- TABLE: team_invites
-- Invitations en attente
-- ============================================================================
CREATE TABLE IF NOT EXISTS team_invites (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    invited_email TEXT NOT NULL,
    role_name TEXT NOT NULL,
    -- Nom du rôle à attribuer
    token_hash TEXT NOT NULL,
    -- HMAC-SHA256 du token d'invitation
    message TEXT,
    -- Message personnalisé optionnel
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_by UUID NOT NULL REFERENCES auth.users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    accepted_at TIMESTAMP WITH TIME ZONE,
    accepted_by UUID REFERENCES auth.users(id),
    declined_at TIMESTAMP WITH TIME ZONE,
    revoked_at TIMESTAMP WITH TIME ZONE,
    revoked_by UUID REFERENCES auth.users(id),
    -- Une seule invitation active par email par équipe
    CONSTRAINT unique_pending_invite UNIQUE (team_id, invited_email) -- Note: Cette contrainte sera gérée par trigger pour les invitations non acceptées
);
-- Index
CREATE INDEX IF NOT EXISTS idx_team_invites_team ON team_invites(team_id);
CREATE INDEX IF NOT EXISTS idx_team_invites_email ON team_invites(invited_email);
CREATE INDEX IF NOT EXISTS idx_team_invites_pending ON team_invites(team_id, invited_email)
WHERE accepted_at IS NULL
    AND revoked_at IS NULL
    AND declined_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_team_invites_expires ON team_invites(expires_at)
WHERE accepted_at IS NULL;
-- Commentaires
COMMENT ON TABLE team_invites IS 'Invitations d''équipe en attente avec tokens hashés';
COMMENT ON COLUMN team_invites.token_hash IS 'Hash HMAC-SHA256 du token d''invitation';
-- ============================================================================
-- TABLE: team_members
-- Membres actifs des équipes
-- ============================================================================
CREATE TABLE IF NOT EXISTS team_members (
    team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role_name TEXT NOT NULL,
    invite_id UUID REFERENCES team_invites(id),
    -- Lien vers l'invitation d'origine
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    PRIMARY KEY (team_id, user_id)
);
-- Index
CREATE INDEX IF NOT EXISTS idx_team_members_user ON team_members(user_id);
CREATE INDEX IF NOT EXISTS idx_team_members_role ON team_members(team_id, role_name);
-- Commentaires
COMMENT ON TABLE team_members IS 'Membres actifs des équipes avec leur rôle';
-- ============================================================================
-- FUNCTION: create_team
-- Crée une équipe avec les rôles par défaut
-- ============================================================================
CREATE OR REPLACE FUNCTION create_team(
        p_name TEXT,
        p_slug TEXT,
        p_owner_user_id UUID,
        p_description TEXT DEFAULT NULL
    ) RETURNS UUID AS $$
DECLARE v_team_id UUID;
BEGIN -- Créer l'équipe
INSERT INTO teams (name, slug, owner_user_id, description)
VALUES (p_name, p_slug, p_owner_user_id, p_description)
RETURNING id INTO v_team_id;
-- Créer les rôles par défaut
INSERT INTO team_roles (
        team_id,
        name,
        display_name,
        permissions,
        is_system,
        priority
    )
VALUES (
        v_team_id,
        'owner',
        'Propriétaire',
        '{
            "team.manage": true,
            "team.delete": true,
            "members.read": true,
            "members.write": true,
            "members.delete": true,
            "invites.create": true,
            "invites.revoke": true,
            "roles.manage": true
        }'::JSONB,
        TRUE,
        100
    ),
    (
        v_team_id,
        'admin',
        'Administrateur',
        '{
            "team.manage": false,
            "members.read": true,
            "members.write": true,
            "members.delete": false,
            "invites.create": true,
            "invites.revoke": true,
            "roles.manage": false
        }'::JSONB,
        TRUE,
        50
    ),
    (
        v_team_id,
        'member',
        'Membre',
        '{
            "team.manage": false,
            "members.read": true,
            "members.write": false,
            "invites.create": false
        }'::JSONB,
        TRUE,
        10
    );
-- Ajouter le propriétaire comme membre
INSERT INTO team_members (team_id, user_id, role_name)
VALUES (v_team_id, p_owner_user_id, 'owner');
RETURN v_team_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- ============================================================================
-- FUNCTION: create_team_invite
-- Crée une invitation et retourne le token plain
-- ============================================================================
CREATE OR REPLACE FUNCTION create_team_invite(
        p_team_id UUID,
        p_invited_email TEXT,
        p_role_name TEXT,
        p_created_by UUID,
        p_message TEXT DEFAULT NULL,
        p_validity_days INTEGER DEFAULT 7
    ) RETURNS TEXT AS $$
DECLARE v_token TEXT;
v_token_hash TEXT;
v_existing_invite RECORD;
v_invite_id UUID;
BEGIN -- Vérifier que le rôle existe
IF NOT EXISTS (
    SELECT 1
    FROM team_roles
    WHERE team_id = p_team_id
        AND name = p_role_name
) THEN RAISE EXCEPTION 'ROLE_NOT_FOUND';
END IF;
-- Vérifier si l'utilisateur est déjà membre
IF EXISTS (
    SELECT 1
    FROM team_members tm
        JOIN auth.users u ON u.id = tm.user_id
    WHERE tm.team_id = p_team_id
        AND u.email = p_invited_email
) THEN RAISE EXCEPTION 'ALREADY_MEMBER';
END IF;
-- Vérifier/supprimer les invitations existantes
DELETE FROM team_invites
WHERE team_id = p_team_id
    AND invited_email = p_invited_email
    AND accepted_at IS NULL
    AND revoked_at IS NULL;
-- Générer le token (code court + UUID)
v_token := UPPER(
    SUBSTRING(
        encode(gen_random_bytes(3), 'hex')
        FROM 1 FOR 6
    )
);
-- Hasher le token
v_token_hash := encode(
    hmac(
        v_token,
        current_setting('app.invite_secret', true),
        'sha256'
    ),
    'hex'
);
-- Créer l'invitation
INSERT INTO team_invites (
        team_id,
        invited_email,
        role_name,
        token_hash,
        message,
        expires_at,
        created_by
    )
VALUES (
        p_team_id,
        LOWER(p_invited_email),
        p_role_name,
        v_token_hash,
        p_message,
        NOW() + (p_validity_days || ' days')::INTERVAL,
        p_created_by
    )
RETURNING id INTO v_invite_id;
RETURN v_token;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- ============================================================================
-- FUNCTION: accept_team_invite
-- Accepte une invitation par token
-- ============================================================================
CREATE OR REPLACE FUNCTION accept_team_invite(p_token TEXT, p_user_id UUID) RETURNS JSONB AS $$
DECLARE v_token_hash TEXT;
v_invite RECORD;
v_team_name TEXT;
BEGIN -- Hasher le token fourni
v_token_hash := encode(
    hmac(
        UPPER(p_token),
        current_setting('app.invite_secret', true),
        'sha256'
    ),
    'hex'
);
-- Trouver l'invitation
SELECT ti.*,
    t.name as team_name INTO v_invite
FROM team_invites ti
    JOIN teams t ON t.id = ti.team_id
WHERE ti.token_hash = v_token_hash
    AND ti.accepted_at IS NULL
    AND ti.revoked_at IS NULL
    AND ti.declined_at IS NULL
    AND ti.expires_at > NOW();
IF v_invite IS NULL THEN -- Vérifier si le token existe mais est expiré/utilisé
IF EXISTS (
    SELECT 1
    FROM team_invites
    WHERE token_hash = v_token_hash
) THEN RETURN jsonb_build_object(
    'success',
    FALSE,
    'error',
    'INVITE_EXPIRED_OR_USED'
);
END IF;
RETURN jsonb_build_object('success', FALSE, 'error', 'INVITE_NOT_FOUND');
END IF;
-- Vérifier si déjà membre (idempotence)
IF EXISTS (
    SELECT 1
    FROM team_members
    WHERE team_id = v_invite.team_id
        AND user_id = p_user_id
) THEN -- Mettre à jour l'invitation comme acceptée
UPDATE team_invites
SET accepted_at = NOW(),
    accepted_by = p_user_id
WHERE id = v_invite.id
    AND accepted_at IS NULL;
RETURN jsonb_build_object(
    'success',
    TRUE,
    'team_id',
    v_invite.team_id,
    'team_name',
    v_invite.team_name,
    'role_name',
    v_invite.role_name,
    'already_member',
    TRUE
);
END IF;
-- Ajouter comme membre
INSERT INTO team_members (team_id, user_id, role_name, invite_id)
VALUES (
        v_invite.team_id,
        p_user_id,
        v_invite.role_name,
        v_invite.id
    );
-- Marquer l'invitation comme acceptée
UPDATE team_invites
SET accepted_at = NOW(),
    accepted_by = p_user_id
WHERE id = v_invite.id;
RETURN jsonb_build_object(
    'success',
    TRUE,
    'team_id',
    v_invite.team_id,
    'team_name',
    v_invite.team_name,
    'role_name',
    v_invite.role_name,
    'already_member',
    FALSE
);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- ============================================================================
-- FUNCTION: check_team_permission
-- Vérifie si un utilisateur a une permission spécifique
-- ============================================================================
CREATE OR REPLACE FUNCTION check_team_permission(
        p_team_id UUID,
        p_user_id UUID,
        p_permission TEXT
    ) RETURNS BOOLEAN AS $$
DECLARE v_permissions JSONB;
BEGIN
SELECT tr.permissions INTO v_permissions
FROM team_members tm
    JOIN team_roles tr ON tr.team_id = tm.team_id
    AND tr.name = tm.role_name
WHERE tm.team_id = p_team_id
    AND tm.user_id = p_user_id;
IF v_permissions IS NULL THEN RETURN FALSE;
END IF;
RETURN COALESCE((v_permissions->>p_permission)::BOOLEAN, FALSE);
END;
$$ LANGUAGE plpgsql STABLE;
-- ============================================================================
-- TRIGGER: update_team_updated_at
-- Met à jour updated_at automatiquement
-- ============================================================================
CREATE OR REPLACE FUNCTION update_updated_at() RETURNS TRIGGER AS $$ BEGIN NEW.updated_at = NOW();
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER teams_updated_at BEFORE
UPDATE ON teams FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER team_members_updated_at BEFORE
UPDATE ON team_members FOR EACH ROW EXECUTE FUNCTION update_updated_at();
-- ============================================================================
-- Configuration des invitations
-- ============================================================================
INSERT INTO auth_config (key, value, description)
VALUES (
        'invite_validity_days',
        '7',
        'Durée de validité d''une invitation en jours'
    ),
    (
        'invite_max_per_team_day',
        '50',
        'Maximum d''invitations par équipe par jour'
    ) ON CONFLICT (key) DO NOTHING;
-- ============================================================================
-- RLS POLICIES
-- ============================================================================
ALTER TABLE teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE team_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE team_invites ENABLE ROW LEVEL SECURITY;
ALTER TABLE team_members ENABLE ROW LEVEL SECURITY;
-- teams: membres peuvent lire, owner/admin peuvent modifier
CREATE POLICY "teams_member_read" ON teams FOR
SELECT USING (
        EXISTS (
            SELECT 1
            FROM team_members
            WHERE team_members.team_id = teams.id
                AND team_members.user_id = auth.uid()
        )
        OR auth.role() = 'service_role'
    );
CREATE POLICY "teams_admin_write" ON teams FOR
UPDATE USING (
        check_team_permission(id, auth.uid(), 'team.manage')
        OR auth.role() = 'service_role'
    );
CREATE POLICY "teams_service_insert" ON teams FOR
INSERT WITH CHECK (
        auth.role() = 'service_role'
        OR owner_user_id = auth.uid()
    );
-- team_roles: membres peuvent lire
CREATE POLICY "team_roles_member_read" ON team_roles FOR
SELECT USING (
        EXISTS (
            SELECT 1
            FROM team_members
            WHERE team_members.team_id = team_roles.team_id
                AND team_members.user_id = auth.uid()
        )
        OR auth.role() = 'service_role'
    );
CREATE POLICY "team_roles_service_write" ON team_roles FOR ALL USING (auth.role() = 'service_role');
-- team_invites: créateur peut voir, service role tout
CREATE POLICY "team_invites_creator_read" ON team_invites FOR
SELECT USING (
        created_by = auth.uid()
        OR check_team_permission(team_id, auth.uid(), 'invites.create')
        OR auth.role() = 'service_role'
    );
CREATE POLICY "team_invites_service_write" ON team_invites FOR ALL USING (auth.role() = 'service_role');
-- team_members: membres peuvent se voir entre eux
CREATE POLICY "team_members_read" ON team_members FOR
SELECT USING (
        EXISTS (
            SELECT 1
            FROM team_members tm
            WHERE tm.team_id = team_members.team_id
                AND tm.user_id = auth.uid()
        )
        OR auth.role() = 'service_role'
    );
CREATE POLICY "team_members_service_write" ON team_members FOR ALL USING (auth.role() = 'service_role');