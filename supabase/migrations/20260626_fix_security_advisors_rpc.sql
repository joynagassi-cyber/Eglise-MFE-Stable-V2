-- =====================================================
-- Migration: fix security advisors on code verification RPCs
-- Date: 2026-06-26
-- 
-- Fixes:
--   1. function_search_path_mutable → SET search_path on redeem_secret_code, verify_secret_code, assign_user_role
--   2. anon_security_definer_function_executable → REVOKE EXECUTE from anon/PUBLIC
--   3. assign_user_role privilege escalation → auth.uid() check (only self or superadmin)
-- =====================================================

-- ── 1. redeem_secret_code (with search_path + revoke anon) ──
CREATE OR REPLACE FUNCTION public.redeem_secret_code(p_code text)
RETURNS TABLE(role_code text, raw_code text, is_used boolean)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, extensions
AS $function$
DECLARE
    v_row RECORD;
    v_normalized TEXT;
BEGIN
    v_normalized := UPPER(REPLACE(REPLACE(p_code, '-', ''), ' ', ''));

    -- NIVEAU 1 : bcrypt
    FOR v_row IN
        SELECT r.id, r.role_code, r.raw_code, r.is_used, r.code_hash
        FROM public.role_secret_codes AS r
        WHERE r.code_hash = extensions.crypt(p_code::text, r.code_hash::text)
        LIMIT 1
    LOOP
        UPDATE public.role_secret_codes
        SET is_used = true,
            used_by_user_id = auth.uid(),
            used_at = now(),
            updated_at = now()
        WHERE id = v_row.id;
        RETURN QUERY SELECT v_row.role_code, v_row.raw_code, true;
        RETURN;
    END LOOP;

    -- NIVEAU 2 : raw_code exact
    FOR v_row IN
        SELECT r.id, r.role_code, r.raw_code, r.is_used
        FROM public.role_secret_codes AS r
        WHERE r.raw_code = UPPER(p_code)
        LIMIT 1
    LOOP
        UPDATE public.role_secret_codes
        SET is_used = true,
            used_by_user_id = auth.uid(),
            used_at = now(),
            updated_at = now()
        WHERE id = v_row.id;
        RETURN QUERY SELECT v_row.role_code, v_row.raw_code, true;
        RETURN;
    END LOOP;

    -- NIVEAU 3 : normalized_code
    FOR v_row IN
        SELECT r.id, r.role_code, r.raw_code, r.is_used
        FROM public.role_secret_codes AS r
        WHERE r.normalized_code = v_normalized
        LIMIT 1
    LOOP
        UPDATE public.role_secret_codes
        SET is_used = true,
            used_by_user_id = auth.uid(),
            used_at = now(),
            updated_at = now()
        WHERE id = v_row.id;
        RETURN QUERY SELECT v_row.role_code, v_row.raw_code, true;
        RETURN;
    END LOOP;

    RETURN;
END;
$function$;

-- ── 2. verify_secret_code (with search_path + revoke anon) ──
CREATE OR REPLACE FUNCTION public.verify_secret_code(p_code text)
RETURNS TABLE(role_code text, raw_code text)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, extensions
AS $function$
DECLARE
    v_row RECORD;
    v_normalized TEXT;
BEGIN
    v_normalized := UPPER(REPLACE(REPLACE(p_code, '-', ''), ' ', ''));

    -- NIVEAU 1 : bcrypt
    FOR v_row IN
        SELECT r.role_code, r.raw_code
        FROM public.role_secret_codes AS r
        WHERE r.code_hash = extensions.crypt(p_code::text, r.code_hash::text)
        LIMIT 1
    LOOP
        RETURN QUERY SELECT v_row.role_code, v_row.raw_code;
        RETURN;
    END LOOP;

    -- NIVEAU 2 : raw_code exact
    FOR v_row IN
        SELECT r.role_code, r.raw_code
        FROM public.role_secret_codes AS r
        WHERE r.raw_code = UPPER(p_code)
        LIMIT 1
    LOOP
        RETURN QUERY SELECT v_row.role_code, v_row.raw_code;
        RETURN;
    END LOOP;

    -- NIVEAU 3 : normalized_code
    FOR v_row IN
        SELECT r.role_code, r.raw_code
        FROM public.role_secret_codes AS r
        WHERE r.normalized_code = v_normalized
        LIMIT 1
    LOOP
        RETURN QUERY SELECT v_row.role_code, v_row.raw_code;
        RETURN;
    END LOOP;

    RETURN;
END;
$function$;

-- ── 3. assign_user_role (with search_path + auth.uid() check + revoke anon) ──
CREATE OR REPLACE FUNCTION public.assign_user_role(p_user_id uuid, p_role_code text, p_church_id text DEFAULT NULL::text)
RETURNS TABLE(success boolean, message text)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, extensions
AS $function$
DECLARE
    v_role_id UUID;
    v_church_id TEXT;
    v_email TEXT;
    v_name TEXT;
    v_caller_is_super BOOLEAN;
BEGIN
    -- Securite : seul l'utilisateur lui-meme ou un superadmin peut assigner
    SELECT COALESCE(
        (SELECT is_super FROM public.roles r
         JOIN public.user_roles ur ON ur.role_id = r.id
         WHERE ur.user_id = auth.uid() AND r.is_super = true
         LIMIT 1),
        false
    ) INTO v_caller_is_super;

    IF auth.uid() IS NULL THEN
        RETURN QUERY SELECT false, 'Non authentifie';
        RETURN;
    END IF;

    IF p_user_id <> auth.uid() AND NOT v_caller_is_super THEN
        RETURN QUERY SELECT false, 'Vous ne pouvez assigner un role qu a vous-meme';
        RETURN;
    END IF;

    -- 1) Trouver role_id
    SELECT id INTO v_role_id
    FROM public.roles
    WHERE code = p_role_code
    LIMIT 1;

    IF v_role_id IS NULL THEN
        RETURN QUERY SELECT false, 'Role non trouve: ' || p_role_code;
        RETURN;
    END IF;

    -- 2) Recuperer l'email depuis auth.users
    SELECT email, COALESCE(raw_user_meta_data->>'full_name', raw_user_meta_data->>'name', '')
    INTO v_email, v_name
    FROM auth.users
    WHERE id = p_user_id;

    -- 3) Upsert dans public.users
    INSERT INTO public.users (id, email, name, status)
    VALUES (p_user_id, v_email, v_name, 'active')
    ON CONFLICT (id) DO UPDATE SET email = EXCLUDED.email, name = EXCLUDED.name;

    -- 4) Church ID
    IF p_church_id IS NOT NULL THEN
        v_church_id := p_church_id;
    ELSE
        SELECT church_id INTO v_church_id
        FROM public.user_churches
        WHERE user_id = p_user_id AND is_active = true
        LIMIT 1;
    END IF;

    -- 5) Upsert user_roles
    DELETE FROM public.user_roles 
    WHERE user_id = p_user_id AND role_id = v_role_id AND group_id IS NULL;
    
    INSERT INTO public.user_roles (user_id, role_id, church_id, is_active)
    VALUES (p_user_id, v_role_id, v_church_id, true);

    -- 6) user_sessions
    INSERT INTO public.user_sessions (user_id, active_role_id, active_group_id, last_switch)
    VALUES (p_user_id, v_role_id, NULL, now())
    ON CONFLICT (user_id)
    DO UPDATE SET
        active_role_id = EXCLUDED.active_role_id,
        last_switch = now();

    -- 7) profiles.needs_onboarding = false
    UPDATE public.profiles
    SET needs_onboarding = false,
        updated_at = now()
    WHERE id = p_user_id;

    INSERT INTO public.profiles (id, needs_onboarding, created_at, updated_at)
    VALUES (p_user_id, false, now(), now())
    ON CONFLICT (id) DO NOTHING;

    -- 8) user_churches
    IF v_church_id IS NOT NULL THEN
        INSERT INTO public.user_churches (user_id, church_id, is_active, joined_at, created_at)
        VALUES (p_user_id, v_church_id, true, now(), now())
        ON CONFLICT DO NOTHING;
    END IF;

    RETURN QUERY SELECT true, 'Role assigne avec succes: ' || p_role_code;
END;
$function$;

-- ── 4. Revoke EXECUTE from anon, keep for authenticated ──
REVOKE EXECUTE ON FUNCTION public.redeem_secret_code(text) FROM anon, PUBLIC;
REVOKE EXECUTE ON FUNCTION public.verify_secret_code(text) FROM anon, PUBLIC;
REVOKE EXECUTE ON FUNCTION public.assign_user_role(uuid, text, text) FROM anon, PUBLIC;

GRANT EXECUTE ON FUNCTION public.redeem_secret_code(text) TO authenticated;
GRANT EXECUTE ON FUNCTION public.verify_secret_code(text) TO authenticated;
GRANT EXECUTE ON FUNCTION public.assign_user_role(uuid, text, text) TO authenticated;
