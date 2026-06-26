-- ============================================================
-- Migration: Deterministic Code Verification (Zero False Negatives)
-- Date: 2026-04-01
-- Description:
--   Remplace la vérification bcrypt (probabiliste, lente) par une
--   comparaison directe sur la colonne raw_code (exact, O(1), indexée).
--   Crée aussi les 2 RPCs manquants: redeem_secret_code, verify_admin_code.
-- ============================================================

BEGIN;

-- ─── INDEX sur raw_code pour garantir O(1) ────────────────────────────────

CREATE UNIQUE INDEX IF NOT EXISTS idx_role_secret_codes_raw_code
  ON public.role_secret_codes (raw_code)
  WHERE raw_code IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS idx_group_secret_codes_raw_code
  ON public.group_secret_codes (raw_code)
  WHERE raw_code IS NOT NULL;

-- ─── 1. verify_universal_code (DÉTERMINISTE) ──────────────────────────────
-- Ancienne version bcrypt: crypt(p_code, code_hash) = code_hash  → lent, probabiliste
-- Nouvelle version: raw_code = p_code_upper  → exact, O(1), zéro faux-négatif

CREATE OR REPLACE FUNCTION public.verify_universal_code(
  p_code    TEXT,
  p_user_id UUID DEFAULT NULL
)
RETURNS TABLE(
  role_code  TEXT,
  role_id    UUID,
  role_label TEXT,
  is_super   BOOLEAN,
  scope      TEXT,
  group_id   UUID
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_normalized TEXT := UPPER(TRIM(p_code));
  v_success    BOOLEAN := FALSE;
BEGIN
  -- ── 1. Codes globaux de rôle ──────────────────────────────────────────
  RETURN QUERY
  SELECT
    r.code        AS role_code,
    r.id          AS role_id,
    r.label       AS role_label,
    r.is_super,
    r.scope,
    NULL::UUID    AS group_id
  FROM public.role_secret_codes rsc
  JOIN public.roles r ON r.code = rsc.role_code
  WHERE rsc.raw_code = v_normalized;  -- comparaison exacte, index unique

  IF FOUND THEN
    v_success := TRUE;
    PERFORM public.log_role_code_attempt(v_normalized, p_user_id, TRUE);
    RETURN;
  END IF;

  -- ── 2. Codes de groupes ───────────────────────────────────────────────
  RETURN QUERY
  SELECT
    COALESCE(r.code, 'responsable_groupe')::TEXT AS role_code,
    r.id          AS role_id,
    ('Responsable de ' || g.label)               AS role_label,
    FALSE         AS is_super,
    'group'::TEXT AS scope,
    g.id          AS group_id
  FROM public.group_secret_codes gsc
  JOIN public.groups g ON g.id = gsc.group_id
  JOIN public.roles  r ON r.code = 'responsable_groupe'
  WHERE gsc.raw_code = v_normalized;  -- comparaison exacte, index unique

  v_success := FOUND;
  IF v_success THEN
    PERFORM public.log_role_code_attempt(v_normalized, p_user_id, TRUE);
  ELSE
    PERFORM public.log_role_code_attempt(v_normalized, p_user_id, FALSE);
  END IF;
END;
$$;

COMMENT ON FUNCTION public.verify_universal_code IS
  'Vérification déterministe par lookup exact (raw_code). Zéro faux-négatif. O(1) avec index unique.';


-- ─── 2. verify_role_secret_code (DÉTERMINISTE) ────────────────────────────

CREATE OR REPLACE FUNCTION public.verify_role_secret_code(
  p_role_code TEXT,
  p_code      TEXT,
  p_user_id   UUID DEFAULT NULL
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_normalized TEXT    := UPPER(TRIM(p_code));
  v_result     BOOLEAN;
BEGIN
  SELECT EXISTS (
    SELECT 1
    FROM public.role_secret_codes
    WHERE role_code = p_role_code
      AND raw_code  = v_normalized   -- comparaison exacte
  ) INTO v_result;

  PERFORM public.log_role_code_attempt(v_normalized, p_user_id, v_result);
  RETURN v_result;
END;
$$;

COMMENT ON FUNCTION public.verify_role_secret_code IS
  'Vérifie un code secret par comparaison exacte sur raw_code (déterministe).';


-- ─── 3. redeem_secret_code (RPC MANQUANT) ─────────────────────────────────
-- Appelé par role_code_verification_screen.dart → n'existait pas → 100% échec

CREATE OR REPLACE FUNCTION public.redeem_secret_code(
  p_code    TEXT
)
RETURNS TABLE(
  role_code  TEXT,
  role_id    UUID,
  role_label TEXT,
  is_super   BOOLEAN,
  scope      TEXT,
  group_id   UUID
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_normalized TEXT := UPPER(TRIM(p_code));
BEGIN
  -- Délègue à verify_universal_code (déterministe)
  -- On ne touche pas is_used car les codes sont réutilisables (20250315)
  RETURN QUERY
  SELECT * FROM public.verify_universal_code(v_normalized, auth.uid());
END;
$$;

COMMENT ON FUNCTION public.redeem_secret_code IS
  'Alias de verify_universal_code. Vérifie un code et retourne le rôle associé. Codes réutilisables.';


-- ─── 4. verify_admin_code (RPC MANQUANT) ──────────────────────────────────
-- Appelé par supabase_auth_repository.dart → n'existait pas → 100% échec

CREATE OR REPLACE FUNCTION public.verify_admin_code(
  input_code TEXT
)
RETURNS TABLE(
  is_valid   BOOLEAN,
  role_code  TEXT,
  role_label TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_normalized TEXT := UPPER(TRIM(input_code));
  v_role_code  TEXT;
  v_role_label TEXT;
BEGIN
  -- Cherche dans les codes de rôles admin/superadmin uniquement
  SELECT r.code, r.label
  INTO v_role_code, v_role_label
  FROM public.role_secret_codes rsc
  JOIN public.roles r ON r.code = rsc.role_code
  WHERE rsc.raw_code = v_normalized
    AND r.is_super = TRUE
  LIMIT 1;

  IF v_role_code IS NOT NULL THEN
    PERFORM public.log_role_code_attempt(v_normalized, auth.uid(), TRUE);
    RETURN QUERY SELECT TRUE, v_role_code, v_role_label;
  ELSE
    PERFORM public.log_role_code_attempt(v_normalized, auth.uid(), FALSE);
    RETURN QUERY SELECT FALSE, NULL::TEXT, NULL::TEXT;
  END IF;
END;
$$;

COMMENT ON FUNCTION public.verify_admin_code IS
  'Vérifie un code admin/superadmin par lookup exact. Retourne {is_valid, role_code, role_label}.';


-- ─── 5. Vérification de couverture ────────────────────────────────────────
-- S'assurer que tous les rôles actifs ont un raw_code non-null
DO $$
DECLARE
  v_missing_count INT;
BEGIN
  SELECT COUNT(*) INTO v_missing_count
  FROM public.role_secret_codes
  WHERE raw_code IS NULL OR TRIM(raw_code) = '';

  IF v_missing_count > 0 THEN
    RAISE WARNING '[verify] % codes de rôles sans raw_code. Exécutez 20260318_reseed_secret_codes_2026.sql.',
      v_missing_count;
  ELSE
    RAISE NOTICE '[verify] Tous les codes de rôles ont un raw_code. Couverture OK.';
  END IF;
END $$;

COMMIT;
