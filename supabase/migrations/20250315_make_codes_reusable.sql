-- Migration: Rendre les codes secrets réutilisables à l'infini
-- Date: 2025-03-15
-- Description: Met à jour les fonctions de vérification pour ignorer la colonne is_used

-- 1. Mettre à jour verify_universal_code pour ignorer is_used
CREATE OR REPLACE FUNCTION verify_universal_code(p_code TEXT, p_user_id UUID DEFAULT NULL) RETURNS TABLE(
        role_code TEXT,
        role_id UUID,
        role_label TEXT,
        is_super BOOLEAN,
        scope TEXT,
        group_id UUID
    ) AS $$
DECLARE v_success BOOLEAN;
BEGIN 
-- 1. Chercher dans les codes de rôles globaux
RETURN QUERY
SELECT r.code as role_code,
    r.id as role_id,
    r.label as role_label,
    r.is_super,
    r.scope,
    NULL::UUID as group_id
FROM role_secret_codes rsc
    JOIN roles r ON r.code = rsc.role_code
WHERE crypt(p_code, rsc.code_hash) = rsc.code_hash;
-- Remarquez que la condition `AND NOT rsc.is_used` a été retirée

IF FOUND THEN 
    PERFORM log_role_code_attempt(p_code, p_user_id, true);
    RETURN;
END IF;

-- 2. Chercher dans les codes de groupes
RETURN QUERY
SELECT 'responsable_groupe'::TEXT as role_code,
    r.id as role_id,
    'Responsable de ' || g.label as role_label,
    false as is_super,
    'group'::TEXT as scope,
    g.id as group_id
FROM group_secret_codes gsc
    JOIN groups g ON g.id = gsc.group_id
    JOIN roles r ON r.code = 'responsable_groupe'
WHERE crypt(p_code, gsc.code_hash) = gsc.code_hash;
-- Idem, la condition `AND NOT gsc.is_used` a été retirée

v_success := FOUND;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- 2. Mettre à jour verify_role_secret_code pour ignorer is_used
CREATE OR REPLACE FUNCTION verify_role_secret_code(
  p_role_code TEXT,
  p_code TEXT
) RETURNS BOOLEAN AS $$
DECLARE
  v_code_hash TEXT;
BEGIN
  SELECT code_hash INTO v_code_hash
  FROM role_secret_codes
  WHERE role_code = p_role_code;
  
  IF v_code_hash IS NULL THEN
    RETURN false; -- Code n'existe pas
  END IF;
  
  -- Vérifier le hash
  RETURN crypt(p_code, v_code_hash) = v_code_hash;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. (Optionnel mais recommandé) Désactiver mark_role_code_as_used pour minimiser la confusion
CREATE OR REPLACE FUNCTION mark_role_code_as_used(
  p_role_code TEXT,
  p_user_id UUID
) RETURNS VOID AS $$
BEGIN
  -- Ne rien faire car les codes sont désormais réutilisables à l'infini
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
