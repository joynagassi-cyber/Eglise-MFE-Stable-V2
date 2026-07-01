-- ═══════════════════════════════════════════════════════════════════════════════
-- AI Social Features - Phase 1
-- Date: 2026-06-30
-- Purpose: Ajouter les champs IA à social_posts, créer moderation_reports
--          et ai_queue, mettre à jour les RLS
-- ═══════════════════════════════════════════════════════════════════════════════

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ 1. AJOUT DES CHAMPS IA À SOCIAL_POSTS                                     │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- Note: church_id existe déjà dans le schéma réel
ALTER TABLE social_posts
  ADD COLUMN IF NOT EXISTS is_ai_generated BOOLEAN DEFAULT false,
  ADD COLUMN IF NOT EXISTS ai_bible_verse TEXT,       -- Référence du verset (ex: "Psaume 23:4")
  ADD COLUMN IF NOT EXISTS ai_bible_text TEXT,         -- Texte du verset
  ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'published', -- published, flagged, deleted
  ADD COLUMN IF NOT EXISTS moderated_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS moderation_score INTEGER DEFAULT 0,  -- 0-100
  ADD COLUMN IF NOT EXISTS moderation_reason TEXT;

CREATE INDEX IF NOT EXISTS idx_social_posts_status ON social_posts(status);
CREATE INDEX IF NOT EXISTS idx_social_posts_ai ON social_posts(is_ai_generated);

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ 2. TABLE MODERATION_REPORTS                                               │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- Note: social_posts.id est de type TEXT (pas UUID) dans le schéma réel
CREATE TABLE IF NOT EXISTS moderation_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    post_id TEXT NOT NULL REFERENCES social_posts(id) ON DELETE CASCADE,
    reported_by TEXT NOT NULL,          -- 'system' pour l'IA, ou user_id
    reason TEXT NOT NULL,               -- Description du problème
    category TEXT NOT NULL DEFAULT 'other', -- hate, malicious, anger, off_topic, other
    severity INTEGER DEFAULT 50,        -- 0-100
    status TEXT DEFAULT 'pending',      -- pending, reviewed, dismissed, action_taken
    reviewed_by UUID,                   -- Admin qui a traité
    reviewed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_moderation_reports_status ON moderation_reports(status);
CREATE INDEX IF NOT EXISTS idx_moderation_reports_post ON moderation_reports(post_id);
CREATE INDEX IF NOT EXISTS idx_moderation_reports_created ON moderation_reports(created_at DESC);

ALTER TABLE moderation_reports ENABLE ROW LEVEL SECURITY;

-- RLS: Les admins peuvent lire tous les rapports
CREATE POLICY "moderation_reports_select_admin" ON moderation_reports FOR
  SELECT TO authenticated USING (
    EXISTS (
      SELECT 1 FROM user_roles ur
        JOIN roles r ON ur.role_id = r.id
      WHERE ur.user_id = auth.uid()
        AND r.is_super = true
        AND ur.is_active = true
    )
  );

-- RLS: Service role peut insérer
CREATE POLICY "moderation_reports_insert" ON moderation_reports FOR
  INSERT TO service_role WITH CHECK (true);

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ 3. TABLE AI_QUEUE (File d'attente des tâches IA)                          │
-- └─────────────────────────────────────────────────────────────────────────────┘
CREATE TABLE IF NOT EXISTS ai_queue (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_type TEXT NOT NULL,             -- generate_post, improve_post, moderate
    payload JSONB NOT NULL DEFAULT '{}', -- Données de la tâche
    status TEXT DEFAULT 'pending',       -- pending, processing, done, failed
    model_used TEXT,                     -- openrouter/gpt-100b ou gemini
    result JSONB,                        -- Résultat du traitement
    error TEXT,                          -- Message d'erreur
    scheduled_at TIMESTAMPTZ DEFAULT NOW(),
    retry_count INTEGER DEFAULT 0,
    max_retries INTEGER DEFAULT 3,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ai_queue_status ON ai_queue(status);
CREATE INDEX IF NOT EXISTS idx_ai_queue_scheduled ON ai_queue(scheduled_at)
  WHERE status = 'pending';

ALTER TABLE ai_queue ENABLE ROW LEVEL SECURITY;

-- RLS: Service role only (les Edge Functions utilisent le service_role)
CREATE POLICY "ai_queue_service_role" ON ai_queue FOR ALL
  TO service_role USING (true) WITH CHECK (true);

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ 4. MISE À JOUR RLS SOCIAL_POSTS                                           │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- Les politiques existantes utilisent internal.rls_is_admin() et internal.rls_get_church_id()
-- On ajoute une politique UPDATE pour que les admins puissent modérer

DROP POLICY IF EXISTS "social_posts_update" ON social_posts;
CREATE POLICY "social_posts_update" ON social_posts FOR
  UPDATE TO authenticated USING (
    author_id = auth.uid()::text
    OR internal.rls_is_admin()
  );

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ 5. FONCTION POUR NOTIFIER LES ADMINS (version corrigée)                   │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- Note: la table notifications utilise `body` (pas `message`)
CREATE OR REPLACE FUNCTION notify_admins_of_flagged_post()
RETURNS TRIGGER AS $$
DECLARE
  admin_record RECORD;
  post_record RECORD;
BEGIN
  -- Récupérer le post signalé
  SELECT * INTO post_record FROM social_posts WHERE id = NEW.post_id;
  
  -- Pour chaque admin de l'église, créer une notification
  FOR admin_record IN
    SELECT DISTINCT u.id as user_id
    FROM auth.users u
    WHERE EXISTS (
      SELECT 1 FROM user_roles ur
        JOIN roles r ON ur.role_id = r.id
      WHERE ur.user_id = u.id
        AND r.is_super = true
        AND ur.is_active = true
    )
  LOOP
    INSERT INTO notifications (
      user_id,
      title,
      body,
      type,
      link_url,
      payload
    ) VALUES (
      admin_record.user_id,
      '🚨 Publication signalée',
      format(
        'Une publication a été signalée comme %s: "%s"',
        NEW.category,
        left(post_record.content, 100)
      ),
      'MODERATION_ALERT',
      '/communication/social/detail',
      jsonb_build_object(
        'post_id', NEW.post_id,
        'report_id', NEW.id,
        'category', NEW.category,
        'severity', NEW.severity
      )
    );
  END LOOP;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Déclencheur: quand un rapport de modération est créé par l'IA
DROP TRIGGER IF EXISTS trg_moderation_report_notify ON moderation_reports;
CREATE TRIGGER trg_moderation_report_notify
  AFTER INSERT ON moderation_reports
  FOR EACH ROW
  WHEN (NEW.reported_by = 'system')
  EXECUTE FUNCTION notify_admins_of_flagged_post();

-- ═══════════════════════════════════════════════════════════════════════════════
-- FIN MIGRATION AI SOCIAL FEATURES
-- ═══════════════════════════════════════════════════════════════════════════════
