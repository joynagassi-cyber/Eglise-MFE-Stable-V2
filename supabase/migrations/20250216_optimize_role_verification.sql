-- Migration: Optimisation RPC - Fonction combinée
-- Date: 2025-02-16
-- Description: Réduit 2 appels DB en 1 seul pour vérification + récupération rôle

-- Fonction combinée pour vérifier code ET retourner rôle complet
CREATE OR REPLACE FUNCTION verify_and_get_role(
  p_code TEXT,
  p_user_id UUID DEFAULT NULL
) RETURNS TABLE(
  role_code TEXT,
  role_id TEXT,
  role_label TEXT,
  is_super BOOLEAN,
  scope TEXT
) AS $$
DECLARE
  v_success BOOLEAN;
BEGIN
  -- Vérifier et retourner le rôle en une seule requête
  RETURN QUERY
  SELECT 
    r.code,
    r.id,
    r.label,
    r.is_super,
    r.scope
  FROM role_secret_codes rsc
  JOIN roles r ON r.code = rsc.role_code
  WHERE crypt(p_code, rsc.code_hash) = rsc.code_hash
  AND NOT rsc.is_used;
  
  -- Log attempt
  v_success := FOUND;
  PERFORM log_role_code_attempt(p_code, p_user_id, v_success);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION verify_and_get_role IS 'Vérifie un code secret et retourne le rôle complet en 1 seul appel (optimisé)';
