-- Migration: Logs d'audit pour tentatives de codes secrets
-- Date: 2025-02-16
-- Description: Traçabilité complète des tentatives de vérification de codes

-- Table d'audit
CREATE TABLE IF NOT EXISTS role_code_audit_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code_attempt TEXT NOT NULL,
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  success BOOLEAN NOT NULL,
  ip_address INET,
  user_agent TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index pour requêtes fréquentes
CREATE INDEX idx_audit_user_id ON role_code_audit_log(user_id);
CREATE INDEX idx_audit_created_at ON role_code_audit_log(created_at DESC);
CREATE INDEX idx_audit_success ON role_code_audit_log(success);

-- RLS
ALTER TABLE role_code_audit_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Only superadmins can view audit logs"
  ON role_code_audit_log FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM user_roles ur
      JOIN roles r ON r.id = ur.role_id
      WHERE ur.user_id = auth.uid()
      AND r.is_super = TRUE
    )
  );

-- Fonction de logging
CREATE OR REPLACE FUNCTION log_role_code_attempt(
  p_code TEXT,
  p_user_id UUID,
  p_success BOOLEAN,
  p_ip_address INET DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
  INSERT INTO role_code_audit_log (code_attempt, user_id, success, ip_address)
  VALUES (p_code, p_user_id, p_success, p_ip_address);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Modifier fonction de vérification pour logger
CREATE OR REPLACE FUNCTION verify_role_secret_code(
  p_role_code TEXT,
  p_code TEXT,
  p_user_id UUID DEFAULT NULL
) RETURNS BOOLEAN AS $$
DECLARE
  v_result BOOLEAN;
BEGIN
  v_result := EXISTS (
    SELECT 1 FROM role_secret_codes
    WHERE role_code = p_role_code
    AND crypt(p_code, code_hash) = code_hash
    AND NOT is_used
  );
  
  -- Log attempt
  PERFORM log_role_code_attempt(p_code, p_user_id, v_result);
  
  RETURN v_result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Fonction pour nettoyer les vieux logs (>90 jours)
CREATE OR REPLACE FUNCTION cleanup_old_audit_logs() RETURNS INTEGER AS $$
DECLARE
  v_deleted INTEGER;
BEGIN
  DELETE FROM role_code_audit_log
  WHERE created_at < NOW() - INTERVAL '90 days';
  
  GET DIAGNOSTICS v_deleted = ROW_COUNT;
  RETURN v_deleted;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON TABLE role_code_audit_log IS 'Logs de toutes les tentatives de vérification de codes secrets';
COMMENT ON FUNCTION log_role_code_attempt IS 'Enregistre une tentative de vérification de code';
COMMENT ON FUNCTION cleanup_old_audit_logs IS 'Nettoie les logs de plus de 90 jours';
