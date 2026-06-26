-- Migration: Codes secrets pour responsables de groupe
-- Date: 2025-02-15

CREATE TABLE IF NOT EXISTS group_secret_codes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  group_id UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
  role_type TEXT NOT NULL CHECK (role_type IN ('responsable', 'validateur', 'organisateur')),
  code_hash TEXT NOT NULL,
  is_used BOOLEAN DEFAULT false,
  used_by_user_id UUID REFERENCES auth.users(id),
  used_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  
  UNIQUE(group_id, role_type)
);

CREATE INDEX idx_group_codes_group ON group_secret_codes(group_id);
CREATE INDEX idx_group_codes_used ON group_secret_codes(is_used);

ALTER TABLE group_secret_codes ENABLE ROW LEVEL SECURITY;

-- Fonction de vérification
CREATE OR REPLACE FUNCTION verify_group_secret_code(
  p_group_id UUID,
  p_role_type TEXT,
  p_code TEXT
) RETURNS BOOLEAN AS $$
DECLARE
  v_code_hash TEXT;
  v_is_used BOOLEAN;
BEGIN
  SELECT code_hash, is_used INTO v_code_hash, v_is_used
  FROM group_secret_codes
  WHERE group_id = p_group_id AND role_type = p_role_type;
  
  IF v_code_hash IS NULL OR v_is_used THEN
    RETURN false;
  END IF;
  
  RETURN crypt(p_code, v_code_hash) = v_code_hash;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Seed codes pour les 6 groupes
INSERT INTO group_secret_codes (group_id, role_type, code_hash) 
SELECT id, 'responsable', crypt('CHEF-' || UPPER(code) || '-2025', gen_salt('bf'))
FROM groups
ON CONFLICT DO NOTHING;

INSERT INTO group_secret_codes (group_id, role_type, code_hash)
SELECT id, 'validateur', crypt('VALIDATEUR-' || UPPER(code) || '-2025', gen_salt('bf'))
FROM groups
ON CONFLICT DO NOTHING;

INSERT INTO group_secret_codes (group_id, role_type, code_hash)
SELECT id, 'organisateur', crypt('ORGANISATEUR-' || UPPER(code) || '-2025', gen_salt('bf'))
FROM groups
ON CONFLICT DO NOTHING;
