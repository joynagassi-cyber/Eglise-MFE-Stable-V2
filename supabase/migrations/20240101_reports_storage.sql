-- Migration: Stockage des rapports PDF
-- Date: 2024
-- Description: Créer bucket Storage et table reports pour historiser les rapports générés

-- ============================================
-- 1. CRÉER BUCKET STORAGE
-- ============================================

-- Créer bucket pour rapports (privé)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'reports',
  'reports',
  false,
  10485760, -- 10MB max
  ARRAY['application/pdf', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'image/png']
);

-- ============================================
-- 2. CRÉER TABLE REPORTS
-- ============================================

CREATE TABLE reports (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  church_id UUID NOT NULL REFERENCES churches(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  type TEXT NOT NULL CHECK (type IN ('event', 'member', 'finance')),
  title TEXT NOT NULL,
  file_path TEXT NOT NULL,
  file_size INTEGER,
  mime_type TEXT,
  start_date DATE,
  end_date DATE,
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 3. INDEXES
-- ============================================

CREATE INDEX idx_reports_church_date ON reports(church_id, created_at DESC);
CREATE INDEX idx_reports_user ON reports(user_id, created_at DESC);
CREATE INDEX idx_reports_type ON reports(type);

-- ============================================
-- 4. RLS POLICIES - TABLE
-- ============================================

ALTER TABLE reports ENABLE ROW LEVEL SECURITY;

-- Lecture: Utilisateurs de l'église
CREATE POLICY "Users can view church reports"
  ON reports FOR SELECT
  USING (
    church_id IN (
      SELECT church_id FROM user_churches WHERE user_id = auth.uid()
    )
  );

-- Insertion: Utilisateurs authentifiés
CREATE POLICY "Users can create reports"
  ON reports FOR INSERT
  WITH CHECK (
    auth.uid() = user_id AND
    church_id IN (
      SELECT church_id FROM user_churches WHERE user_id = auth.uid()
    )
  );

-- Suppression: Créateur uniquement
CREATE POLICY "Users can delete own reports"
  ON reports FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================
-- 5. RLS POLICIES - STORAGE
-- ============================================

-- Upload: Utilisateurs authentifiés dans leur dossier
CREATE POLICY "Users can upload reports"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'reports' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- Download: Utilisateurs de l'église
CREATE POLICY "Users can download church reports"
  ON storage.objects FOR SELECT
  USING (
    bucket_id = 'reports' AND
    EXISTS (
      SELECT 1 FROM reports r
      WHERE r.file_path = name
      AND r.church_id IN (
        SELECT church_id FROM user_churches WHERE user_id = auth.uid()
      )
    )
  );

-- Delete: Créateur uniquement
CREATE POLICY "Users can delete own report files"
  ON storage.objects FOR DELETE
  USING (
    bucket_id = 'reports' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- ============================================
-- 6. FONCTION CLEANUP (Optionnel)
-- ============================================

-- Supprimer fichiers orphelins après suppression de metadata
CREATE OR REPLACE FUNCTION cleanup_report_files()
RETURNS TRIGGER AS $$
BEGIN
  -- Supprimer le fichier du storage
  PERFORM storage.delete_object('reports', OLD.file_path);
  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER cleanup_report_files_trigger
  AFTER DELETE ON reports
  FOR EACH ROW
  EXECUTE FUNCTION cleanup_report_files();

-- ============================================
-- 7. FONCTION STATS (Optionnel)
-- ============================================

CREATE OR REPLACE FUNCTION get_report_stats(p_church_id UUID)
RETURNS TABLE (
  total_reports BIGINT,
  total_size BIGINT,
  reports_by_type JSONB
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    COUNT(*)::BIGINT,
    SUM(file_size)::BIGINT,
    jsonb_object_agg(type, count) as reports_by_type
  FROM (
    SELECT type, COUNT(*) as count
    FROM reports
    WHERE church_id = p_church_id
    GROUP BY type
  ) t;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
