-- ═══════════════════════════════════════════════════════════════════════════════
-- AI Social Features - Phase 2: pg_cron Scheduling
-- Date: 2026-06-30
-- Purpose: Programmer la génération automatique de posts bibliques
--          2x/jour (08:00 et 19:00) via generate-ai-post Edge Function
--
-- ⚠️ PRÉ-REQUIS AVANT D'EXÉCUTER :
--   1. La migration 20260630_ai_social_features.sql doit être appliquée
--   2. Les secrets OPENROUTER_API_KEY et GEMINI_API_KEY doivent être
--      configurés dans Supabase (via `supabase secrets set`)
--   3. L'Edge Function generate-ai-post doit être déployée
--   4. REMPLACER les valeurs dans ai_cron_config ci-dessous
--
-- 🔧 Obtenir vos valeurs :
--   Project Ref   → Supabase Dashboard > Settings > Project Settings > Reference ID
--   Service Role  → Supabase Dashboard > Settings > API > service_role (secret)
-- ═══════════════════════════════════════════════════════════════════════════════

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ 1. ACTIVATION DES EXTENSIONS                                              │
-- └─────────────────────────────────────────────────────────────────────────────┘

CREATE EXTENSION IF NOT EXISTS pg_cron WITH SCHEMA extensions;
CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA extensions;

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ 2. TABLE DE CONFIGURATION (avec RLS pour protéger le service_role_key)    │
-- └─────────────────────────────────────────────────────────────────────────────┘

CREATE TABLE IF NOT EXISTS ai_cron_config (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL
);

ALTER TABLE ai_cron_config ENABLE ROW LEVEL SECURITY;

-- Seul le service_role peut accéder à cette table
CREATE POLICY "ai_cron_config_service_role" ON ai_cron_config
  FOR ALL TO service_role USING (true) WITH CHECK (true);

-- ═══ À REMPLACER PAR VOS VRAIES VALEURS ═══════════════════════════════════════
-- Exemple :
--   INSERT INTO ai_cron_config (key, value) VALUES
--       ('supabase_url', 'https://abcdefghijklm.supabase.co'),
--       ('service_role_key', 'eyJhbGciOiJIUzI1NiIs...votre_service_role_key')
--   ON CONFLICT (key) DO NOTHING;
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO ai_cron_config (key, value) VALUES
    ('supabase_url', 'https://<VOTRE_PROJECT_REF>.supabase.co'),
    ('service_role_key', '<VOTRE_SERVICE_ROLE_KEY>')
ON CONFLICT (key) DO NOTHING;

-- Une fois la migration exécutée, mettez à jour les valeurs :
--   UPDATE ai_cron_config SET value = 'https://<REF>.supabase.co' WHERE key = 'supabase_url';
--   UPDATE ai_cron_config SET value = 'eyJhbGci...' WHERE key = 'service_role_key';

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ 3. PLANIFICATION DES TÂCHES CRON                                          │
-- │    ⚡ Les requêtes SELECT sont À L'INTÉRIEUR du dollar-quoting,            │
-- │    donc lues dynamiquement à CHAQUE exécution du cron.                     │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- Tâche du matin — 08:00 (post d'encouragement)
SELECT cron.schedule(
    'generate-ai-post-morning',
    '0 8 * * *',
    $$
    SELECT net.http_post(
        url := (SELECT value FROM ai_cron_config WHERE key = 'supabase_url')
               || '/functions/v1/generate-ai-post',
        headers := jsonb_build_object(
            'Content-Type', 'application/json',
            'Authorization', 'Bearer '
                || (SELECT value FROM ai_cron_config WHERE key = 'service_role_key')
        ),
        body := jsonb_build_object('tone', 'morning')::text,
        timeout_milliseconds := 30000
    ) AS request_id;
    $$
);

-- Tâche du soir — 19:00 (post de réflexion)
SELECT cron.schedule(
    'generate-ai-post-evening',
    '0 19 * * *',
    $$
    SELECT net.http_post(
        url := (SELECT value FROM ai_cron_config WHERE key = 'supabase_url')
               || '/functions/v1/generate-ai-post',
        headers := jsonb_build_object(
            'Content-Type', 'application/json',
            'Authorization', 'Bearer '
                || (SELECT value FROM ai_cron_config WHERE key = 'service_role_key')
        ),
        body := jsonb_build_object('tone', 'evening')::text,
        timeout_milliseconds := 30000
    ) AS request_id;
    $$
);

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ 4. FONCTION DE TEST (appel manuel)                                        │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- Usage :
--   SELECT invoke_ai_generate_post('morning');
--   SELECT invoke_ai_generate_post('evening');

CREATE OR REPLACE FUNCTION invoke_ai_generate_post(p_tone TEXT DEFAULT 'morning')
RETURNS BIGINT
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_base_url TEXT;
    v_service_key TEXT;
    v_request_id BIGINT;
BEGIN
    IF p_tone NOT IN ('morning', 'evening') THEN
        RAISE EXCEPTION 'Tone invalide. Utilisez "morning" ou "evening".';
    END IF;

    SELECT value INTO v_base_url FROM ai_cron_config WHERE key = 'supabase_url';
    SELECT value INTO v_service_key FROM ai_cron_config WHERE key = 'service_role_key';

    IF v_base_url IS NULL OR v_service_key IS NULL THEN
        RAISE EXCEPTION 'Configuration manquante dans ai_cron_config. Exécutez les UPDATE.';
    END IF;

    SELECT net.http_post(
        url := v_base_url || '/functions/v1/generate-ai-post',
        headers := jsonb_build_object(
            'Content-Type', 'application/json',
            'Authorization', 'Bearer ' || v_service_key
        ),
        body := jsonb_build_object('tone', p_tone)::text,
        timeout_milliseconds := 30000
    ) INTO v_request_id;

    RETURN v_request_id;
END;
$$;

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ 5. VÉRIFICATION                                                           │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- Lister les jobs :      SELECT * FROM cron.job;
-- Tester manuellement :  SELECT invoke_ai_generate_post('morning');
-- Dernière exécution :   SELECT * FROM cron.job_run_details ORDER BY start_time DESC LIMIT 5;

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ 6. ROLLBACK                                                               │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- SELECT cron.unschedule('generate-ai-post-morning');
-- SELECT cron.unschedule('generate-ai-post-evening');
-- DROP FUNCTION IF EXISTS invoke_ai_generate_post;
-- DROP TABLE IF EXISTS ai_cron_config;
-- Ne PAS DROP EXTENSION si d'autres jobs les utilisent

-- ═══════════════════════════════════════════════════════════════════════════════
-- FIN MIGRATION PG_CRON
-- ═══════════════════════════════════════════════════════════════════════════════
