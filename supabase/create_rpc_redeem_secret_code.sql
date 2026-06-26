-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║  CRÉATION DES RPC — VÉRIFICATION DE CODE DÉTERMINISTE                    ║
-- ║                                                                            ║
-- ║  DÉCOUVERTES DU DIAGNOSTIC :                                              ║
-- ║  • role_secret_codes.code_hash = bcrypt ($2a$06$...)                      ║
-- ║  • role_secret_codes.raw_code = texte en clair (nullable)                 ║
-- ║  • role_secret_codes.normalized_code = sans tirets (nullable)             ║
-- ║  • AUCUNE RPC existante (redeem_secret_code, verify_universal_code)       ║
-- ║  • La table contient bien 46 codes, tous avec role_code valide dans roles ║
-- ║                                                                            ║
-- ║  EXÉCUTER DANS LE SQL EDITOR SUPABASE — une section à la fois            ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- ══════════════════════════════════════════════════════════════════════════════
-- ÉTAPE 0 : Activer pgcrypto (nécessaire pour bcrypt)
-- ══════════════════════════════════════════════════════════════════════════════

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ══════════════════════════════════════════════════════════════════════════════
-- ÉTAPE 1 : RPC verify_secret_code (NON-DESTRUCTIVE — ne marque PAS comme utilisé)
--
-- Utilisée pour vérifier un code SANS le consommer (avant l'assignation du rôle).
-- Retourne { role_code, raw_code, is_used } ou vide.
-- ══════════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION public.verify_secret_code(p_code TEXT)
RETURNS TABLE(role_code TEXT, raw_code TEXT, is_used BOOLEAN)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_row RECORD;
    v_normalized TEXT;
BEGIN
    -- Normaliser le code entré : UPPER + supprimer les tirets et espaces
    v_normalized := UPPER(REPLACE(REPLACE(p_code, '-', ''), ' ', ''));
    
    -- ── NIVEAU 1 : Vérification bcrypt (méthode sécurisée) ──
    FOR v_row IN 
        SELECT id, role_code, raw_code, is_used, code_hash
        FROM public.role_secret_codes
        WHERE code_hash = crypt(p_code, code_hash)
        LIMIT 1
    LOOP
        RETURN QUERY SELECT v_row.role_code, v_row.raw_code, v_row.is_used;
        RETURN;
    END LOOP;
    
    -- ── NIVEAU 2 : Comparaison exacte sur raw_code ──
    FOR v_row IN 
        SELECT id, role_code, raw_code, is_used
        FROM public.role_secret_codes
        WHERE raw_code = UPPER(p_code)
        LIMIT 1
    LOOP
        RETURN QUERY SELECT v_row.role_code, v_row.raw_code, v_row.is_used;
        RETURN;
    END LOOP;
    
    -- ── NIVEAU 3 : Comparaison sur normalized_code (sans tirets) ──
    FOR v_row IN 
        SELECT id, role_code, raw_code, is_used
        FROM public.role_secret_codes
        WHERE normalized_code = v_normalized
        LIMIT 1
    LOOP
        RETURN QUERY SELECT v_row.role_code, v_row.raw_code, v_row.is_used;
        RETURN;
    END LOOP;
    
    -- Aucun match — retourner vide
    RETURN;
END;
$$;

-- ══════════════════════════════════════════════════════════════════════════════
-- ÉTAPE 2 : RPC redeem_secret_code (DESTRUCTIVE — marque comme utilisé)
--
-- Flux DÉTERMINISTE (3 niveaux de vérification) :
--   1. bcrypt : code_hash = crypt(p_code, code_hash) — SÉCURISÉ
--   2. raw_code : comparaison exacte — FALLBACK
--   3. normalized_code : comparaison sans tirets — DERNIER RECOURS
--
-- En cas de succès :
--   - Retourne { role_code, raw_code, is_used }
--   - Marque le code comme utilisé (is_used, used_by_user_id, used_at)
-- ══════════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION public.redeem_secret_code(p_code TEXT)
RETURNS TABLE(role_code TEXT, raw_code TEXT, is_used BOOLEAN)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_row RECORD;
    v_normalized TEXT;
BEGIN
    -- Normaliser le code entré : UPPER + supprimer les tirets et espaces
    v_normalized := UPPER(REPLACE(REPLACE(p_code, '-', ''), ' ', ''));
    
    -- ── NIVEAU 1 : Vérification bcrypt (méthode sécurisée) ──
    FOR v_row IN 
        SELECT id, role_code, raw_code, is_used, code_hash
        FROM public.role_secret_codes
        WHERE code_hash = crypt(p_code, code_hash)
        LIMIT 1
    LOOP
        -- Marquer comme utilisé
        UPDATE public.role_secret_codes
        SET is_used = true,
            used_by_user_id = auth.uid(),
            used_at = now(),
            updated_at = now()
        WHERE id = v_row.id;
        
        RETURN QUERY SELECT v_row.role_code, v_row.raw_code, true;
        RETURN;
    END LOOP;
    
    -- ── NIVEAU 2 : Comparaison exacte sur raw_code ──
    FOR v_row IN 
        SELECT id, role_code, raw_code, is_used
        FROM public.role_secret_codes
        WHERE raw_code = UPPER(p_code)
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
    
    -- ── NIVEAU 3 : Comparaison sur normalized_code (sans tirets) ──
    FOR v_row IN 
        SELECT id, role_code, raw_code, is_used
        FROM public.role_secret_codes
        WHERE normalized_code = v_normalized
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
    
    -- Aucun match — retourner vide
    RETURN;
END;
$$;

-- Accorder les droits d'exécution
GRANT EXECUTE ON FUNCTION public.verify_secret_code(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.redeem_secret_code(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.redeem_secret_code(TEXT) TO anon;

-- ══════════════════════════════════════════════════════════════════════════════
-- ÉTAPE 3 : RPC assign_user_role
--
-- Après vérification du code, cette RPC :
--   1. Cherche le role_id dans la table roles
--   2. Insère dans user_roles (upsert)
--   3. Met à jour user_sessions avec le rôle actif
--   4. Met à jour profiles.needs_onboarding = false
--
-- SECURITY DEFINER : bypass RLS pour écrire dans les tables système
-- ══════════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION public.assign_user_role(
    p_user_id UUID,
    p_role_code TEXT,
    p_church_id UUID DEFAULT NULL
)
RETURNS TABLE(success BOOLEAN, message TEXT)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_role_id UUID;
    v_church_id UUID;
BEGIN
    -- 1. Trouver l'ID du rôle dans la table roles
    SELECT id INTO v_role_id
    FROM public.roles
    WHERE code = p_role_code
    LIMIT 1;
    
    IF v_role_id IS NULL THEN
        RETURN QUERY SELECT false, 'Rôle non trouvé: ' || p_role_code;
        RETURN;
    END IF;
    
    -- Church ID : utiliser celui passé, ou chercher dans profiles, ou 'default'
    IF p_church_id IS NOT NULL THEN
        v_church_id := p_church_id;
    ELSE
        SELECT church_id INTO v_church_id
        FROM public.profiles
        WHERE id = p_user_id
        LIMIT 1;
    END IF;
    
    IF v_church_id IS NULL THEN
        v_church_id := '00000000-0000-0000-0000-000000000000';
    END IF;
    
    -- 2. Insérer dans user_roles (upsert)
    INSERT INTO public.user_roles (user_id, role_id, church_id)
    VALUES (p_user_id, v_role_id, v_church_id)
    ON CONFLICT (user_id, role_id) 
    DO UPDATE SET church_id = EXCLUDED.church_id;
    
    -- 3. Mettre à jour user_sessions avec le rôle actif
    INSERT INTO public.user_sessions (user_id, active_role_id, active_group_id, last_switch)
    VALUES (p_user_id, v_role_id, NULL, now())
    ON CONFLICT (user_id)
    DO UPDATE SET 
        active_role_id = EXCLUDED.active_role_id,
        last_switch = now();
    
    -- 4. Mettre à jour profiles.needs_onboarding = false
    UPDATE public.profiles
    SET needs_onboarding = false,
        updated_at = now()
    WHERE id = p_user_id;
    
    -- Si pas de profil, en créer un
    INSERT INTO public.profiles (id, needs_onboarding, church_id, created_at, updated_at)
    VALUES (p_user_id, false, v_church_id, now(), now())
    ON CONFLICT (id) DO NOTHING;
    
    RETURN QUERY SELECT true, 'Rôle assigné avec succès: ' || p_role_code;
END;
$$;

-- Accorder les droits d'exécution
GRANT EXECUTE ON FUNCTION public.assign_user_role(UUID, TEXT, UUID) TO authenticated;

-- ══════════════════════════════════════════════════════════════════════════════
-- ÉTAPE 4 : Vérifier les politiques RLS sur role_secret_codes
-- ══════════════════════════════════════════════════════════════════════════════

-- Activer RLS sur role_secret_codes (sécurité)
ALTER TABLE public.role_secret_codes ENABLE ROW LEVEL SECURITY;

-- Les utilisateurs authentifiés NE peuvent PAS lire la table directement
-- (ils doivent passer par la RPC redeem_secret_code qui est SECURITY DEFINER)
CREATE POLICY "Authenticated users use RPC only - no direct SELECT"
    ON public.role_secret_codes
    FOR SELECT
    TO authenticated
    USING (false);

-- Les anon ne peuvent rien faire
CREATE POLICY "Anon users denied"
    ON public.role_secret_codes
    FOR ALL
    TO anon
    USING (false)
    WITH CHECK (false);

-- ══════════════════════════════════════════════════════════════════════════════
-- ÉTAPE 5 : TESTS DE VALIDATION (NON-DESTRUCTIFS — utilisent verify_secret_code)
-- ══════════════════════════════════════════════════════════════════════════════

-- Test 1 : Vérifier que la RPC verify_secret_code fonctionne avec bcrypt (NON-DESTRUCTIF)
SELECT 'TEST 1 — verify_secret_code bcrypt' AS test;
SELECT * FROM public.verify_secret_code('PASTEUR-0081-2026');
-- Attendu : role_code = "pasteur", raw_code = "PASTEUR-0081-2026"

-- Test 2 : Vérifier avec un code normalisé (sans tirets)
SELECT 'TEST 2 — verify_secret_code normalized' AS test;
SELECT * FROM public.verify_secret_code('PASTEUR00812026');
-- Attendu : role_code = "pasteur" (même résultat via normalized_code)

-- Test 3 : Vérifier avec un code inexistant
SELECT 'TEST 3 — code inexistant' AS test;
SELECT * FROM public.verify_secret_code('FAKE-CODE-9999-2026');
-- Attendu : 0 lignes (null côté Flutter)

-- Test 4 : Vérifier que le bcrypt fonctionne vraiment
SELECT 'TEST 4 — bcrypt direct verification' AS test;
SELECT 
    raw_code,
    CASE WHEN code_hash = crypt('PASTEUR-0081-2026', code_hash) 
         THEN '✅ BCRYPT MATCH' 
         ELSE '❌ NO MATCH' 
    END AS bcrypt_test
FROM public.role_secret_codes
WHERE raw_code = 'PASTEUR-0081-2026';

-- Test 5 : Vérifier que les RPC sont bien créées
SELECT 'TEST 5 — RPC list' AS test;
SELECT 
    p.proname,
    pg_get_function_arguments(p.oid) AS args,
    pg_get_function_result(p.oid) AS result
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'public'
  AND p.proname IN ('verify_secret_code', 'redeem_secret_code', 'assign_user_role');

-- Test 6 : Test DESTRUCTIF — redeem (uniquement si vous voulez tester le flux complet)
-- ATTENTION : ceci marque le code comme UTILISÉ
-- SELECT 'TEST 6 — redeem_secret_code (DESTRUCTIF)' AS test;
-- SELECT * FROM public.redeem_secret_code('TRESORIER-5E47-2026');
-- Attendu : role_code = "tresorier", is_used = true

-- ══════════════════════════════════════════════════════════════════════════════
-- ÉTAPE 6 : Réinitialiser les codes marqués comme utilisés (optionnel)
-- ══════════════════════════════════════════════════════════════════════════════

-- Si tu veux que les codes soient réutilisables (multi-utilisateur),
-- décommente cette requête :

-- UPDATE public.role_secret_codes SET is_used = false, used_by_user_id = NULL, used_at = NULL;
