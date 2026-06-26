-- ============================================================
-- FIX RLS POLICIES POUR RBAC V3
-- Migration 010 - CRITIQUE
-- ============================================================

-- 1. Supprimer anciennes fonctions obsolètes
DROP FUNCTION IF EXISTS auth.user_role() CASCADE;
DROP FUNCTION IF EXISTS auth.user_church() CASCADE;

-- 2. Créer nouvelles fonctions RBAC v3
CREATE OR REPLACE FUNCTION auth.user_role_code() RETURNS TEXT AS $$
SELECT r.code 
FROM user_roles ur
JOIN roles r ON r.id = ur.role_id
WHERE ur.user_id = auth.uid()
AND ur.is_active = true
ORDER BY r.priority_level ASC
LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION auth.user_group_code() RETURNS TEXT AS $$
SELECT g.code
FROM user_roles ur
JOIN groups g ON g.id = ur.group_id
WHERE ur.user_id = auth.uid()
AND ur.is_active = true
LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION auth.is_super_admin() RETURNS BOOLEAN AS $$
SELECT EXISTS (
  SELECT 1 FROM user_roles ur
  JOIN roles r ON r.id = ur.role_id
  WHERE ur.user_id = auth.uid()
  AND r.is_super = true
  AND ur.is_active = true
);
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION auth.has_permission(
  p_resource TEXT,
  p_action TEXT
) RETURNS BOOLEAN AS $$
SELECT EXISTS (
  SELECT 1 FROM user_roles ur
  JOIN role_permissions rp ON rp.role_id = ur.role_id
  JOIN permissions p ON p.id = rp.permission_id
  WHERE ur.user_id = auth.uid()
  AND p.resource = p_resource
  AND p.action = p_action
  AND ur.is_active = true
);
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- 3. Recréer policies critiques
DROP POLICY IF EXISTS "Users can view members of their church" ON eglise_membres;
CREATE POLICY "rbac_v3_members_select" ON eglise_membres
FOR SELECT USING (
  auth.is_super_admin() OR auth.has_permission('members', 'read')
);

DROP POLICY IF EXISTS "ADMIN and EDITOR can create members" ON eglise_membres;
CREATE POLICY "rbac_v3_members_insert" ON eglise_membres
FOR INSERT WITH CHECK (
  auth.is_super_admin() OR auth.has_permission('members', 'write')
);

DROP POLICY IF EXISTS "ADMIN and EDITOR can update members" ON eglise_membres;
CREATE POLICY "rbac_v3_members_update" ON eglise_membres
FOR UPDATE USING (
  auth.is_super_admin() OR auth.has_permission('members', 'write')
);

DROP POLICY IF EXISTS "Only ADMIN can delete members" ON eglise_membres;
CREATE POLICY "rbac_v3_members_delete" ON eglise_membres
FOR DELETE USING (
  auth.is_super_admin() OR auth.has_permission('members', 'delete')
);

-- 4. Transactions
DROP POLICY IF EXISTS "Users can view transactions" ON transactions;
CREATE POLICY "rbac_v3_transactions_select" ON transactions
FOR SELECT USING (
  auth.is_super_admin() OR auth.has_permission('finance_transaction', 'read')
);

DROP POLICY IF EXISTS "ADMIN and EDITOR can create transactions" ON transactions;
CREATE POLICY "rbac_v3_transactions_insert" ON transactions
FOR INSERT WITH CHECK (
  auth.is_super_admin() OR auth.has_permission('finance_transaction', 'write')
);

DROP POLICY IF EXISTS "Users can update own transactions or ADMIN all" ON transactions;
CREATE POLICY "rbac_v3_transactions_update" ON transactions
FOR UPDATE USING (
  auth.is_super_admin() OR auth.has_permission('finance_transaction', 'write')
);

DROP POLICY IF EXISTS "Only ADMIN can delete transactions" ON transactions;
CREATE POLICY "rbac_v3_transactions_delete" ON transactions
FOR DELETE USING (
  auth.is_super_admin() OR auth.has_permission('finance_transaction', 'delete')
);

-- 5. Events
DROP POLICY IF EXISTS "Users can view events" ON events;
CREATE POLICY "rbac_v3_events_select" ON events
FOR SELECT USING (
  auth.is_super_admin() OR auth.has_permission('events', 'read')
);

DROP POLICY IF EXISTS "ADMIN and EDITOR can manage events" ON events;
CREATE POLICY "rbac_v3_events_insert" ON events
FOR INSERT WITH CHECK (
  auth.is_super_admin() OR auth.has_permission('events', 'write')
);

CREATE POLICY "rbac_v3_events_update" ON events
FOR UPDATE USING (
  auth.is_super_admin() OR auth.has_permission('events', 'write')
);

CREATE POLICY "rbac_v3_events_delete" ON events
FOR DELETE USING (
  auth.is_super_admin() OR auth.has_permission('events', 'delete')
);

-- 6. Groups
DROP POLICY IF EXISTS "Users can view groups of their church" ON groups;
CREATE POLICY "rbac_v3_groups_select" ON groups
FOR SELECT USING (
  auth.is_super_admin() OR auth.has_permission('groups', 'read')
);

DROP POLICY IF EXISTS "ADMIN and EDITOR can manage groups" ON groups;
CREATE POLICY "rbac_v3_groups_insert" ON groups
FOR INSERT WITH CHECK (
  auth.is_super_admin() OR auth.has_permission('groups', 'write')
);

CREATE POLICY "rbac_v3_groups_update" ON groups
FOR UPDATE USING (
  auth.is_super_admin() OR auth.has_permission('groups', 'write')
);

CREATE POLICY "rbac_v3_groups_delete" ON groups
FOR DELETE USING (
  auth.is_super_admin() OR auth.has_permission('groups', 'delete')
);

-- 7. Profiles (lecture seule pour soi-même)
DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
CREATE POLICY "rbac_v3_profiles_select" ON profiles
FOR SELECT USING (
  id = auth.uid() OR auth.is_super_admin()
);

DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
CREATE POLICY "rbac_v3_profiles_update" ON profiles
FOR UPDATE USING (
  id = auth.uid()
);

-- Validation
DO $$
BEGIN
  RAISE NOTICE '✅ RLS Policies RBAC v3 installées avec succès';
  RAISE NOTICE 'Fonctions créées: user_role_code, user_group_code, is_super_admin, has_permission';
  RAISE NOTICE 'Tables mises à jour: eglise_membres, transactions, events, groups, profiles';
END $$;
