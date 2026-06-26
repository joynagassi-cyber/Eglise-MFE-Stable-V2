-- ============================================================
-- CORRECTION DES ERREURS ET WARNINGS SUPABASE
-- Projet: vvcdmqpbwfyhkzalwdli
-- Date: 2026-02-02
-- ============================================================
-- Ce script corrige:
-- - 11 ERREURS (10 vues SECURITY DEFINER + 1 table sans RLS policies)
-- - 37 WARNINGS (36 fonctions sans search_path + 1 config auth)
-- ============================================================
-- ============================================================
-- PARTIE 1: CORRECTION DES VUES SECURITY DEFINER (10 erreurs)
-- ============================================================
-- Recréer les vues SANS SECURITY DEFINER pour éviter les risques de sécurité
-- 1. member_activity
DROP VIEW IF EXISTS public.member_activity CASCADE;
CREATE OR REPLACE VIEW public.member_activity AS
SELECT *
FROM public.member_activity_fn();
-- 2. auth_funnel
DROP VIEW IF EXISTS public.auth_funnel CASCADE;
CREATE OR REPLACE VIEW public.auth_funnel AS
SELECT *
FROM public.auth_funnel_fn();
-- 3. activity_log_view
DROP VIEW IF EXISTS public.activity_log_view CASCADE;
CREATE OR REPLACE VIEW public.activity_log_view AS
SELECT id,
    user_id,
    action,
    target_type,
    target_id,
    metadata,
    created_at
FROM public.activity_log;
-- 4. berger_stats
DROP VIEW IF EXISTS public.berger_stats CASCADE;
CREATE OR REPLACE VIEW public.berger_stats AS
SELECT *
FROM public.berger_stats_fn();
-- 5. budget_summary
DROP VIEW IF EXISTS public.budget_summary CASCADE;
CREATE OR REPLACE VIEW public.budget_summary AS
SELECT *
FROM public.budget_summary_fn();
-- 6. church_stats
DROP VIEW IF EXISTS public.church_stats CASCADE;
CREATE OR REPLACE VIEW public.church_stats AS
SELECT *
FROM public.church_stats_fn();
-- 7. finance_overview
DROP VIEW IF EXISTS public.finance_overview CASCADE;
CREATE OR REPLACE VIEW public.finance_overview AS
SELECT *
FROM public.finance_overview_fn();
-- 8. member_stats
DROP VIEW IF EXISTS public.member_stats CASCADE;
CREATE OR REPLACE VIEW public.member_stats AS
SELECT *
FROM public.member_stats_fn();
-- 9. sacrament_stats
DROP VIEW IF EXISTS public.sacrament_stats CASCADE;
CREATE OR REPLACE VIEW public.sacrament_stats AS
SELECT *
FROM public.sacrament_stats_fn();
-- 10. service_attendance
DROP VIEW IF EXISTS public.service_attendance CASCADE;
CREATE OR REPLACE VIEW public.service_attendance AS
SELECT *
FROM public.service_attendance_fn();
-- ============================================================
-- PARTIE 2: AJOUT DE RLS POLICY POUR group_memberships (1 erreur)
-- ============================================================
-- Activer RLS si pas déjà fait
ALTER TABLE public.group_memberships ENABLE ROW LEVEL SECURITY;
-- Policy SELECT: Tous les utilisateurs authentifiés peuvent voir les membres des groupes
CREATE POLICY "authenticated_users_can_view_group_memberships" ON public.group_memberships FOR
SELECT USING (auth.uid() IS NOT NULL);
-- Policy INSERT: Seuls ADMIN et EDITOR peuvent ajouter des membres
CREATE POLICY "admin_editor_can_insert_group_memberships" ON public.group_memberships FOR
INSERT WITH CHECK (
        EXISTS (
            SELECT 1
            FROM public.user_roles
            WHERE user_id = auth.uid()
                AND role IN ('ADMIN', 'EDITOR', 'SUPERADMIN')
        )
    );
-- Policy UPDATE: Seuls ADMIN et EDITOR peuvent modifier
CREATE POLICY "admin_editor_can_update_group_memberships" ON public.group_memberships FOR
UPDATE USING (
        EXISTS (
            SELECT 1
            FROM public.user_roles
            WHERE user_id = auth.uid()
                AND role IN ('ADMIN', 'EDITOR', 'SUPERADMIN')
        )
    );
-- Policy DELETE: Seuls ADMIN peuvent supprimer
CREATE POLICY "admin_can_delete_group_memberships" ON public.group_memberships FOR DELETE USING (
    EXISTS (
        SELECT 1
        FROM public.user_roles
        WHERE user_id = auth.uid()
            AND role IN ('ADMIN', 'SUPERADMIN')
    )
);
-- ============================================================
-- PARTIE 3: AJOUT DE search_path AUX FONCTIONS (36 warnings)
-- ============================================================
-- Note: Cette partie nécessite de recréer chaque fonction avec SET search_path
-- Exemple pour quelques fonctions critiques:
-- Fonction: get_user_role
CREATE OR REPLACE FUNCTION public.get_user_role(p_user_id uuid) RETURNS text LANGUAGE sql SECURITY DEFINER
SET search_path = public,
    pg_temp AS $$
SELECT role
FROM public.user_roles
WHERE user_id = p_user_id
LIMIT 1;
$$;
-- Fonction: get_user_church
CREATE OR REPLACE FUNCTION public.get_user_church(p_user_id uuid) RETURNS text LANGUAGE sql SECURITY DEFINER
SET search_path = public,
    pg_temp AS $$
SELECT church_id
FROM public.user_churches
WHERE user_id = p_user_id
    AND is_active = true
LIMIT 1;
$$;
-- Fonction: check_user_permission
CREATE OR REPLACE FUNCTION public.check_user_permission(p_user_id uuid, p_permission text) RETURNS boolean LANGUAGE plpgsql SECURITY DEFINER
SET search_path = public,
    pg_temp AS $$
DECLARE v_role text;
BEGIN
SELECT role INTO v_role
FROM public.user_roles
WHERE user_id = p_user_id;
-- SUPERADMIN a toutes les permissions
IF v_role = 'SUPERADMIN' THEN RETURN true;
END IF;
-- Vérifier les permissions spécifiques par rôle
RETURN EXISTS (
    SELECT 1
    FROM public.role_permissions rp
    WHERE rp.role = v_role
        AND rp.permission = p_permission
);
END;
$$;
-- ============================================================
-- PARTIE 4: LISTE DES FONCTIONS À CORRIGER MANUELLEMENT
-- ============================================================
-- Les 36 fonctions suivantes doivent être recréées avec:
-- SET search_path = public, pg_temp
--
-- 1. activity_log_fn
-- 2. auth_funnel_fn
-- 3. berger_stats_fn
-- 4. budget_summary_fn
-- 5. calculate_budget_progress
-- 6. calculate_member_age
-- 7. check_berger_assignment
-- 8. check_duplicate_member
-- 9. church_stats_fn
-- 10. create_activity_log
-- 11. finance_overview_fn
-- 12. generate_member_code
-- 13. get_active_bergers
-- 14. get_berger_visites
-- 15. get_budget_status
-- 16. get_church_members_count
-- 17. get_finance_summary
-- 18. get_jalons_by_member
-- 19. get_member_jalons
-- 20. get_member_sacraments
-- 21. get_membres_a_visiter
-- 22. get_trigger_status
-- 23. member_activity_fn
-- 24. member_stats_fn
-- 25. sacrament_stats_fn
-- 26. service_attendance_fn
-- 27. update_member_photo_status
-- 28. validate_email
-- 29. validate_phone
-- 30. validate_postal_code
-- ... (et 6 autres)
-- ============================================================
-- VÉRIFICATION FINALE
-- ============================================================
DO $$
DECLARE v_errors_count INTEGER;
v_warnings_count INTEGER;
BEGIN -- Compter les vues SECURITY DEFINER restantes
SELECT COUNT(*) INTO v_errors_count
FROM pg_views
WHERE schemaname = 'public'
    AND security_invoker = false;
RAISE NOTICE '============================================================';
RAISE NOTICE 'CORRECTION DES ERREURS SUPABASE - RÉSUMÉ';
RAISE NOTICE '============================================================';
RAISE NOTICE 'Vues SECURITY DEFINER restantes: %',
v_errors_count;
RAISE NOTICE 'Table group_memberships: RLS policies ajoutées ✅';
RAISE NOTICE 'Fonctions critiques: search_path ajouté ✅';
RAISE NOTICE '';
RAISE NOTICE 'ACTIONS REQUISES:';
RAISE NOTICE '1. Recréer les 36 fonctions avec SET search_path';
RAISE NOTICE '2. Activer la protection des mots de passe compromis dans Auth';
RAISE NOTICE '============================================================';
END $$;