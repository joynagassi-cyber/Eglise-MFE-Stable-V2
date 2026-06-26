-- Migration: Update Secret Codes for 2026 with Random Identifiers
-- Date: 2026-03-18
-- Description: Adds raw_code column for admin reference and generates unguessable codes for 2026.

BEGIN;

-- 1. Add raw_code column if it doesn't exist
ALTER TABLE public.role_secret_codes ADD COLUMN IF NOT EXISTS raw_code TEXT;
ALTER TABLE public.group_secret_codes ADD COLUMN IF NOT EXISTS raw_code TEXT;

-- 2. Update Role Secret Codes to 2026 with Random Suffix
DO $$ 
DECLARE 
    r RECORD;
    v_random_part TEXT;
    v_full_code TEXT;
BEGIN
    FOR r IN SELECT code FROM public.roles WHERE code != 'membre_simple' LOOP
        -- Generate 4 random characters (uppercase)
        v_random_part := UPPER(substring(md5(random()::text) from 1 for 4));
        v_full_code := UPPER(REPLACE(r.code, '_', '-')) || '-' || v_random_part || '-2026';
        
        UPDATE public.role_secret_codes 
        SET raw_code = v_full_code,
            code_hash = crypt(v_full_code, gen_salt('bf')),
            updated_at = NOW()
        WHERE role_code = r.code;
        
        IF NOT FOUND THEN
            INSERT INTO public.role_secret_codes (role_code, raw_code, code_hash)
            VALUES (r.code, v_full_code, crypt(v_full_code, gen_salt('bf')));
        END IF;
    END LOOP;
END $$;

-- 3. Update Group Secret Codes to 2026 with Random Suffix
DO $$ 
DECLARE 
    g RECORD;
    v_random_part TEXT;
    v_full_code TEXT;
BEGIN
    FOR g IN SELECT id, code FROM public.groups LOOP
        -- Responsable
        v_random_part := UPPER(substring(md5(random()::text) from 1 for 4));
        v_full_code := 'CHEF-' || UPPER(g.code) || '-' || v_random_part || '-2026';
        UPDATE public.group_secret_codes 
        SET raw_code = v_full_code,
            code_hash = crypt(v_full_code, gen_salt('bf'))
        WHERE group_id = g.id AND role_type = 'responsable';
        IF NOT FOUND THEN
            INSERT INTO public.group_secret_codes (group_id, role_type, raw_code, code_hash)
            VALUES (g.id, 'responsable', v_full_code, crypt(v_full_code, gen_salt('bf')));
        END IF;
        
        -- Validateur
        v_random_part := UPPER(substring(md5(random()::text) from 1 for 4));
        v_full_code := 'VALIDATEUR-' || UPPER(g.code) || '-' || v_random_part || '-2026';
        UPDATE public.group_secret_codes 
        SET raw_code = v_full_code,
            code_hash = crypt(v_full_code, gen_salt('bf'))
        WHERE group_id = g.id AND role_type = 'validateur';
        IF NOT FOUND THEN
            INSERT INTO public.group_secret_codes (group_id, role_type, raw_code, code_hash)
            VALUES (g.id, 'validateur', v_full_code, crypt(v_full_code, gen_salt('bf')));
        END IF;

        -- Organisateur
        v_random_part := UPPER(substring(md5(random()::text) from 1 for 4));
        v_full_code := 'ORGANISATEUR-' || UPPER(g.code) || '-' || v_random_part || '-2026';
        UPDATE public.group_secret_codes 
        SET raw_code = v_full_code,
            code_hash = crypt(v_full_code, gen_salt('bf'))
        WHERE group_id = g.id AND role_type = 'organisateur';
        IF NOT FOUND THEN
            INSERT INTO public.group_secret_codes (group_id, role_type, raw_code, code_hash)
            VALUES (g.id, 'organisateur', v_full_code, crypt(v_full_code, gen_salt('bf')));
        END IF;
    END LOOP;
END $$;

COMMIT;

COMMENT ON COLUMN public.role_secret_codes.raw_code IS 'Code en clair pour référence administrateur';
COMMENT ON COLUMN public.group_secret_codes.raw_code IS 'Code en clair pour référence administrateur';
