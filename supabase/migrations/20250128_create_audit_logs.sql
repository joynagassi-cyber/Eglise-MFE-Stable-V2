-- Migration: Créer table audit_logs avec chaînage blockchain
-- Date: 2025-01-28
-- Description: Piste audit immuable avec hash chaîné

CREATE TYPE drive_audit_action AS ENUM (
  'upload',
  'view',
  'download',
  'validate',
  'seal',
  'delete',
  'restore'
);

CREATE TABLE drive_audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  file_id UUID NOT NULL REFERENCES drive_files(id) ON DELETE CASCADE,
  action drive_audit_action NOT NULL,
  actor_id UUID NOT NULL REFERENCES auth.users(id),
  actor_ip INET,
  actor_user_agent TEXT,
  timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  previous_log_hash TEXT,
  current_log_hash TEXT NOT NULL,
  metadata JSONB DEFAULT '{}'::jsonb,
  CONSTRAINT unique_hash UNIQUE (current_log_hash)
);

-- Indexes
CREATE INDEX idx_audit_file ON drive_audit_logs(file_id, timestamp DESC);
CREATE INDEX idx_audit_actor ON drive_audit_logs(actor_id, timestamp DESC);
CREATE INDEX idx_audit_action ON drive_audit_logs(action, timestamp DESC);
CREATE INDEX idx_audit_timestamp ON drive_audit_logs(timestamp DESC);

-- Fonction: Calculer hash chaîné
CREATE OR REPLACE FUNCTION compute_audit_log_hash(
  p_file_id UUID,
  p_action TEXT,
  p_actor_id UUID,
  p_timestamp TIMESTAMPTZ,
  p_previous_hash TEXT
) RETURNS TEXT AS $$
DECLARE
  v_data TEXT;
BEGIN
  v_data := p_file_id::TEXT || '|' || p_action || '|' || p_actor_id::TEXT || '|' || p_timestamp::TEXT || '|' || COALESCE(p_previous_hash, 'GENESIS');
  RETURN encode(digest(v_data, 'sha256'), 'hex');
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Trigger: Auto-calculer hash
CREATE OR REPLACE FUNCTION set_audit_log_hash()
RETURNS TRIGGER AS $$
DECLARE
  v_previous_hash TEXT;
BEGIN
  SELECT current_log_hash INTO v_previous_hash
  FROM drive_audit_logs
  WHERE file_id = NEW.file_id
  ORDER BY timestamp DESC
  LIMIT 1;
  
  NEW.previous_log_hash := v_previous_hash;
  NEW.current_log_hash := compute_audit_log_hash(
    NEW.file_id,
    NEW.action::TEXT,
    NEW.actor_id,
    NEW.timestamp,
    v_previous_hash
  );
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_set_audit_log_hash
  BEFORE INSERT ON drive_audit_logs
  FOR EACH ROW
  EXECUTE FUNCTION set_audit_log_hash();

-- Fonction: Vérifier intégrité chaîne
CREATE OR REPLACE FUNCTION verify_audit_chain(p_file_id UUID)
RETURNS TABLE(is_valid BOOLEAN, broken_at UUID) AS $$
DECLARE
  v_log RECORD;
  v_expected_hash TEXT;
BEGIN
  FOR v_log IN 
    SELECT * FROM drive_audit_logs 
    WHERE file_id = p_file_id 
    ORDER BY timestamp ASC
  LOOP
    v_expected_hash := compute_audit_log_hash(
      v_log.file_id,
      v_log.action::TEXT,
      v_log.actor_id,
      v_log.timestamp,
      v_log.previous_log_hash
    );
    
    IF v_expected_hash != v_log.current_log_hash THEN
      RETURN QUERY SELECT false, v_log.id;
      RETURN;
    END IF;
  END LOOP;
  
  RETURN QUERY SELECT true, NULL::UUID;
END;
$$ LANGUAGE plpgsql;

-- Vue: Historique fichier
CREATE VIEW drive_file_history AS
SELECT 
  df.id AS file_id,
  df.original_filename,
  dal.action,
  dal.timestamp,
  u.email AS actor_email,
  dal.actor_ip,
  dal.current_log_hash
FROM drive_audit_logs dal
JOIN drive_files df ON dal.file_id = df.id
JOIN auth.users u ON dal.actor_id = u.id
ORDER BY dal.timestamp DESC;
