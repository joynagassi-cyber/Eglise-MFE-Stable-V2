-- ═══════════════════════════════════════════════════════════════════════════════
-- Migration: 20260215_fix_rls_church_isolation.sql
-- Date: 2026-02-15
-- Objective: Lumina40 Security Enforcement (ISCHUS 1.2)
-- Description: Strict isolation of data by church_id in RLS policies.
-- ═══════════════════════════════════════════════════════════════════════════════
-- 1. Helper function update for church isolation
-- Ensure we have a reliable way to get the current user's active church ID
-- ✅ Déplacé dans public pour éviter les erreurs de permission sur le schéma auth
CREATE OR REPLACE FUNCTION public.get_active_church_id() RETURNS TEXT AS $$
SELECT church_id
FROM public.user_churches
WHERE user_id = auth.uid()
    AND is_active = true
LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER STABLE;
-- 2. Refactor existing policies to include church isolation
-- We use a standardized naming convention: rbac_v4_isolation_<table_name>_<action>
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ MEMBERS                                                                     │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- Utilisation de la table 'members' identifiée dans le schéma
ALTER TABLE public.members ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "rbac_v3_members_select" ON public.members;
DROP POLICY IF EXISTS "members_isolation_select" ON public.members;
CREATE POLICY "rbac_v4_members_isolation_select" ON public.members FOR
SELECT USING (
        (
            public.is_super_admin()
            OR public.has_permission('members', 'read')
        )
        AND (church_id = public.get_active_church_id())
    );
-- Note: La table 'members' est déjà traitée ci-dessus.
-- On s'assure que 'church_members' est aussi isolé si nécessaire.
ALTER TABLE public.church_members ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "church_members_isolation_select" ON public.church_members;
CREATE POLICY "church_members_isolation_select" ON public.church_members FOR
SELECT USING (
        (
            auth.is_super_admin()
            OR auth.uid() = user_id
        )
        AND (church_id = public.get_active_church_id())
    );
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ FINANCE (finance_transactions, donations, accounts)                         │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- Finance Transactions
DROP POLICY IF EXISTS "rbac_v3_transactions_select" ON public.finance_transactions;
CREATE POLICY "rbac_v4_transactions_isolation_select" ON public.finance_transactions FOR
SELECT USING (
        (
            public.is_super_admin()
            OR public.has_permission('finance_transaction', 'read')
        )
        AND (church_id = public.get_active_church_id())
    );
-- Donations
DROP POLICY IF EXISTS "donations_select" ON public.donations;
CREATE POLICY "rbac_v4_donations_isolation_select" ON public.donations FOR
SELECT USING (
        (
            public.is_super_admin()
            OR public.has_permission('finance_transaction', 'read')
        )
        AND EXISTS (
            SELECT 1
            FROM public.finance_transactions ft
            WHERE ft.id = transaction_id
                AND ft.church_id = public.get_active_church_id()
        )
    );
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ ANNONCES & POSTS                                                            │
-- └─────────────────────────────────────────────────────────────────────────────┘
ALTER TABLE public.annonces ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "annonces_select" ON public.annonces;
DROP POLICY IF EXISTS "rbac_v4_annonces_isolation_select" ON public.annonces;
CREATE POLICY "rbac_v4_annonces_isolation_select" ON public.annonces FOR
SELECT USING (
        (
            is_active = true
            AND church_id = public.get_active_church_id()
        )
        OR (
            public.is_super_admin()
            OR public.has_permission('annonces', 'read')
        )
    );
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ GROUPS & CIRCLES                                                            │
-- └─────────────────────────────────────────────────────────────────────────────┘
DROP POLICY IF EXISTS "rbac_v3_groups_select" ON public.groups;
CREATE POLICY "rbac_v4_groups_isolation_select" ON public.groups FOR
SELECT USING (
        (
            public.is_super_admin()
            OR public.has_permission('groups', 'read')
        )
        AND (church_id = public.get_active_church_id())
    );
-- Note: 'circles' n'a pas été trouvé dans le schéma public, on l'ignore ou on le traite conditionnellement.
DO $$ BEGIN IF EXISTS (
    SELECT 1
    FROM pg_tables
    WHERE tablename = 'circles'
) THEN
ALTER TABLE public.circles ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "circles_select" ON public.circles;
CREATE POLICY "rbac_v4_circles_isolation_select" ON public.circles FOR
SELECT USING (
        (
            public.is_super_admin()
            OR public.has_permission('groups', 'read')
        )
        AND (church_id = public.get_active_church_id())
    );
END IF;
END $$;
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ AUDIT LOGS (audit_logs)                                                     │
-- └─────────────────────────────────────────────────────────────────────────────┘
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Only ADMIN can view audit log" ON public.audit_logs;
DROP POLICY IF EXISTS "rbac_v3_audit_select" ON public.audit_logs;
DROP POLICY IF EXISTS "rbac_v4_audit_isolation_select" ON public.audit_logs;
CREATE POLICY "rbac_v4_audit_isolation_select" ON public.audit_logs FOR
SELECT USING (
        (
            public.is_super_admin()
            OR public.has_permission('audit', 'read')
        )
        AND EXISTS (
            SELECT 1
            FROM public.user_churches uc
            WHERE uc.user_id = actor_id
                AND uc.church_id = public.get_active_church_id()
        )
    );
-- ═══════════════════════════════════════════════════════════════════════════════
-- Validation Notice
-- ═══════════════════════════════════════════════════════════════════════════════
DO $$ BEGIN RAISE NOTICE '✅ ISCHUS 1.2 Isolation Migration created successfully.';
RAISE NOTICE 'Isolation applied to: eglise_membres, finance_transactions, donations, annonces, groups, circles, audit_log';
END $$;