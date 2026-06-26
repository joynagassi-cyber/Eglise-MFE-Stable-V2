-- Migration: Système de codes secrets universels
-- Date: 2025-02-15
-- Description: Code unique par rôle pour validation d'identité

CREATE TABLE IF NOT EXISTS role_secret_codes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  role_code TEXT NOT NULL UNIQUE REFERENCES roles(code) ON DELETE CASCADE,
  code_hash TEXT NOT NULL,
  is_used BOOLEAN DEFAULT false,
  used_by_user_id UUID REFERENCES auth.users(id),
  used_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_role_codes_role ON role_secret_codes(role_code);
CREATE INDEX idx_role_codes_used ON role_secret_codes(is_used);

ALTER TABLE role_secret_codes ENABLE ROW LEVEL SECURITY;

-- RLS: Seuls superadmins peuvent voir les codes
CREATE POLICY "Superadmins can manage codes"
  ON role_secret_codes FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM user_roles ur
      JOIN roles r ON ur.role_id = r.id
      WHERE ur.user_id = auth.uid() AND r.is_super = true
    )
  );

-- Fonction de vérification sécurisée
CREATE OR REPLACE FUNCTION verify_role_secret_code(
  p_role_code TEXT,
  p_code TEXT
) RETURNS BOOLEAN AS $$
DECLARE
  v_code_hash TEXT;
  v_is_used BOOLEAN;
BEGIN
  SELECT code_hash, is_used INTO v_code_hash, v_is_used
  FROM role_secret_codes
  WHERE role_code = p_role_code;
  
  IF v_code_hash IS NULL THEN
    RETURN false; -- Code n'existe pas
  END IF;
  
  IF v_is_used THEN
    RETURN false; -- Code déjà utilisé
  END IF;
  
  -- Vérifier le hash
  RETURN crypt(p_code, v_code_hash) = v_code_hash;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Fonction pour marquer comme utilisé
CREATE OR REPLACE FUNCTION mark_role_code_as_used(
  p_role_code TEXT,
  p_user_id UUID
) RETURNS VOID AS $$
BEGIN
  UPDATE role_secret_codes
  SET is_used = true,
      used_by_user_id = p_user_id,
      used_at = NOW(),
      updated_at = NOW()
  WHERE role_code = p_role_code;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Seed codes pour TOUS les rôles (sauf membre_simple)
-- Format: CODE-ROLE-2025 (exemple: SUPER-ADMIN-2025)
INSERT INTO role_secret_codes (role_code, code_hash)
SELECT 
  code,
  crypt(UPPER(REPLACE(code, '_', '-')) || '-2025', gen_salt('bf'))
FROM roles
WHERE code != 'membre_simple'
ON CONFLICT (role_code) DO NOTHING;

COMMENT ON TABLE role_secret_codes IS 'Codes secrets pour validation d''identité par rôle';
COMMENT ON FUNCTION verify_role_secret_code IS 'Vérifie un code secret sans exposer le hash';
