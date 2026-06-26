-- Migration: RLS Policies pour drive_files et audit_logs
-- Date: 2025-01-28
-- Description: Sécuriser accès avec Row Level Security

-- Activer RLS
ALTER TABLE drive_files ENABLE ROW LEVEL SECURITY;
ALTER TABLE drive_audit_logs ENABLE ROW LEVEL SECURITY;

-- ============================================
-- DRIVE_FILES POLICIES
-- ============================================

-- SELECT: Voir fichiers de son église
CREATE POLICY "Users view own church files"
ON drive_files FOR SELECT
USING (
  church_id IN (
    SELECT church_id FROM user_churches 
    WHERE user_id = auth.uid()
  )
  AND deleted_at IS NULL
);

-- INSERT: Upload photos membres
CREATE POLICY "Members upload photos"
ON drive_files FOR INSERT
WITH CHECK (
  entity_type = 'member_photo'
  AND entity_id = auth.uid()
  AND church_id IN (SELECT church_id FROM user_churches WHERE user_id = auth.uid())
);

-- INSERT: Upload factures (trésoriers)
CREATE POLICY "Treasurers upload invoices"
ON drive_files FOR INSERT
WITH CHECK (
  entity_type IN ('invoice', 'justificatif')
  AND EXISTS (
    SELECT 1 FROM user_roles
    WHERE user_id = auth.uid()
    AND role IN ('admin', 'treasurer')
  )
);

-- UPDATE: Modifier brouillons
CREATE POLICY "Users update own drafts"
ON drive_files FOR UPDATE
USING (
  status = 'draft'
  AND uploaded_by = auth.uid()
)
WITH CHECK (
  status = 'draft'
);

-- UPDATE: Sceller factures (admins)
CREATE POLICY "Admins seal invoices"
ON drive_files FOR UPDATE
USING (
  status = 'validated'
  AND entity_type = 'invoice'
  AND EXISTS (
    SELECT 1 FROM user_roles
    WHERE user_id = auth.uid()
    AND role IN ('admin', 'treasurer')
  )
)
WITH CHECK (
  status = 'sealed'
);

-- UPDATE: Soft delete brouillons
CREATE POLICY "Users delete own drafts"
ON drive_files FOR UPDATE
USING (
  status = 'draft'
  AND uploaded_by = auth.uid()
  AND deleted_at IS NULL
)
WITH CHECK (
  deleted_at IS NOT NULL
);

-- ============================================
-- AUDIT_LOGS POLICIES
-- ============================================

-- SELECT: Admins voient tout, users leurs actions
CREATE POLICY "Users view own audit logs"
ON drive_audit_logs FOR SELECT
USING (
  actor_id = auth.uid()
  OR EXISTS (
    SELECT 1 FROM user_roles
    WHERE user_id = auth.uid()
    AND role = 'admin'
  )
);

-- INSERT: Service role uniquement
CREATE POLICY "Service inserts audit logs"
ON drive_audit_logs FOR INSERT
WITH CHECK (true);

-- ============================================
-- FONCTIONS HELPER
-- ============================================

CREATE OR REPLACE FUNCTION can_access_file(p_file_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM drive_files
    WHERE id = p_file_id
    AND church_id IN (
      SELECT church_id FROM user_churches WHERE user_id = auth.uid()
    )
    AND deleted_at IS NULL
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION has_role(p_role TEXT)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM user_roles
    WHERE user_id = auth.uid()
    AND role = p_role
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
