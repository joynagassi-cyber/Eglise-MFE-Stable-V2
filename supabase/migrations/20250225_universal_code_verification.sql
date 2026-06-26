-- Migration: Universal Code Verification RPC
-- Date: 2025-02-25
-- Description: Unifie la vérification des codes de rôles et des codes de groupes
CREATE OR REPLACE FUNCTION verify_universal_code(p_code TEXT, p_user_id UUID DEFAULT NULL) RETURNS TABLE(
        role_code TEXT,
        role_id UUID,
        role_label TEXT,
        is_super BOOLEAN,
        scope TEXT,
        group_id UUID
    ) AS $$
DECLARE v_success BOOLEAN;
BEGIN -- 1. Chercher dans les codes de rôles globaux
RETURN QUERY
SELECT r.code as role_code,
    r.id as role_id,
    r.label as role_label,
    r.is_super,
    r.scope,
    NULL::UUID as group_id
FROM role_secret_codes rsc
    JOIN roles r ON r.code = rsc.role_code
WHERE crypt(p_code, rsc.code_hash) = rsc.code_hash
    AND NOT rsc.is_used;
IF FOUND THEN PERFORM log_role_code_attempt(p_code, p_user_id, true);
RETURN;
END IF;
-- 2. Chercher dans les codes de groupes
RETURN QUERY
SELECT 'responsable_groupe'::TEXT as role_code,
    -- On assume responsable par défaut pour ces codes
    r.id as role_id,
    'Responsable de ' || g.label as role_label,
    false as is_super,
    'group'::TEXT as scope,
    g.id as group_id
FROM group_secret_codes gsc
    JOIN groups g ON g.id = gsc.group_id
    JOIN roles r ON r.code = 'responsable_groupe'
WHERE crypt(p_code, gsc.code_hash) = gsc.code_hash
    AND NOT gsc.is_used;
v_success := FOUND;
-- On pourrait ajouter un log spécifique pour les groupes si besoin
-- PERFORM log_role_code_attempt(p_code, p_user_id, v_success);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
COMMENT ON FUNCTION verify_universal_code IS 'Vérifie un code secret (global ou groupe) et retourne les infos du rôle + groupe éventuel.';