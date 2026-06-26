-- ============================================================================
-- MIGRATION 002: Trusted Devices System
-- ============================================================================
-- Table pour les dispositifs de confiance permettant le bypass OTP
-- ============================================================================
-- ============================================================================
-- TABLE: trusted_devices
-- Stocke les dispositifs de confiance avec tokens hashés
-- ============================================================================
CREATE TABLE IF NOT EXISTS trusted_devices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    device_fingerprint TEXT NOT NULL,
    -- HMAC du device ID + salt côté client
    token_hash TEXT NOT NULL,
    -- HMAC-SHA256 du token de confiance
    device_name TEXT,
    -- Nom lisible: "Samsung Galaxy S23", etc.
    device_type TEXT CHECK (
        device_type IN ('android', 'ios', 'web', 'desktop')
    ),
    last_known_ip INET,
    last_user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    last_used_at TIMESTAMP WITH TIME ZONE,
    revoked_at TIMESTAMP WITH TIME ZONE,
    -- NULL si actif
    revoked_reason TEXT,
    -- Un seul dispositif de confiance par fingerprint par utilisateur
    CONSTRAINT unique_user_device UNIQUE (user_id, device_fingerprint)
);
-- Index pour les vérifications rapides
CREATE INDEX IF NOT EXISTS idx_trusted_devices_user ON trusted_devices(user_id)
WHERE revoked_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_trusted_devices_expires ON trusted_devices(expires_at)
WHERE revoked_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_trusted_devices_fingerprint ON trusted_devices(device_fingerprint);
-- Commentaires
COMMENT ON TABLE trusted_devices IS 'Dispositifs de confiance pour bypass OTP après confirmation initiale';
COMMENT ON COLUMN trusted_devices.device_fingerprint IS 'Hash du device ID généré côté client (HMAC)';
COMMENT ON COLUMN trusted_devices.token_hash IS 'Hash HMAC-SHA256 du token de confiance stocké côté client';
COMMENT ON COLUMN trusted_devices.revoked_at IS 'Date de révocation. NULL = dispositif actif';
-- ============================================================================
-- TABLE: trusted_device_events
-- Audit des événements liés aux dispositifs de confiance
-- ============================================================================
CREATE TABLE IF NOT EXISTS trusted_device_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_id UUID REFERENCES trusted_devices(id) ON DELETE
    SET NULL,
        user_id UUID NOT NULL,
        event_type TEXT NOT NULL CHECK (
            event_type IN (
                'created',
                'verified',
                'verification_failed',
                'expired',
                'revoked',
                'suspicious_activity'
            )
        ),
        ip_address INET,
        user_agent TEXT,
        metadata JSONB DEFAULT '{}',
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
-- Index pour l'audit
CREATE INDEX IF NOT EXISTS idx_trusted_device_events_user ON trusted_device_events(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_trusted_device_events_type ON trusted_device_events(event_type, created_at DESC);
-- Commentaires
COMMENT ON TABLE trusted_device_events IS 'Journal d''audit des événements dispositifs de confiance';
-- ============================================================================
-- Configuration des dispositifs de confiance
-- ============================================================================
INSERT INTO auth_config (key, value, description)
VALUES (
        'trusted_device_validity_days',
        '90',
        'Durée de validité d''un dispositif de confiance en jours'
    ),
    (
        'trusted_device_max_per_user',
        '5',
        'Nombre maximum de dispositifs de confiance par utilisateur'
    ),
    (
        'trusted_device_require_reverify_days',
        '30',
        'Jours avant de demander une re-vérification'
    ) ON CONFLICT (key) DO NOTHING;
-- ============================================================================
-- FUNCTION: create_trusted_device
-- Crée un nouveau dispositif de confiance et retourne le token plain
-- ============================================================================
CREATE OR REPLACE FUNCTION create_trusted_device(
        p_user_id UUID,
        p_device_fingerprint TEXT,
        p_device_name TEXT DEFAULT NULL,
        p_device_type TEXT DEFAULT 'android',
        p_ip_address INET DEFAULT NULL,
        p_user_agent TEXT DEFAULT NULL
    ) RETURNS TEXT AS $$
DECLARE v_token TEXT;
v_token_hash TEXT;
v_validity_days INTEGER;
v_max_devices INTEGER;
v_current_count INTEGER;
v_device_id UUID;
BEGIN -- Récupérer la configuration
v_validity_days := (
    get_auth_config('trusted_device_validity_days', '90')
)::INTEGER;
v_max_devices := (
    get_auth_config('trusted_device_max_per_user', '5')
)::INTEGER;
-- Vérifier le nombre de dispositifs existants
SELECT COUNT(*) INTO v_current_count
FROM trusted_devices
WHERE user_id = p_user_id
    AND revoked_at IS NULL;
IF v_current_count >= v_max_devices THEN -- Révoquer le plus ancien
UPDATE trusted_devices
SET revoked_at = NOW(),
    revoked_reason = 'max_devices_exceeded'
WHERE id = (
        SELECT id
        FROM trusted_devices
        WHERE user_id = p_user_id
            AND revoked_at IS NULL
        ORDER BY last_used_at ASC NULLS FIRST,
            created_at ASC
        LIMIT 1
    );
END IF;
-- Générer le token (UUID aléatoire)
v_token := encode(gen_random_bytes(32), 'hex');
-- Hasher le token
v_token_hash := encode(
    hmac(
        v_token,
        current_setting('app.trusted_device_secret', true),
        'sha256'
    ),
    'hex'
);
-- Créer ou mettre à jour le dispositif
INSERT INTO trusted_devices (
        user_id,
        device_fingerprint,
        token_hash,
        device_name,
        device_type,
        last_known_ip,
        last_user_agent,
        expires_at,
        last_used_at
    )
VALUES (
        p_user_id,
        p_device_fingerprint,
        v_token_hash,
        p_device_name,
        p_device_type,
        p_ip_address,
        p_user_agent,
        NOW() + (v_validity_days || ' days')::INTERVAL,
        NOW()
    ) ON CONFLICT (user_id, device_fingerprint) DO
UPDATE
SET token_hash = EXCLUDED.token_hash,
    device_name = COALESCE(
        EXCLUDED.device_name,
        trusted_devices.device_name
    ),
    last_known_ip = EXCLUDED.last_known_ip,
    last_user_agent = EXCLUDED.last_user_agent,
    expires_at = EXCLUDED.expires_at,
    last_used_at = NOW(),
    revoked_at = NULL,
    revoked_reason = NULL
RETURNING id INTO v_device_id;
-- Logger l'événement
INSERT INTO trusted_device_events (
        device_id,
        user_id,
        event_type,
        ip_address,
        user_agent
    )
VALUES (
        v_device_id,
        p_user_id,
        'created',
        p_ip_address,
        p_user_agent
    );
RETURN v_token;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- ============================================================================
-- FUNCTION: verify_trusted_device
-- Vérifie si un dispositif est de confiance et valide
-- ============================================================================
CREATE OR REPLACE FUNCTION verify_trusted_device(
        p_user_id UUID,
        p_device_fingerprint TEXT,
        p_token TEXT,
        p_ip_address INET DEFAULT NULL,
        p_user_agent TEXT DEFAULT NULL
    ) RETURNS BOOLEAN AS $$
DECLARE v_device RECORD;
v_computed_hash TEXT;
v_reverify_days INTEGER;
BEGIN -- Récupérer le dispositif
SELECT * INTO v_device
FROM trusted_devices
WHERE user_id = p_user_id
    AND device_fingerprint = p_device_fingerprint
    AND revoked_at IS NULL
    AND expires_at > NOW();
IF v_device IS NULL THEN -- Logger l'échec
INSERT INTO trusted_device_events (
        user_id,
        event_type,
        ip_address,
        user_agent,
        metadata
    )
VALUES (
        p_user_id,
        'verification_failed',
        p_ip_address,
        p_user_agent,
        '{"reason": "device_not_found"}'::JSONB
    );
RETURN FALSE;
END IF;
-- Vérifier le hash du token
v_computed_hash := encode(
    hmac(
        p_token,
        current_setting('app.trusted_device_secret', true),
        'sha256'
    ),
    'hex'
);
IF v_computed_hash != v_device.token_hash THEN -- Logger l'échec (possible token volé)
INSERT INTO trusted_device_events (
        device_id,
        user_id,
        event_type,
        ip_address,
        user_agent,
        metadata
    )
VALUES (
        v_device.id,
        p_user_id,
        'verification_failed',
        p_ip_address,
        p_user_agent,
        '{"reason": "invalid_token"}'::JSONB
    );
RETURN FALSE;
END IF;
-- Vérifier si une re-vérification est nécessaire
v_reverify_days := (
    get_auth_config('trusted_device_require_reverify_days', '30')
)::INTEGER;
IF v_device.last_used_at < NOW() - (v_reverify_days || ' days')::INTERVAL THEN -- Dispositif inactif depuis trop longtemps
INSERT INTO trusted_device_events (
        device_id,
        user_id,
        event_type,
        ip_address,
        user_agent,
        metadata
    )
VALUES (
        v_device.id,
        p_user_id,
        'verification_failed',
        p_ip_address,
        p_user_agent,
        '{"reason": "reverification_required"}'::JSONB
    );
RETURN FALSE;
END IF;
-- Mettre à jour le dispositif
UPDATE trusted_devices
SET last_used_at = NOW(),
    last_known_ip = COALESCE(p_ip_address, last_known_ip),
    last_user_agent = COALESCE(p_user_agent, last_user_agent)
WHERE id = v_device.id;
-- Logger le succès
INSERT INTO trusted_device_events (
        device_id,
        user_id,
        event_type,
        ip_address,
        user_agent
    )
VALUES (
        v_device.id,
        p_user_id,
        'verified',
        p_ip_address,
        p_user_agent
    );
RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- ============================================================================
-- FUNCTION: revoke_trusted_device
-- Révoque un dispositif de confiance
-- ============================================================================
CREATE OR REPLACE FUNCTION revoke_trusted_device(
        p_user_id UUID,
        p_device_id UUID,
        p_reason TEXT DEFAULT 'user_requested'
    ) RETURNS BOOLEAN AS $$
DECLARE v_updated INTEGER;
BEGIN
UPDATE trusted_devices
SET revoked_at = NOW(),
    revoked_reason = p_reason
WHERE id = p_device_id
    AND user_id = p_user_id
    AND revoked_at IS NULL;
GET DIAGNOSTICS v_updated = ROW_COUNT;
IF v_updated > 0 THEN
INSERT INTO trusted_device_events (device_id, user_id, event_type, metadata)
VALUES (
        p_device_id,
        p_user_id,
        'revoked',
        jsonb_build_object('reason', p_reason)
    );
RETURN TRUE;
END IF;
RETURN FALSE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- ============================================================================
-- FUNCTION: revoke_all_trusted_devices
-- Révoque tous les dispositifs d'un utilisateur
-- ============================================================================
CREATE OR REPLACE FUNCTION revoke_all_trusted_devices(
        p_user_id UUID,
        p_reason TEXT DEFAULT 'security_reset'
    ) RETURNS INTEGER AS $$
DECLARE v_count INTEGER;
BEGIN
UPDATE trusted_devices
SET revoked_at = NOW(),
    revoked_reason = p_reason
WHERE user_id = p_user_id
    AND revoked_at IS NULL;
GET DIAGNOSTICS v_count = ROW_COUNT;
IF v_count > 0 THEN
INSERT INTO trusted_device_events (user_id, event_type, metadata)
VALUES (
        p_user_id,
        'revoked',
        jsonb_build_object('reason', p_reason, 'count', v_count)
    );
END IF;
RETURN v_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- ============================================================================
-- RLS POLICIES
-- ============================================================================
ALTER TABLE trusted_devices ENABLE ROW LEVEL SECURITY;
ALTER TABLE trusted_device_events ENABLE ROW LEVEL SECURITY;
-- trusted_devices: utilisateur peut voir ses propres dispositifs
CREATE POLICY "trusted_devices_user_read" ON trusted_devices FOR
SELECT USING (auth.uid() = user_id);
CREATE POLICY "trusted_devices_service_all" ON trusted_devices FOR ALL USING (auth.role() = 'service_role');
-- trusted_device_events: service role uniquement
CREATE POLICY "trusted_device_events_service_only" ON trusted_device_events FOR ALL USING (auth.role() = 'service_role');