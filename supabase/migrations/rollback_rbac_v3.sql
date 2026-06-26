-- ============================================================
-- ROLLBACK PLAN - RBAC V3 CORRECTIONS
-- ============================================================
-- À exécuter UNIQUEMENT si problème critique en production

-- 1. Sauvegarder état actuel
CREATE TABLE IF NOT EXISTS rollback_backup_policies AS
SELECT * FROM pg_policies WHERE policyname LIKE 'rbac_v3_%';

-- 2. Supprimer policies RBAC v3
DROP POLICY IF EXISTS "rbac_v3_members_select" ON members;
DROP POLICY IF EXISTS "rbac_v3_members_insert" ON members;
DROP POLICY IF EXISTS "rbac_v3_members_update" ON members;
DROP POLICY IF EXISTS "rbac_v3_members_delete" ON members;

DROP POLICY IF EXISTS "rbac_v3_transactions_select" ON transactions;
DROP POLICY IF EXISTS "rbac_v3_transactions_insert" ON transactions;
DROP POLICY IF EXISTS "rbac_v3_transactions_update" ON transactions;
DROP POLICY IF EXISTS "rbac_v3_transactions_delete" ON transactions;

DROP POLICY IF EXISTS "rbac_v3_events_select" ON events;
DROP POLICY IF EXISTS "rbac_v3_events_insert" ON events;
DROP POLICY IF EXISTS "rbac_v3_events_update" ON events;
DROP POLICY IF EXISTS "rbac_v3_events_delete" ON events;

DROP POLICY IF EXISTS "rbac_v3_groups_select" ON groups;
DROP POLICY IF EXISTS "rbac_v3_groups_insert" ON groups;
DROP POLICY IF EXISTS "rbac_v3_groups_update" ON groups;
DROP POLICY IF EXISTS "rbac_v3_groups_delete" ON groups;

DROP POLICY IF EXISTS "rbac_v3_profiles_select" ON profiles;
DROP POLICY IF EXISTS "rbac_v3_profiles_update" ON profiles;

-- 3. Restaurer policies legacy (TEMPORAIRE - à adapter selon besoin)
CREATE POLICY "temp_members_select" ON members
FOR SELECT USING (true); -- ATTENTION: Accès total temporaire

CREATE POLICY "temp_transactions_select" ON transactions
FOR SELECT USING (true);

CREATE POLICY "temp_events_select" ON events
FOR SELECT USING (true);

CREATE POLICY "temp_groups_select" ON groups
FOR SELECT USING (true);

CREATE POLICY "temp_profiles_select" ON profiles
FOR SELECT USING (id = auth.uid());

-- 4. Désactiver fonctions RLS (ne pas supprimer pour éviter erreurs)
-- Les fonctions restent mais ne sont plus utilisées

-- 5. Notification
DO $$
BEGIN
  RAISE NOTICE '⚠️ ROLLBACK EFFECTUÉ';
  RAISE NOTICE 'Policies RBAC v3 supprimées';
  RAISE NOTICE 'Policies temporaires activées (ACCÈS TOTAL)';
  RAISE NOTICE 'ACTION REQUISE: Restaurer policies sécurisées rapidement';
END $$;
