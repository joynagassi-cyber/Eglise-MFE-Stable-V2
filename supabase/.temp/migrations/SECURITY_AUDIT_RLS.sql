-- ═══════════════════════════════════════════════════════════════════════════════
--  v1.0.0 - AUDIT DE SÉCURITÉ SQL
-- ═══════════════════════════════════════════════════════════════════════════════
-- Release Manager: Lead QA Engineer
-- Date: 2025-01-29
-- Purpose: Vérification finale RLS et Policies avant déploiement production
-- ═══════════════════════════════════════════════════════════════════════════════

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ ÉTAPE 1: VÉRIFICATION RLS SUR TOUTES LES TABLES                              │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- Liste toutes les tables avec leur statut RLS
SELECT 
    schemaname,
    tablename,
    CASE 
        WHEN rowsecurity THEN '✅ RLS ACTIVÉ'
        ELSE '❌ RLS DÉSACTIVÉ - BLOQUANT!'
    END as rls_status,
    rowsecurity
FROM pg_tables 
WHERE schemaname = 'public'
AND tablename NOT LIKE 'pg_%'
AND tablename NOT LIKE '_%'
ORDER BY tablename;

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ ÉTAPE 2: VÉRIFICATION DES POLICIES EXISTANTES                                │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- Liste toutes les policies avec leurs détails
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles::text,
    cmd,
    CASE 
        WHEN qual IS NULL THEN 'ALL ROWS'
        ELSE 'WITH CHECK: ' || LEFT(qual::text, 50)
    END as filter_condition
FROM pg_policies 
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ ÉTAPE 3: TABLES SANS POLICIES (RISQUE DE SÉCURITÉ)                           │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- Tables avec RLS activé mais sans policies (BLOQUANT - personne ne peut accéder)
SELECT 
    t.tablename,
    '❌ SANS POLICIES - BLOQUANT!' as warning
FROM pg_tables t
LEFT JOIN pg_policies p ON t.tablename = p.tablename
WHERE t.schemaname = 'public'
AND t.rowsecurity = true
AND p.policyname IS NULL
AND t.tablename NOT LIKE 'pg_%'
ORDER BY t.tablename;

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ ÉTAPE 4: POLICIES ESSENTIELLES POUR CHAQUE TABLE                             │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- Vérification des policies requises pour membres
SELECT 
    'membres' as table_name,
    CASE WHEN EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'membres' AND cmd = 'SELECT'
    ) THEN '✅' ELSE '❌' END as has_select,
    CASE WHEN EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'membres' AND cmd = 'INSERT'
    ) THEN '✅' ELSE '❌' END as has_insert,
    CASE WHEN EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'membres' AND cmd = 'UPDATE'
    ) THEN '✅' ELSE '❌' END as has_update,
    CASE WHEN EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'membres' AND cmd = 'DELETE'
    ) THEN '✅' ELSE '❌' END as has_delete;

-- Vérification pour visites_pastorales
SELECT 
    'visites_pastorales' as table_name,
    CASE WHEN EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'visites_pastorales' AND cmd = 'SELECT'
    ) THEN '✅' ELSE '❌' END as has_select,
    CASE WHEN EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'visites_pastorales' AND cmd = 'INSERT'
    ) THEN '✅' ELSE '❌' END as has_insert,
    CASE WHEN EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'visites_pastorales' AND cmd = 'UPDATE'
    ) THEN '✅' ELSE '❌' END as has_update,
    CASE WHEN EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'visites_pastorales' AND cmd = 'DELETE'
    ) THEN '✅' ELSE '❌' END as has_delete;

-- Vérification pour finance_transactions
SELECT 
    'finance_transactions' as table_name,
    CASE WHEN EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'finance_transactions' AND cmd = 'SELECT'
    ) THEN '✅' ELSE '❌' END as has_select,
    CASE WHEN EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'finance_transactions' AND cmd = 'INSERT'
    ) THEN '✅' ELSE '❌' END as has_insert,
    CASE WHEN EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'finance_transactions' AND cmd = 'UPDATE'
    ) THEN '✅' ELSE '❌' END as has_update,
    CASE WHEN EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'finance_transactions' AND cmd = 'DELETE'
    ) THEN '✅' ELSE '❌' END as has_delete;

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ ÉTAPE 5: CRÉATION DES POLICIES MANQUANTES (SCRIPT DE RÉPARATION)             │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- Activer RLS sur toutes les tables si pas déjà fait
DO $$
DECLARE
    t record;
BEGIN
    FOR t IN 
        SELECT tablename 
        FROM pg_tables 
        WHERE schemaname = 'public'
        AND tablename NOT LIKE 'pg_%'
        AND tablename NOT LIKE '_%'
    LOOP
        EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY;', t.tablename);
    END LOOP;
END $$;

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ POLICIES STANDARD POUR APPLICATION ÉGLISE                                    │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- 1. TABLE: membres
-- Politique SELECT: Tous les utilisateurs authentifiés peuvent voir les membres actifs
DROP POLICY IF EXISTS "membres_select_auth" ON membres;
CREATE POLICY "membres_select_auth"
    ON membres FOR SELECT
    TO authenticated
    USING (deleted_at IS NULL OR deleted_at > NOW());

-- Politique INSERT: Seuls admin, pasteur, berger peuvent ajouter
DROP POLICY IF EXISTS "membres_insert_berger" ON membres;
CREATE POLICY "membres_insert_berger"
    ON membres FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM user_roles ur
            JOIN roles r ON ur.role_id = r.id
            WHERE ur.user_id = auth.uid()
            AND r.nom IN ('admin', 'pasteur', 'berger')
            AND ur.is_active = true
        )
    );

-- Politique UPDATE: Mêmes rôles + propriétaire
DROP POLICY IF EXISTS "membres_update_berger" ON membres;
CREATE POLICY "membres_update_berger"
    ON membres FOR UPDATE
    TO authenticated
    USING (
        created_by = auth.uid() OR
        EXISTS (
            SELECT 1 FROM user_roles ur
            JOIN roles r ON ur.role_id = r.id
            WHERE ur.user_id = auth.uid()
            AND r.nom IN ('admin', 'pasteur', 'berger')
            AND ur.is_active = true
        )
    );

-- 2. TABLE: visites_pastorales
-- SELECT: Tous les bergers peuvent voir
DROP POLICY IF EXISTS "visites_select_berger" ON visites_pastorales;
CREATE POLICY "visites_select_berger"
    ON visites_pastorales FOR SELECT
    TO authenticated
    USING (true);

-- INSERT: Berger assigné ou admin/pasteur
DROP POLICY IF EXISTS "visites_insert_berger" ON visites_pastorales;
CREATE POLICY "visites_insert_berger"
    ON visites_pastorales FOR INSERT
    TO authenticated
    WITH CHECK (
        berger_id = auth.uid() OR
        EXISTS (
            SELECT 1 FROM user_roles ur
            JOIN roles r ON ur.role_id = r.id
            WHERE ur.user_id = auth.uid()
            AND r.nom IN ('admin', 'pasteur')
            AND ur.is_active = true
        )
    );

-- UPDATE: Propriétaire ou admin/pasteur
DROP POLICY IF EXISTS "visites_update_owner" ON visites_pastorales;
CREATE POLICY "visites_update_owner"
    ON visites_pastorales FOR UPDATE
    TO authenticated
    USING (
        berger_id = auth.uid() OR
        EXISTS (
            SELECT 1 FROM user_roles ur
            JOIN roles r ON ur.role_id = r.id
            WHERE ur.user_id = auth.uid()
            AND r.nom IN ('admin', 'pasteur')
            AND ur.is_active = true
        )
    );

-- 3. TABLE: finance_transactions
-- SELECT: Admin, pasteur, trésorier uniquement
DROP POLICY IF EXISTS "finance_select_tresorier" ON finance_transactions;
CREATE POLICY "finance_select_tresorier"
    ON finance_transactions FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM user_roles ur
            JOIN roles r ON ur.role_id = r.id
            WHERE ur.user_id = auth.uid()
            AND r.nom IN ('admin', 'pasteur', 'tresorier')
            AND ur.is_active = true
        )
    );

-- INSERT: Mêmes rôles
DROP POLICY IF EXISTS "finance_insert_tresorier" ON finance_transactions;
CREATE POLICY "finance_insert_tresorier"
    ON finance_transactions FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM user_roles ur
            JOIN roles r ON ur.role_id = r.id
            WHERE ur.user_id = auth.uid()
            AND r.nom IN ('admin', 'pasteur', 'tresorier')
            AND ur.is_active = true
        )
    );

-- 4. TABLE: member_photos (nouvelle table photos)
-- SELECT: Tous les utilisateurs authentifiés
DROP POLICY IF EXISTS "member_photos_select_all" ON member_photos;
CREATE POLICY "member_photos_select_all"
    ON member_photos FOR SELECT
    TO authenticated
    USING (true);

-- INSERT/UPDATE: Admin, pasteur, berger
DROP POLICY IF EXISTS "member_photos_modify_berger" ON member_photos;
CREATE POLICY "member_photos_modify_berger"
    ON member_photos FOR ALL
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM user_roles ur
            JOIN roles r ON ur.role_id = r.id
            WHERE ur.user_id = auth.uid()
            AND r.nom IN ('admin', 'pasteur', 'berger')
            AND ur.is_active = true
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM user_roles ur
            JOIN roles r ON ur.role_id = r.id
            WHERE ur.user_id = auth.uid()
            AND r.nom IN ('admin', 'pasteur', 'berger')
            AND ur.is_active = true
        )
    );

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ ÉTAPE 6: VÉRIFICATION FINALE POST-DÉPLOIEMENT                                │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- Vue récapitulative de la sécurité
CREATE OR REPLACE VIEW security_audit_summary AS
SELECT 
    t.tablename,
    t.rowsecurity as rls_enabled,
    COUNT(p.policyname) as policy_count,
    CASE 
        WHEN NOT t.rowsecurity THEN '❌ RLS DÉSACTIVÉ'
        WHEN COUNT(p.policyname) = 0 THEN '⚠️ RLS ACTIVÉ MAIS SANS POLICIES'
        WHEN COUNT(p.policyname) < 2 THEN '⚠️ PEU DE POLICIES (vérifier)'
        ELSE '✅ SÉCURISÉ'
    END as security_status
FROM pg_tables t
LEFT JOIN pg_policies p ON t.tablename = p.tablename AND p.schemaname = t.schemaname
WHERE t.schemaname = 'public'
AND t.tablename NOT LIKE 'pg_%'
AND t.tablename NOT LIKE '_%'
GROUP BY t.tablename, t.rowsecurity
ORDER BY 
    CASE 
        WHEN NOT t.rowsecurity THEN 1
        WHEN COUNT(p.policyname) = 0 THEN 2
        ELSE 3
    END,
    t.tablename;

-- Afficher le résumé
SELECT * FROM security_audit_summary;

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ RAPPORT FINAL                                                                │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- Compteurs pour le rapport
SELECT 
    'RAPPORT DE SÉCURITÉ RLS' as section,
    '' as detail
UNION ALL
SELECT 
    'Tables totales',
    COUNT(*)::text
FROM pg_tables WHERE schemaname = 'public' AND tablename NOT LIKE 'pg_%'
UNION ALL
SELECT 
    'Tables avec RLS activé',
    COUNT(*)::text
FROM pg_tables WHERE schemaname = 'public' AND rowsecurity = true
UNION ALL
SELECT 
    'Tables SANS RLS (DANGER)',
    COUNT(*)::text
FROM pg_tables WHERE schemaname = 'public' AND rowsecurity = false AND tablename NOT LIKE 'pg_%'
UNION ALL
SELECT 
    'Policies totales',
    COUNT(*)::text
FROM pg_policies WHERE schemaname = 'public';

-- ═══════════════════════════════════════════════════════════════════════════════
-- CHECKLIST DE VALIDATION (À COCHER MANUELLEMENT)
-- ═══════════════════════════════════════════════════════════════════════════════

/*
□ 1. Toutes les tables ont RLS activé
□ 2. Chaque table a au moins une policy SELECT
□ 3. Les tables sensibles (finance, users) ont des policies restrictives
□ 4. Les policies utilisent auth.uid() correctement
□ 5. Aucune policy ne permet l'accès anonyme (TO anon) sur des données sensibles
□ 6. Les fonctions SECURITY DEFINER sont auditées
□ 7. Les triggers n'exposent pas de données sensibles
□ 8. La réplication realtime respecte les policies RLS

VALIDATION FINALE: □ APPROUVÉ  □ REJETÉ
*/
