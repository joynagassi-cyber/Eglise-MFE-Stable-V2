-- Migration: Fix RPC Wrappers & Cleanup
-- Date: 2026-07-03
-- Description:
--   1. Ajoute les valeurs lowercase à l'enum transaction_status (si pas déjà fait)
--   2. Corrige get_bilan_breakdown (category → category_name)
--   3. Crée les wrappers publics pour les RPCs internes (accessibles via PostgREST)
--   4. Normalise les statuts des transactions existantes
--
-- Contexte:
--   - L'enum PostgreSQL transaction_status avait uniquement des valeurs uppercase
--   - Le code Dart (freezed) sérialise TransactionStatus en lowercase
--   - Les RPCs get_financial_bilan et get_bilan_breakdown étaient dans le schéma 'internal'
--     mais l'app mobile y accède via PostgREST qui ne voit que le schéma 'public'
--   - get_bilan_breakdown référençait 'category' au lieu de 'category_name'

-- ============================================================
-- 1. Add lowercase values to transaction_status enum
-- ============================================================
-- Note: ALTER TYPE ... ADD VALUE ne supporte pas IF NOT EXISTS.
-- On utilise un bloc DO pour éviter les erreurs si la valeur existe déjà.
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_enum e
    JOIN pg_type t ON e.enumtypid = t.oid
    WHERE t.typname = 'transaction_status' AND e.enumlabel = 'draft'
  ) THEN
    ALTER TYPE transaction_status ADD VALUE 'draft' BEFORE 'DRAFT';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_enum e
    JOIN pg_type t ON e.enumtypid = t.oid
    WHERE t.typname = 'transaction_status' AND e.enumlabel = 'pending'
  ) THEN
    ALTER TYPE transaction_status ADD VALUE 'pending' BEFORE 'PENDING_VALIDATION';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_enum e
    JOIN pg_type t ON e.enumtypid = t.oid
    WHERE t.typname = 'transaction_status' AND e.enumlabel = 'validated'
  ) THEN
    ALTER TYPE transaction_status ADD VALUE 'validated' BEFORE 'VALIDATED';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_enum e
    JOIN pg_type t ON e.enumtypid = t.oid
    WHERE t.typname = 'transaction_status' AND e.enumlabel = 'rejected'
  ) THEN
    ALTER TYPE transaction_status ADD VALUE 'rejected' BEFORE 'REJECTED';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_enum e
    JOIN pg_type t ON e.enumtypid = t.oid
    WHERE t.typname = 'transaction_status' AND e.enumlabel = 'sealed'
  ) THEN
    ALTER TYPE transaction_status ADD VALUE 'sealed' BEFORE 'SEALED';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_enum e
    JOIN pg_type t ON e.enumtypid = t.oid
    WHERE t.typname = 'transaction_status' AND e.enumlabel = 'archived'
  ) THEN
    ALTER TYPE transaction_status ADD VALUE 'archived' BEFORE 'ARCHIVED';
  END IF;
END $$;

-- ============================================================
-- 2. Fix get_bilan_breakdown (internal schema)
--    Bug: utilisait 'category' au lieu de 'category_name'
--    Aussi: utilisait 'transactions' (legacy) au lieu de 'finance_transactions'
-- ============================================================
CREATE OR REPLACE FUNCTION internal.get_bilan_breakdown(
  p_church_id text,
  p_start_date date,
  p_end_date date,
  p_dimension text
)
RETURNS TABLE(breakdown_key text, total_income numeric, total_expense numeric, transaction_count bigint)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public', 'pg_temp'
AS $function$
BEGIN
  IF p_dimension = 'category' THEN
    RETURN QUERY
    SELECT category_name as breakdown_key,
        SUM(amount) FILTER (WHERE type = 'income') as total_income,
        SUM(amount) FILTER (WHERE type = 'expense') as total_expense,
        COUNT(*) as transaction_count
    FROM finance_transactions
    WHERE church_id = p_church_id
        AND date BETWEEN p_start_date AND p_end_date
    GROUP BY category_name;
  ELSIF p_dimension = 'month' THEN
    RETURN QUERY
    SELECT to_char(date, 'YYYY-MM') as breakdown_key,
        SUM(amount) FILTER (WHERE type = 'income') as total_income,
        SUM(amount) FILTER (WHERE type = 'expense') as total_expense,
        COUNT(*) as transaction_count
    FROM finance_transactions
    WHERE church_id = p_church_id
        AND date BETWEEN p_start_date AND p_end_date
    GROUP BY 1
    ORDER BY 1;
  ELSIF p_dimension = 'group' THEN
    RETURN QUERY
    SELECT group_id::text as breakdown_key,
        SUM(amount) FILTER (WHERE type = 'income') as total_income,
        SUM(amount) FILTER (WHERE type = 'expense') as total_expense,
        COUNT(*) as transaction_count
    FROM finance_transactions
    WHERE church_id = p_church_id
        AND date BETWEEN p_start_date AND p_end_date
    GROUP BY group_id;
  END IF;
END;
$function$;

-- ============================================================
-- 3. Create public wrapper functions
--    Permet à l'app mobile (PostgREST / supabase.rpc) d'accéder
--    aux fonctions qui sont dans le schéma 'internal'
-- ============================================================

-- 3a. Wrapper public pour get_financial_bilan
CREATE OR REPLACE FUNCTION public.get_financial_bilan(
  p_church_id text,
  p_start_date date,
  p_end_date date
)
RETURNS json
LANGUAGE sql
SECURITY DEFINER
SET search_path TO 'public', 'pg_temp'
AS $function$
  SELECT internal.get_financial_bilan(p_church_id, p_start_date, p_end_date);
$function$;

-- 3b. Wrapper public pour get_bilan_breakdown
CREATE OR REPLACE FUNCTION public.get_bilan_breakdown(
  p_church_id text,
  p_start_date date,
  p_end_date date,
  p_dimension text
)
RETURNS TABLE(breakdown_key text, total_income numeric, total_expense numeric, transaction_count bigint)
LANGUAGE sql
SECURITY DEFINER
SET search_path TO 'public', 'pg_temp'
AS $function$
  SELECT * FROM internal.get_bilan_breakdown(p_church_id, p_start_date, p_end_date, p_dimension);
$function$;

-- ============================================================
-- 4. Normalize existing transaction statuses to lowercase
--    (safe: ne modifie que les statuts encore en uppercase)
-- ============================================================
UPDATE finance_transactions
SET status = LOWER(status::text)::transaction_status
WHERE status::text IN ('DRAFT', 'PENDING_VALIDATION', 'VALIDATED', 'REJECTED', 'SEALED', 'ARCHIVED');

-- ============================================================
-- 5. Drop obsolete drive_files_test table (if still exists)
-- ============================================================
DROP TABLE IF EXISTS drive_files_test;

-- ============================================================
-- 6. Clean up test entries in ai_queue
-- ============================================================
DELETE FROM ai_queue WHERE payload->>'post_id' LIKE 'test-%';

-- ============================================================
-- 7. Clean up test social_posts (AI-generated during dev)
-- ============================================================
-- ============================================================
-- 6. Corriger les cron jobs AI Social Posts
--    Remplacer l'appel direct à extensions.net.http_post (qui échoue
--    avec 'cross-database references are not implemented') par un
--    wrapper public.ai_generate_post() avec SECURITY DEFINER
-- ============================================================

-- 6a. Créer une fonction wrapper pour contourner les limitations pg_cron + pg_net
CREATE OR REPLACE FUNCTION public.ai_generate_post(p_tone text DEFAULT 'morning')
RETURNS bigint
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public', 'extensions', 'pg_temp'
AS $function$
DECLARE
    v_base_url text;
    v_service_key text;
    v_request_id bigint;
BEGIN
    IF p_tone NOT IN ('morning', 'evening') THEN
        RAISE EXCEPTION 'Tone invalide. Utilisez morning ou evening.';
    END IF;

    SELECT value INTO v_base_url FROM ai_cron_config WHERE key = 'supabase_url';
    SELECT value INTO v_service_key FROM ai_cron_config WHERE key = 'service_role_key';

    IF v_base_url IS NULL OR v_service_key IS NULL THEN
        RAISE EXCEPTION 'Configuration manquante dans ai_cron_config';
    END IF;

    SELECT net.http_post(
        url := v_base_url || '/functions/v1/generate-ai-post',
        body := jsonb_build_object('tone', p_tone),
        params := '{}'::jsonb,
        headers := jsonb_build_object(
            'Content-Type', 'application/json',
            'Authorization', 'Bearer ' || v_service_key
        ),
        timeout_milliseconds := 60000
    ) INTO v_request_id;

    RETURN v_request_id;
END;
$function$;

-- 6b. Mettre à jour les cron jobs pour utiliser le wrapper
SELECT cron.unschedule('generate-ai-post-morning');
SELECT cron.schedule('generate-ai-post-morning', '0 8 * * *',
    $$ SELECT public.ai_generate_post('morning'); $$
);

SELECT cron.unschedule('generate-ai-post-evening');
SELECT cron.schedule('generate-ai-post-evening', '0 19 * * *',
    $$ SELECT public.ai_generate_post('evening'); $$
);
