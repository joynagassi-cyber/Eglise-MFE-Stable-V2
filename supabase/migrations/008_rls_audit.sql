-- ============================================================
-- AUDIT RLS - Vérification Row Level Security
-- Système de Gestion d'Église Lumina
-- ============================================================
-- Ce script vérifie que RLS est activé sur toutes les tables
-- et identifie les policies manquantes
-- ============================================================
-- 1. VÉRIFICATION RLS ACTIVÉ
-- ============================================================
SELECT schemaname,
    tablename,
    CASE
        WHEN rowsecurity THEN '✅ RLS ACTIVÉ'
        ELSE '❌ RLS DÉSACTIVÉ - CRITIQUE'
    END as status,
    rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
    AND tablename NOT LIKE 'pg_%'
    AND tablename NOT LIKE '_%'
ORDER BY rowsecurity ASC,
    tablename;
-- 2. LISTE DES TABLES SANS RLS (CRITIQUE)
-- ============================================================
SELECT tablename as "⚠️ TABLES SANS RLS"
FROM pg_tables
WHERE schemaname = 'public'
    AND rowsecurity = false
    AND tablename NOT LIKE 'pg_%'
    AND tablename NOT LIKE '_%'
ORDER BY tablename;
-- 3. VÉRIFICATION DES POLICIES EXISTANTES
-- ============================================================
SELECT schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd as operation,
    CASE
        WHEN qual IS NOT NULL THEN '✅ Condition définie'
        ELSE '⚠️ Pas de condition'
    END as has_condition
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename,
    policyname;
-- 4. COMPTAGE DES POLICIES PAR TABLE
-- ============================================================
SELECT t.tablename,
    t.rowsecurity as rls_enabled,
    COUNT(p.policyname) as policy_count,
    CASE
        WHEN t.rowsecurity = false THEN '🔴 RLS désactivé'
        WHEN COUNT(p.policyname) = 0 THEN '🟡 RLS activé mais aucune policy'
        WHEN COUNT(p.policyname) < 4 THEN '🟠 Policies incomplètes (< 4)'
        ELSE '✅ OK'
    END as status
FROM pg_tables t
    LEFT JOIN pg_policies p ON t.tablename = p.tablename
    AND t.schemaname = p.schemaname
WHERE t.schemaname = 'public'
    AND t.tablename NOT LIKE 'pg_%'
    AND t.tablename NOT LIKE '_%'
GROUP BY t.tablename,
    t.rowsecurity
ORDER BY CASE
        WHEN t.rowsecurity = false THEN 1
        WHEN COUNT(p.policyname) = 0 THEN 2
        WHEN COUNT(p.policyname) < 4 THEN 3
        ELSE 4
    END,
    t.tablename;
-- 5. VÉRIFICATION FONCTION auth.uid()
-- ============================================================
-- Vérifie que la fonction auth.uid() est disponible (Supabase)
SELECT CASE
        WHEN EXISTS (
            SELECT 1
            FROM pg_proc
            WHERE proname = 'uid'
                AND pronamespace = (
                    SELECT oid
                    FROM pg_namespace
                    WHERE nspname = 'auth'
                )
        ) THEN '✅ auth.uid() disponible'
        ELSE '❌ auth.uid() MANQUANTE - Vérifier Supabase Auth'
    END as auth_function_status;
-- 6. RECOMMANDATIONS
-- ============================================================
DO $$
DECLARE tables_without_rls INTEGER;
tables_without_policies INTEGER;
BEGIN -- Compter tables sans RLS
SELECT COUNT(*) INTO tables_without_rls
FROM pg_tables
WHERE schemaname = 'public'
    AND rowsecurity = false
    AND tablename NOT LIKE 'pg_%'
    AND tablename NOT LIKE '_%';
-- Compter tables sans policies
SELECT COUNT(*) INTO tables_without_policies
FROM pg_tables t
    LEFT JOIN pg_policies p ON t.tablename = p.tablename
    AND t.schemaname = p.schemaname
WHERE t.schemaname = 'public'
    AND t.rowsecurity = true
    AND t.tablename NOT LIKE 'pg_%'
    AND t.tablename NOT LIKE '_%'
GROUP BY t.tablename
HAVING COUNT(p.policyname) = 0;
RAISE NOTICE '';
RAISE NOTICE '============================================================';
RAISE NOTICE 'RÉSUMÉ AUDIT RLS';
RAISE NOTICE '============================================================';
RAISE NOTICE 'Tables sans RLS: % (CRITIQUE si > 0)',
tables_without_rls;
RAISE NOTICE 'Tables sans policies: % (IMPORTANT si > 0)',
COALESCE(tables_without_policies, 0);
RAISE NOTICE '';
IF tables_without_rls > 0 THEN RAISE NOTICE '🔴 ACTION REQUISE: Activer RLS sur toutes les tables';
RAISE NOTICE '   Exécuter: ALTER TABLE <table_name> ENABLE ROW LEVEL SECURITY;';
END IF;
IF COALESCE(tables_without_policies, 0) > 0 THEN RAISE NOTICE '🟡 ACTION RECOMMANDÉE: Créer policies pour tables sans protection';
RAISE NOTICE '   Exécuter le script: 009_rls_policies_complete.sql';
END IF;
IF tables_without_rls = 0
AND COALESCE(tables_without_policies, 0) = 0 THEN RAISE NOTICE '✅ SÉCURITÉ OK: Toutes les tables ont RLS + policies';
END IF;
RAISE NOTICE '============================================================';
RAISE NOTICE '';
END $$;
-- 7. SCRIPT DE CORRECTION AUTOMATIQUE (À DÉCOMMENTER SI NÉCESSAIRE)
-- ============================================================
-- ⚠️ ATTENTION: Ce script active RLS sur TOUTES les tables sans RLS
-- Décommenter uniquement après validation manuelle
/*
 DO $$
 DECLARE
 table_record RECORD;
 BEGIN
 FOR table_record IN 
 SELECT tablename 
 FROM pg_tables 
 WHERE schemaname = 'public'
 AND rowsecurity = false
 AND tablename NOT LIKE 'pg_%'
 AND tablename NOT LIKE '_%'
 LOOP
 EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', table_record.tablename);
 RAISE NOTICE '✅ RLS activé sur: %', table_record.tablename;
 END LOOP;
 END $$;
 */