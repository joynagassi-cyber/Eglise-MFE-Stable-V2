-- ============================================================================
-- MIGRATION 004: Activity Log & Audit Trail
-- ============================================================================
-- Table centralisée pour l'audit de toutes les actions du système
-- ============================================================================
-- ============================================================================
-- TABLE: activity_log
-- Journal d'activité centralisé
-- ============================================================================
CREATE TABLE IF NOT EXISTS activity_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    action TEXT NOT NULL,
    -- Type d'action: 'team.created', 'member.joined', etc.
    actor_user_id UUID,
    -- Utilisateur qui a effectué l'action
    actor_type TEXT DEFAULT 'user' CHECK (
        actor_type IN ('user', 'system', 'trigger', 'cron')
    ),
    target_type TEXT,
    -- Type de cible: 'team', 'member', 'invite', 'device'
    target_id UUID,
    -- ID de la cible
    related_ids JSONB DEFAULT '{}',
    -- IDs additionnels pour le contexte
    metadata JSONB DEFAULT '{}',
    -- Données supplémentaires
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
-- Index pour les requêtes fréquentes
CREATE INDEX IF NOT EXISTS idx_activity_log_actor ON activity_log(actor_user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_activity_log_action ON activity_log(action, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_activity_log_target ON activity_log(target_type, target_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_activity_log_time ON activity_log(created_at DESC);
-- Index GIN pour recherche dans metadata
CREATE INDEX IF NOT EXISTS idx_activity_log_metadata ON activity_log USING GIN (metadata);
-- Commentaires
COMMENT ON TABLE activity_log IS 'Journal d''audit centralisé pour toutes les actions du système';
COMMENT ON COLUMN activity_log.action IS 'Format: domain.action (ex: team.created, member.joined, otp.verified)';
COMMENT ON COLUMN activity_log.related_ids IS 'IDs additionnels: {"team_id": "...", "invite_id": "..."}';
-- ============================================================================
-- FUNCTION: log_activity
-- Fonction helper pour créer des entrées de log
-- ============================================================================
CREATE OR REPLACE FUNCTION log_activity(
        p_action TEXT,
        p_actor_user_id UUID DEFAULT NULL,
        p_actor_type TEXT DEFAULT 'user',
        p_target_type TEXT DEFAULT NULL,
        p_target_id UUID DEFAULT NULL,
        p_related_ids JSONB DEFAULT '{}',
        p_metadata JSONB DEFAULT '{}',
        p_ip_address INET DEFAULT NULL,
        p_user_agent TEXT DEFAULT NULL
    ) RETURNS UUID AS $$
DECLARE v_log_id UUID;
BEGIN
INSERT INTO activity_log (
        action,
        actor_user_id,
        actor_type,
        target_type,
        target_id,
        related_ids,
        metadata,
        ip_address,
        user_agent
    )
VALUES (
        p_action,
        p_actor_user_id,
        p_actor_type,
        p_target_type,
        p_target_id,
        p_related_ids,
        p_metadata,
        p_ip_address,
        p_user_agent
    )
RETURNING id INTO v_log_id;
RETURN v_log_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- ============================================================================
-- TRIGGER: log_team_member_changes
-- Log automatique des changements de membres d'équipe
-- ============================================================================
CREATE OR REPLACE FUNCTION trigger_log_team_member_change() RETURNS TRIGGER AS $$ BEGIN IF TG_OP = 'INSERT' THEN PERFORM log_activity(
        'member.joined',
        NEW.user_id,
        'user',
        'team_member',
        NEW.user_id,
        jsonb_build_object('team_id', NEW.team_id),
        jsonb_build_object(
            'role_name',
            NEW.role_name,
            'invite_id',
            NEW.invite_id
        )
    );
RETURN NEW;
ELSIF TG_OP = 'UPDATE' THEN IF OLD.role_name != NEW.role_name THEN PERFORM log_activity(
    'member.role_changed',
    NEW.user_id,
    'system',
    'team_member',
    NEW.user_id,
    jsonb_build_object('team_id', NEW.team_id),
    jsonb_build_object(
        'old_role',
        OLD.role_name,
        'new_role',
        NEW.role_name
    )
);
END IF;
RETURN NEW;
ELSIF TG_OP = 'DELETE' THEN PERFORM log_activity(
    'member.removed',
    OLD.user_id,
    'system',
    'team_member',
    OLD.user_id,
    jsonb_build_object('team_id', OLD.team_id),
    jsonb_build_object('role_name', OLD.role_name)
);
RETURN OLD;
END IF;
RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
CREATE TRIGGER team_members_activity_log
AFTER
INSERT
    OR
UPDATE
    OR DELETE ON team_members FOR EACH ROW EXECUTE FUNCTION trigger_log_team_member_change();
-- ============================================================================
-- TRIGGER: log_team_invite_changes
-- Log automatique des changements d'invitations
-- ============================================================================
CREATE OR REPLACE FUNCTION trigger_log_team_invite_change() RETURNS TRIGGER AS $$ BEGIN IF TG_OP = 'INSERT' THEN PERFORM log_activity(
        'invite.created',
        NEW.created_by,
        'user',
        'team_invite',
        NEW.id,
        jsonb_build_object('team_id', NEW.team_id),
        jsonb_build_object(
            'invited_email',
            NEW.invited_email,
            'role_name',
            NEW.role_name
        )
    );
RETURN NEW;
ELSIF TG_OP = 'UPDATE' THEN IF OLD.accepted_at IS NULL
AND NEW.accepted_at IS NOT NULL THEN PERFORM log_activity(
    'invite.accepted',
    NEW.accepted_by,
    'user',
    'team_invite',
    NEW.id,
    jsonb_build_object('team_id', NEW.team_id),
    jsonb_build_object(
        'invited_email',
        NEW.invited_email,
        'role_name',
        NEW.role_name
    )
);
ELSIF OLD.revoked_at IS NULL
AND NEW.revoked_at IS NOT NULL THEN PERFORM log_activity(
    'invite.revoked',
    NEW.revoked_by,
    'user',
    'team_invite',
    NEW.id,
    jsonb_build_object('team_id', NEW.team_id),
    jsonb_build_object('invited_email', NEW.invited_email)
);
ELSIF OLD.declined_at IS NULL
AND NEW.declined_at IS NOT NULL THEN PERFORM log_activity(
    'invite.declined',
    NULL,
    'user',
    'team_invite',
    NEW.id,
    jsonb_build_object('team_id', NEW.team_id),
    jsonb_build_object('invited_email', NEW.invited_email)
);
END IF;
RETURN NEW;
END IF;
RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
CREATE TRIGGER team_invites_activity_log
AFTER
INSERT
    OR
UPDATE ON team_invites FOR EACH ROW EXECUTE FUNCTION trigger_log_team_invite_change();
-- ============================================================================
-- VIEW: recent_activity
-- Vue des activités récentes pour le dashboard
-- ============================================================================
CREATE OR REPLACE VIEW recent_activity AS
SELECT al.id,
    al.action,
    al.actor_user_id,
    COALESCE(u.raw_user_meta_data->>'full_name', u.email) as actor_name,
    al.target_type,
    al.target_id,
    al.related_ids,
    al.metadata,
    al.created_at,
    CASE
        WHEN al.action LIKE 'member.%' THEN '👥'
        WHEN al.action LIKE 'invite.%' THEN '✉️'
        WHEN al.action LIKE 'team.%' THEN '🏢'
        WHEN al.action LIKE 'otp.%' THEN '🔐'
        WHEN al.action LIKE 'device.%' THEN '📱'
        ELSE '📝'
    END as icon
FROM activity_log al
    LEFT JOIN auth.users u ON u.id = al.actor_user_id
ORDER BY al.created_at DESC;
-- ============================================================================
-- FUNCTION: cleanup_old_activity_logs
-- Nettoyage des vieux logs (à exécuter via pg_cron)
-- ============================================================================
CREATE OR REPLACE FUNCTION cleanup_old_activity_logs(p_retention_days INTEGER DEFAULT 90) RETURNS INTEGER AS $$
DECLARE deleted_count INTEGER;
BEGIN
DELETE FROM activity_log
WHERE created_at < NOW() - (p_retention_days || ' days')::INTERVAL;
GET DIAGNOSTICS deleted_count = ROW_COUNT;
-- Log le nettoyage lui-même
PERFORM log_activity(
    'system.cleanup',
    NULL,
    'cron',
    'activity_log',
    NULL,
    '{}',
    jsonb_build_object(
        'deleted_count',
        deleted_count,
        'retention_days',
        p_retention_days
    )
);
RETURN deleted_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- ============================================================================
-- Configuration du nettoyage
-- ============================================================================
INSERT INTO auth_config (key, value, description)
VALUES (
        'activity_log_retention_days',
        '90',
        'Durée de conservation des logs d''activité en jours'
    ),
    (
        'otp_attempts_retention_days',
        '30',
        'Durée de conservation des tentatives OTP en jours'
    ) ON CONFLICT (key) DO NOTHING;
-- ============================================================================
-- RLS POLICIES
-- ============================================================================
ALTER TABLE activity_log ENABLE ROW LEVEL SECURITY;
-- activity_log: utilisateur peut voir ses propres activités
CREATE POLICY "activity_log_user_read" ON activity_log FOR
SELECT USING (
        actor_user_id = auth.uid()
        OR auth.role() = 'service_role'
    );
CREATE POLICY "activity_log_service_write" ON activity_log FOR ALL USING (auth.role() = 'service_role');