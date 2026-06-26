-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║  SCRIPT DE DIAGNOSTIC — ROLE CODE VERIFICATION                            ║
-- ║  But : Comprendre EN PROFONDEUR les tables impliquées dans la              ║
-- ║        vérification de code secret pour écrire le code sans ambiguïté.     ║
-- ║                                                                            ║
-- ║  Exécuter dans le SQL Editor Supabase (dashboard.supabase.com)             ║
-- ║  Résultat attendu : chaque section affiche la structure réelle             ║
-- ║  et les données de chaque table critique.                                  ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- ══════════════════════════════════════════════════════════════════════════════
-- SECTION 1 : STRUCTURE DES TABLES
-- ══════════════════════════════════════════════════════════════════════════════

-- 1A. Structure complète de role_secret_codes
SELECT '1A. role_secret_codes — colonnes' AS section;
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default,
    character_maximum_length,
    udt_name
FROM information_schema.columns
WHERE table_schema = 'public' 
  AND table_name = 'role_secret_codes'
ORDER BY ordinal_position;

-- 1B. Contraintes et index sur role_secret_codes
SELECT '1B. role_secret_codes — contraintes' AS section;
SELECT 
    conname AS constraint_name,
    contype AS constraint_type,
    pg_get_constraintdef(oid) AS definition
FROM pg_constraint
WHERE conrelid = 'public.role_secret_codes'::regclass;

-- 1C. Index sur role_secret_codes
SELECT '1C. role_secret_codes — index' AS section;
SELECT 
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public' 
  AND tablename = 'role_secret_codes';

-- 1D. Politiques RLS sur role_secret_codes
SELECT '1D. role_secret_codes — RLS policies' AS section;
SELECT 
    polname AS policy_name,
    polcmd AS command,
    polroles::regrole[] AS roles,
    pg_get_expr(polqual, polrelid) AS using_expr,
    pg_get_expr(polwithcheck, polrelid) AS with_check_expr
FROM pg_policy
WHERE polrelid = 'public.role_secret_codes'::regclass;

-- 1E. RLS activé ?
SELECT '1E. role_secret_codes — RLS enabled?' AS section;
SELECT relname, relrowsecurity 
FROM pg_class 
WHERE oid = 'public.role_secret_codes'::regclass;

-- ══════════════════════════════════════════════════════════════════════════════
-- SECTION 2 : DONNÉES RÉELLES
-- ══════════════════════════════════════════════════════════════════════════════

-- 2A. Toutes les entrées de role_secret_codes (pour voir le mapping exact)
SELECT '2A. role_secret_codes — toutes les données' AS section;
SELECT * FROM role_secret_codes ORDER BY role_code;

-- 2B. Test de matching exact avec les codes du CSV
SELECT '2B. Test matching — codes CSV vs table' AS section;
SELECT 
    rsc.role_code,
    rsc.raw_code,
    CASE WHEN rsc.raw_code = 'PASTEUR-0081-2026' THEN 'MATCH_PASTEUR' ELSE '' END AS test_pasteur,
    CASE WHEN rsc.raw_code = 'TRESORIER-5E47-2026' THEN 'MATCH_TRESORIER' ELSE '' END AS test_tresorier,
    CASE WHEN rsc.raw_code = 'SUPER-ADMIN-5FA1-2026' THEN 'MATCH_SUPER_ADMIN' ELSE '' END AS test_super_admin,
    CASE WHEN rsc.raw_code = 'ADMINISTRATEUR-SYSTEME-C653-2026' THEN 'MATCH_ADMIN_SYS' ELSE '' END AS test_admin_sys
FROM role_secret_codes rsc
WHERE rsc.raw_code IN (
    'PASTEUR-0081-2026',
    'TRESORIER-5E47-2026',
    'SUPER-ADMIN-5FA1-2026',
    'ADMINISTRATEUR-SYSTEME-C653-2026'
);

-- 2C. Vérification : y a-t-il d'autres colonnes de code ? (code_secret, secret_code, etc.)
SELECT '2C. Colonnes contenant "code" dans role_secret_codes' AS section;
SELECT column_name, data_type 
FROM information_schema.columns
WHERE table_schema = 'public' 
  AND table_name = 'role_secret_codes'
  AND column_name ILIKE '%code%';

-- ══════════════════════════════════════════════════════════════════════════════
-- SECTION 3 : TABLE ROLES (le mapping role_code → RoleLevel)
-- ══════════════════════════════════════════════════════════════════════════════

-- 3A. Structure de la table roles
SELECT '3A. roles — colonnes' AS section;
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public' 
  AND table_name = 'roles'
ORDER BY ordinal_position;

-- 3B. Toutes les entrées de la table roles
SELECT '3B. roles — toutes les données' AS section;
SELECT id, code, label, is_super, priority_level FROM roles ORDER BY priority_level;

-- 3C. Vérification de cohérence : role_code dans role_secret_codes → existe dans roles ?
SELECT '3C. Cohérence role_secret_codes.role_code → roles.code' AS section;
SELECT 
    rsc.role_code,
    CASE WHEN r.id IS NOT NULL THEN 'OK' ELSE 'ORPHELIN — absent de roles !' END AS status,
    r.label AS role_label
FROM role_secret_codes rsc
LEFT JOIN roles r ON rsc.role_code = r.code
ORDER BY rsc.role_code;

-- ══════════════════════════════════════════════════════════════════════════════
-- SECTION 4 : TABLES user_roles ET user_sessions
-- ══════════════════════════════════════════════════════════════════════════════

-- 4A. Structure de user_roles
SELECT '4A. user_roles — colonnes' AS section;
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public' 
  AND table_name = 'user_roles'
ORDER BY ordinal_position;

-- 4B. Structure de user_sessions
SELECT '4B. user_sessions — colonnes' AS section;
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public' 
  AND table_name = 'user_sessions'
ORDER BY ordinal_position;

-- 4C. RLS policies sur user_roles
SELECT '4C. user_roles — RLS policies' AS section;
SELECT 
    polname AS policy_name,
    polcmd AS command,
    pg_get_expr(polqual, polrelid) AS using_expr
FROM pg_policy
WHERE polrelid = 'public.user_roles'::regclass;

-- ══════════════════════════════════════════════════════════════════════════════
-- SECTION 5 : TABLE profiles
-- ══════════════════════════════════════════════════════════════════════════════

-- 5A. Structure de profiles
SELECT '5A. profiles — colonnes' AS section;
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public' 
  AND table_name = 'profiles'
ORDER BY ordinal_position;

-- ══════════════════════════════════════════════════════════════════════════════
-- SECTION 6 : RPC EXISTANTES
-- ══════════════════════════════════════════════════════════════════════════════

-- 6A. La fonction redeem_secret_code existe-t-elle ?
SELECT '6A. redeem_secret_code — existe ?' AS section;
SELECT 
    p.proname AS function_name,
    pg_get_function_arguments(p.oid) AS arguments,
    pg_get_function_result(p.oid) AS return_type,
    l.lanname AS language,
    p.prosrc AS source_code
FROM pg_proc p
JOIN pg_language l ON p.prolang = l.oid
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'public' 
  AND p.proname = 'redeem_secret_code';

-- 6B. La fonction verify_universal_code existe-t-elle ?
SELECT '6B. verify_universal_code — existe ?' AS section;
SELECT 
    p.proname AS function_name,
    pg_get_function_arguments(p.oid) AS arguments,
    pg_get_function_result(p.oid) AS return_type,
    p.prosrc AS source_code
FROM pg_proc p
JOIN pg_language l ON p.prolang = l.oid
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'public' 
  AND p.proname = 'verify_universal_code';

-- 6C. Toutes les fonctions RPC du schéma public
SELECT '6C. Toutes les fonctions RPC public' AS section;
SELECT 
    p.proname AS function_name,
    pg_get_function_arguments(p.oid) AS arguments,
    pg_get_function_result(p.oid) AS return_type
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'public'
  AND p.proname ILIKE '%code%' OR p.proname ILIKE '%role%' OR p.proname ILIKE '%secret%'
ORDER BY p.proname;

-- ══════════════════════════════════════════════════════════════════════════════
-- SECTION 7 : TESTS DE REQUÊTES EXACTES (ce que le code Flutter fera)
-- ══════════════════════════════════════════════════════════════════════════════

-- 7A. Simule l'appel Flutter : .eq('raw_code', 'PASTEUR-0081-2026')
SELECT '7A. Simulation .eq(raw_code, PASTEUR-0081-2026)' AS section;
SELECT role_code, raw_code FROM role_secret_codes 
WHERE raw_code = 'PASTEUR-0081-2026';

-- 7B. Même test avec UPPER() (au cas où le code en base serait en minuscules)
SELECT '7B. Test UPPER — raw_code normalisé' AS section;
SELECT role_code, raw_code, UPPER(raw_code) as normalized 
FROM role_secret_codes 
WHERE UPPER(raw_code) = 'PASTEUR-0081-2026';

-- 7C. Test avec ilike (insensible à la casse)
SELECT '7C. Test ilike' AS section;
SELECT role_code, raw_code FROM role_secret_codes 
WHERE raw_code ILIKE 'PASTEUR-0081-2026';

-- 7D. Test de la colonne code_secret (si elle existe)
SELECT '7D. Test .eq(code_secret, ...)' AS section;
SELECT role_code, raw_code FROM role_secret_codes 
WHERE raw_code ILIKE 'TRESORIER-5E47-2026' 
   OR raw_code ILIKE 'SUPER-ADMIN-5FA1-2026';

-- 7E. Test complet : récupérer le rôle ET son RoleLevel correspondant
SELECT '7E. Matching complet code → role → level' AS section;
SELECT 
    rsc.raw_code,
    rsc.role_code,
    r.code AS role_table_code,
    r.label AS role_label,
    r.is_super,
    r.priority_level
FROM role_secret_codes rsc
LEFT JOIN roles r ON rsc.role_code = r.code
WHERE rsc.raw_code IN (
    'PASTEUR-0081-2026',
    'TRESORIER-5E47-2026',
    'SUPER-ADMIN-5FA1-2026',
    'ADMINISTRATEUR-SYSTEME-C653-2026',
    'SECRETAIRE-GENERAL-53D4-2026',
    'CHEF-CHORALE-048C-2026',
    'CONSEILLER-151B-2026',
    'BENEVOLE-784B-2026'
)
ORDER BY r.priority_level;

-- ══════════════════════════════════════════════════════════════════════════════
-- SECTION 8 : VÉRIFICATION DES PERMISSIONS RLS (depuis le client anon/auth)
-- ══════════════════════════════════════════════════════════════════════════════

-- 8A. Test SELECT sur role_secret_codes avec le rôle anon (simulé)
-- Ce test vérifie si un client mobile peut lire la table directement
SELECT '8A. Test accès lecture — role_secret_codes (sera affecté par RLS)' AS section;
-- Si RLS est activé sans policy SELECT pour anon/auth, le client ne pourra pas lire !
-- Vérifiez le résultat de 1D/1E ci-dessus.

-- ══════════════════════════════════════════════════════════════════════════════
-- SECTION 9 : DIAGNOSTIC DU FLUX COMPLET
-- ══════════════════════════════════════════════════════════════════════════════

-- 9A. Simule le flux complet : 
--   1) User entre "PASTEUR-0081-2026"
--   2) On cherche dans role_secret_codes
--   3) On obtient role_code = "pasteur"
--   4) On insère dans user_roles
--   5) On met à jour profiles.needs_onboarding = false
--   6) get-user-context retourne le bon contexte
SELECT '9A. Simulation flux complet (lecture seule)' AS section;

WITH code_lookup AS (
    SELECT role_code, raw_code 
    FROM role_secret_codes 
    WHERE raw_code = 'PASTEUR-0081-2026'
    LIMIT 1
),
role_info AS (
    SELECT r.id, r.code, r.label, r.is_super, r.priority_level
    FROM roles r
    JOIN code_lookup cl ON r.code = cl.role_code
)
SELECT 
    cl.raw_code AS "Code entré",
    cl.role_code AS "role_code trouvé",
    ri.label AS "Rôle label",
    ri.is_super AS "is_super",
    ri.priority_level AS "priority_level",
    CASE 
        WHEN ri.code IS NOT NULL THEN '✅ FLUX OK — code → rôle → level'
        ELSE '❌ CASSÉ — role_code ne correspond à aucun rôle dans la table roles'
    END AS diagnostic
FROM code_lookup cl
LEFT JOIN role_info ri ON true;

-- 9B. Vérifier s'il y a des codes avec role_code orphelins (absents de roles)
SELECT '9B. Codes orphelins (role_code absent de roles)' AS section;
SELECT rsc.raw_code, rsc.role_code,
    CASE WHEN r.id IS NULL THEN '❌ ORPHELIN' ELSE '✅ OK' END AS status
FROM role_secret_codes rsc
LEFT JOIN roles r ON rsc.role_code = r.code
WHERE r.id IS NULL;

-- ══════════════════════════════════════════════════════════════════════════════
-- SECTION 10 : CRÉATION DE LA RPC MANQUANTE (si inexistante)
-- ══════════════════════════════════════════════════════════════════════════════

-- Si les sections 6A/6B montrent que redeem_secret_code n'existe pas,
-- décommenter et exécuter ce qui suit :

/*
CREATE OR REPLACE FUNCTION public.redeem_secret_code(p_code TEXT)
RETURNS TABLE(role_code TEXT, raw_code TEXT, is_used BOOLEAN)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_role_code TEXT;
    v_raw_code TEXT;
BEGIN
    -- Recherche EXACTE (déterministe)
    SELECT rs.role_code, rs.raw_code
    INTO v_role_code, v_raw_code
    FROM public.role_secret_codes rs
    WHERE UPPER(rs.raw_code) = UPPER(p_code)
    LIMIT 1;
    
    IF NOT FOUND THEN
        RETURN;
    END IF;
    
    RETURN QUERY SELECT v_role_code, v_raw_code, FALSE AS is_used;
END;
$$;

-- Accorder les droits d'exécution
GRANT EXECUTE ON FUNCTION public.redeem_secret_code(TEXT) TO anon, authenticated;

-- Politique RLS pour que les utilisateurs authentifiés puissent lire les codes
ALTER TABLE public.role_secret_codes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can read role codes"
    ON public.role_secret_codes
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Anon users cannot read role codes"
    ON public.role_secret_codes
    FOR SELECT
    TO anon
    USING (false);
*/

-- ══════════════════════════════════════════════════════════════════════════════
-- SECTION 11 : INSERTION DES CODES SI LA TABLE EST VIDE
-- ══════════════════════════════════════════════════════════════════════════════

-- Si 2A retourne 0 lignes, la table est vide. Décommenter pour insérer les codes :

/*
INSERT INTO public.role_secret_codes (role_code, raw_code) VALUES
    ('administrateur_systeme', 'ADMINISTRATEUR-SYSTEME-C653-2026'),
    ('administrateur_systeme_adjoint', 'ADMINISTRATEUR-SYSTEME-ADJOINT-C495-2026'),
    ('auditeur', 'AUDITEUR-F2CA-2026'),
    ('auditeur_interne', 'AUDITEUR-INTERNE-F559-2026'),
    ('auditeur_interne_adjoint', 'AUDITEUR-INTERNE-ADJOINT-D1CC-2026'),
    ('benevole', 'BENEVOLE-784B-2026'),
    ('chef_chorale', 'CHEF-CHORALE-048C-2026'),
    ('chef_intercession', 'CHEF-INTERCESSION-022E-2026'),
    ('commissaire_aux_comptes', 'COMMISSAIRE-AUX-COMPTES-643F-2026'),
    ('commissaire_aux_comptes_adjoint', 'COMMISSAIRE-AUX-COMPTES-ADJOINT-F5EC-2026'),
    ('commissaire_compte', 'COMMISSAIRE-COMPTE-82FB-2026'),
    ('comptable', 'COMPTABLE-084D-2026'),
    ('comptable_adjoint', 'COMPTABLE-ADJOINT-5FB3-2026'),
    ('conseiller', 'CONSEILLER-151B-2026'),
    ('conseiller_adjoint', 'CONSEILLER-ADJOINT-6E6E-2026'),
    ('conseiller_principal', 'CONSEILLER-PRINCIPAL-82EC-2026'),
    ('coordinateur_formation', 'COORDINATEUR-FORMATION-CD3B-2026'),
    ('donateur', 'DONATEUR-8A53-2026'),
    ('gestionnaire_budget_event', 'GESTIONNAIRE-BUDGET-EVENT-1B26-2026'),
    ('gestionnaire_documents', 'GESTIONNAIRE-DOCUMENTS-450D-2026'),
    ('maitre_chorale', 'MAITRE-CHORALE-306D-2026'),
    ('moniteur_enfants', 'MONITEUR-ENFANTS-13E2-2026'),
    ('organisateur_evenement', 'ORGANISATEUR-EVENEMENT-1BCE-2026'),
    ('pasteur', 'PASTEUR-0081-2026'),
    ('pasteur_adjoint', 'PASTEUR-ADJOINT-B2A0-2026'),
    ('pasteur_principal', 'PASTEUR-PRINCIPAL-6D1A-2026'),
    ('president', 'PRESIDENT-E723-2026'),
    ('president_hommes', 'PRESIDENT-HOMMES-EF7C-2026'),
    ('president_hommes_adjoint', 'PRESIDENT-HOMMES-ADJOINT-26FA-2026'),
    ('president_jeunesse', 'PRESIDENT-JEUNESSE-4B2F-2026'),
    ('president_jeunesse_adjoint', 'PRESIDENT-JEUNESSE-ADJOINT-3B2B-2026'),
    ('presidente_femmes', 'PRESIDENTE-FEMMES-65D7-2026'),
    ('presidente_femmes_adjointe', 'PRESIDENTE-FEMMES-ADJOINTE-C513-2026'),
    ('responsable_archives', 'RESPONSABLE-ARCHIVES-78EE-2026'),
    ('responsable_enfants', 'RESPONSABLE-ENFANTS-2FBC-2026'),
    ('responsable_groupe', 'RESPONSABLE-GROUPE-469E-2026'),
    ('responsable_mission', 'RESPONSABLE-MISSION-A0D3-2026'),
    ('secretaire_adjoint', 'SECRETAIRE-ADJOINT-50FE-2026'),
    ('secretaire_general', 'SECRETAIRE-GENERAL-53D4-2026'),
    ('secretaire_general_adjoint', 'SECRETAIRE-GENERAL-ADJOINT-283B-2026'),
    ('super_admin', 'SUPER-ADMIN-5FA1-2026'),
    ('tresorier', 'TRESORIER-5E47-2026'),
    ('tresorier_adjoint', 'TRESORIER-ADJOINT-54B7-2026'),
    ('validateur_transaction', 'VALIDATEUR-TRANSACTION-6737-2026'),
    ('vice_president', 'VICE-PRESIDENT-0AF7-2026'),
    ('visiteur_temporaire', 'VISITEUR-TEMPORAIRE-8289-2026'),
    ('webmaster', 'WEBMASTER-8B65-2026')
ON CONFLICT DO NOTHING;
*/
