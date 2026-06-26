-- ============================================================
-- MIGRATION: RLS Architecture V2 — Lumina
-- DATE: 2026-03-27
-- DESCRIPTION: Refonte complète des policies RLS avec:
--   - Isolation par church_id (UUID) au lieu de church_name (string)
--   - Filtrage multi-niveau: superadmin > admin > chef_groupe > membre
--   - Filtrage par group_id pour les chefs de groupe
-- ============================================================

-- ============================================================
-- PHASE 0 : DROP anciennes helper functions
-- ============================================================
DROP FUNCTION IF EXISTS auth.user_role() CASCADE;
DROP FUNCTION IF EXISTS auth.user_church() CASCADE;

-- ============================================================
-- PHASE 1 : HELPER FUNCTIONS
-- ============================================================

-- Retourne le church_id de l'utilisateur courant
CREATE OR REPLACE FUNCTION auth.get_church_id()
RETURNS UUID AS $$
  SELECT COALESCE(
    (auth.jwt() -> 'user_metadata' ->> 'church_id')::UUID,
    (auth.jwt() -> 'user_metadata' ->> 'active_church_id')::UUID
  );
$$ LANGUAGE sql STABLE SECURITY DEFINER;

-- Retourne le rôle de l'utilisateur courant
CREATE OR REPLACE FUNCTION auth.get_role()
RETURNS TEXT AS $$
  SELECT COALESCE(
    auth.jwt() -> 'user_metadata' ->> 'role',
    'member'
  );
$$ LANGUAGE sql STABLE SECURITY DEFINER;

-- Retourne le group_id de l'utilisateur courant (null pour superadmin)
CREATE OR REPLACE FUNCTION auth.get_group_id()
RETURNS UUID AS $$
  SELECT (auth.jwt() -> 'user_metadata' ->> 'group_id')::UUID;
$$ LANGUAGE sql STABLE SECURITY DEFINER;

-- Vérifie si l'utilisateur courant est superadmin
CREATE OR REPLACE FUNCTION auth.is_superadmin()
RETURNS BOOLEAN AS $$
  SELECT auth.get_role() = 'superadmin';
$$ LANGUAGE sql STABLE SECURITY DEFINER;

-- Vérifie si l'utilisateur courant est admin (superadmin inclus)
CREATE OR REPLACE FUNCTION auth.is_admin()
RETURNS BOOLEAN AS $$
  SELECT auth.get_role() IN ('superadmin', 'admin');
$$ LANGUAGE sql STABLE SECURITY DEFINER;

-- Vérifie si l'utilisateur est chef de groupe
CREATE OR REPLACE FUNCTION auth.is_group_leader()
RETURNS BOOLEAN AS $$
  SELECT auth.get_role() = 'group_leader';
$$ LANGUAGE sql STABLE SECURITY DEFINER;

-- Vérifie l'appartenance à une église
CREATE OR REPLACE FUNCTION auth.belongs_to_church(target_church_id UUID)
RETURNS BOOLEAN AS $$
  SELECT auth.is_superadmin() OR auth.get_church_id() = target_church_id;
$$ LANGUAGE sql STABLE SECURITY DEFINER;

-- Vérifie l'appartenance à un groupe
CREATE OR REPLACE FUNCTION auth.belongs_to_group(target_group_id UUID)
RETURNS BOOLEAN AS $$
  SELECT auth.is_superadmin()
      OR auth.is_admin()
      OR (auth.is_group_leader() AND auth.get_group_id() = target_group_id);
$$ LANGUAGE sql STABLE SECURITY DEFINER;


-- ============================================================
-- PHASE 2 : DROP anciennes policies (par table)
-- ============================================================
DO $$
DECLARE
  pol RECORD;
BEGIN
  FOR pol IN
    SELECT policyname, tablename
    FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename IN (
        'profiles', 'members', 'transactions', 'events',
        'announcements', 'groups', 'prayer_requests',
        'audit_logs', 'budgets', 'attendances'
      )
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', pol.policyname, pol.tablename);
  END LOOP;
END $$;


-- ============================================================
-- PHASE 3 : ENABLE RLS sur toutes les tables cibles
-- ============================================================
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE members ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE announcements ENABLE ROW LEVEL SECURITY;
ALTER TABLE groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE prayer_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE budgets ENABLE ROW LEVEL SECURITY;
ALTER TABLE attendances ENABLE ROW LEVEL SECURITY;


-- ============================================================
-- 1. PROFILES
-- ============================================================

-- Policy: Superadmin voit tous les profils, admin voit son église, membre voit le sien
CREATE POLICY "profiles_select" ON profiles
  FOR SELECT
  TO authenticated
  USING (
    auth.is_superadmin()
    OR (auth.get_church_id() = church_id)
    OR (id = auth.uid())
  );

-- Policy: Seul le système crée des profils (via trigger on auth.users)
-- Les admins peuvent créer des profils pour leur église
CREATE POLICY "profiles_insert" ON profiles
  FOR INSERT
  TO authenticated
  WITH CHECK (
    id = auth.uid()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
  );

-- Policy: Un utilisateur peut modifier son propre profil, admin modifie les profils de son église
CREATE POLICY "profiles_update" ON profiles
  FOR UPDATE
  TO authenticated
  USING (
    id = auth.uid()
    OR auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
  )
  WITH CHECK (
    id = auth.uid()
    OR auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
  );

-- Policy: Seul le superadmin peut supprimer des profils
CREATE POLICY "profiles_delete" ON profiles
  FOR DELETE
  TO authenticated
  USING (auth.is_superadmin());


-- ============================================================
-- 2. MEMBERS
-- ============================================================

-- Policy: Superadmin voit tout, admin voit son église, chef de groupe voit son groupe, membre voit soi-même
CREATE POLICY "members_select" ON members
  FOR SELECT
  TO authenticated
  USING (
    auth.is_superadmin()
    OR (church_id = auth.get_church_id() AND auth.is_admin())
    OR (church_id = auth.get_church_id() AND auth.is_group_leader() AND group_id = auth.get_group_id())
    OR (profile_id = auth.uid())
  );

-- Policy: Admin et chef de groupe peuvent ajouter des membres dans leur périmètre
CREATE POLICY "members_insert" ON members
  FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
    OR (auth.is_group_leader() AND church_id = auth.get_church_id() AND group_id = auth.get_group_id())
  );

-- Policy: Admin modifie tout son église, chef de groupe modifie son groupe
CREATE POLICY "members_update" ON members
  FOR UPDATE
  TO authenticated
  USING (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
    OR (auth.is_group_leader() AND church_id = auth.get_church_id() AND group_id = auth.get_group_id())
    OR (profile_id = auth.uid())
  )
  WITH CHECK (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
    OR (auth.is_group_leader() AND church_id = auth.get_church_id() AND group_id = auth.get_group_id())
    OR (profile_id = auth.uid())
  );

-- Policy: Seul admin+ peut supprimer des membres
CREATE POLICY "members_delete" ON members
  FOR DELETE
  TO authenticated
  USING (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
  );


-- ============================================================
-- 3. TRANSACTIONS
-- ============================================================

-- Policy: Superadmin voit tout, admin voit son église, chef de groupe voit son groupe, membre voit ses propres
CREATE POLICY "transactions_select" ON transactions
  FOR SELECT
  TO authenticated
  USING (
    auth.is_superadmin()
    OR (church_id = auth.get_church_id() AND auth.is_admin())
    OR (church_id = auth.get_church_id() AND auth.is_group_leader() AND group_id = auth.get_group_id())
    OR (submitted_by = auth.uid())
    OR (member_id IN (SELECT id FROM members WHERE profile_id = auth.uid()))
  );

-- Policy: Tout membre authentifié peut soumettre une transaction (dîme, offrande)
CREATE POLICY "transactions_insert" ON transactions
  FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.is_superadmin()
    OR (church_id = auth.get_church_id())
  );

-- Policy: Admin et chef de groupe peuvent modifier les transactions de leur périmètre
CREATE POLICY "transactions_update" ON transactions
  FOR UPDATE
  TO authenticated
  USING (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
    OR (auth.is_group_leader() AND church_id = auth.get_church_id() AND group_id = auth.get_group_id())
  )
  WITH CHECK (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
    OR (auth.is_group_leader() AND church_id = auth.get_church_id() AND group_id = auth.get_group_id())
  );

-- Policy: Seul admin+ peut supprimer des transactions
CREATE POLICY "transactions_delete" ON transactions
  FOR DELETE
  TO authenticated
  USING (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
  );


-- ============================================================
-- 4. EVENTS
-- ============================================================

-- Policy: Tous les membres de l'église voient les événements, superadmin voit tout
CREATE POLICY "events_select" ON events
  FOR SELECT
  TO authenticated
  USING (
    auth.is_superadmin()
    OR (church_id = auth.get_church_id())
  );

-- Policy: Admin et chef de groupe (pour son groupe) peuvent créer des événements
CREATE POLICY "events_insert" ON events
  FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
    OR (auth.is_group_leader() AND church_id = auth.get_church_id() AND group_id = auth.get_group_id())
  );

-- Policy: Admin et chef de groupe (pour son groupe) peuvent modifier
CREATE POLICY "events_update" ON events
  FOR UPDATE
  TO authenticated
  USING (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
    OR (auth.is_group_leader() AND church_id = auth.get_church_id() AND group_id = auth.get_group_id())
  )
  WITH CHECK (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
    OR (auth.is_group_leader() AND church_id = auth.get_church_id() AND group_id = auth.get_group_id())
  );

-- Policy: Admin et chef de groupe (pour son groupe) peuvent supprimer
CREATE POLICY "events_delete" ON events
  FOR DELETE
  TO authenticated
  USING (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
    OR (auth.is_group_leader() AND church_id = auth.get_church_id() AND group_id = auth.get_group_id())
  );


-- ============================================================
-- 5. ANNOUNCEMENTS
-- ============================================================

-- Policy: Annonces publiées visibles par l'église/groupe, superadmin voit tout
CREATE POLICY "announcements_select" ON announcements
  FOR SELECT
  TO authenticated
  USING (
    auth.is_superadmin()
    OR (
      church_id = auth.get_church_id()
      AND is_published = true
      AND (group_id IS NULL OR group_id = auth.get_group_id() OR auth.is_admin())
    )
    OR (author_id = auth.uid())
  );

-- Policy: Admin peut créer des annonces pour son église
CREATE POLICY "announcements_insert" ON announcements
  FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
  );

-- Policy: Admin peut modifier les annonces de son église
CREATE POLICY "announcements_update" ON announcements
  FOR UPDATE
  TO authenticated
  USING (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
    OR (author_id = auth.uid())
  )
  WITH CHECK (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
    OR (author_id = auth.uid())
  );

-- Policy: Admin peut supprimer les annonces de son église
CREATE POLICY "announcements_delete" ON announcements
  FOR DELETE
  TO authenticated
  USING (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
  );


-- ============================================================
-- 6. GROUPS
-- ============================================================

-- Policy: Tous les membres de l'église voient les groupes, superadmin voit tout
CREATE POLICY "groups_select" ON groups
  FOR SELECT
  TO authenticated
  USING (
    auth.is_superadmin()
    OR (church_id = auth.get_church_id())
  );

-- Policy: Admin peut créer des groupes
CREATE POLICY "groups_insert" ON groups
  FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
  );

-- Policy: Admin peut modifier tout, chef de groupe peut modifier SON groupe uniquement
CREATE POLICY "groups_update" ON groups
  FOR UPDATE
  TO authenticated
  USING (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
    OR (auth.is_group_leader() AND id = auth.get_group_id())
  )
  WITH CHECK (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
    OR (auth.is_group_leader() AND id = auth.get_group_id())
  );

-- Policy: Seul admin peut supprimer des groupes
CREATE POLICY "groups_delete" ON groups
  FOR DELETE
  TO authenticated
  USING (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
  );


-- ============================================================
-- 7. PRAYER_REQUESTS
-- ============================================================

-- Policy: Membres de l'église voient les requêtes, superadmin voit tout
CREATE POLICY "prayer_requests_select" ON prayer_requests
  FOR SELECT
  TO authenticated
  USING (
    auth.is_superadmin()
    OR (church_id = auth.get_church_id())
  );

-- Policy: Tout membre authentifié de l'église peut soumettre une requête de prière
CREATE POLICY "prayer_requests_insert" ON prayer_requests
  FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.is_superadmin()
    OR (church_id = auth.get_church_id())
  );

-- Policy: Admin peut modifier, propriétaire aussi
CREATE POLICY "prayer_requests_update" ON prayer_requests
  FOR UPDATE
  TO authenticated
  USING (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
    OR (submitter_id = auth.uid())
  )
  WITH CHECK (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
    OR (submitter_id = auth.uid())
  );

-- Policy: Admin peut supprimer, propriétaire aussi
CREATE POLICY "prayer_requests_delete" ON prayer_requests
  FOR DELETE
  TO authenticated
  USING (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
    OR (submitter_id = auth.uid())
  );


-- ============================================================
-- 8. AUDIT_LOGS
-- ============================================================

-- Policy: Seul le superadmin peut lire les logs d'audit
CREATE POLICY "audit_logs_select" ON audit_logs
  FOR SELECT
  TO authenticated
  USING (auth.is_superadmin());

-- Policy: Insertion via triggers uniquement (service_role), mais on autorise le système
CREATE POLICY "audit_logs_insert" ON audit_logs
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.is_superadmin() OR auth.is_admin());

-- Pas de UPDATE ni DELETE sur les audit logs (immuables)


-- ============================================================
-- 9. BUDGETS
-- ============================================================

-- Policy: Admin voit tous les budgets, chef de groupe voit le sien, superadmin voit tout
CREATE POLICY "budgets_select" ON budgets
  FOR SELECT
  TO authenticated
  USING (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
    OR (auth.is_group_leader() AND church_id = auth.get_church_id() AND group_id = auth.get_group_id())
  );

-- Policy: Admin peut créer des budgets
CREATE POLICY "budgets_insert" ON budgets
  FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
  );

-- Policy: Admin et chef de groupe (son budget) peuvent modifier
CREATE POLICY "budgets_update" ON budgets
  FOR UPDATE
  TO authenticated
  USING (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
    OR (auth.is_group_leader() AND church_id = auth.get_church_id() AND group_id = auth.get_group_id())
  )
  WITH CHECK (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
    OR (auth.is_group_leader() AND church_id = auth.get_church_id() AND group_id = auth.get_group_id())
  );

-- Policy: Seul admin peut supprimer des budgets
CREATE POLICY "budgets_delete" ON budgets
  FOR DELETE
  TO authenticated
  USING (
    auth.is_superadmin()
    OR (auth.is_admin() AND church_id = auth.get_church_id())
  );


-- ============================================================
-- 10. ATTENDANCES
-- ============================================================

-- Policy: Admin et chef de groupe voient les présences de leur périmètre, superadmin voit tout
CREATE POLICY "attendances_select" ON attendances
  FOR SELECT
  TO authenticated
  USING (
    auth.is_superadmin()
    OR EXISTS (
      SELECT 1 FROM events e
      WHERE e.id = attendances.event_id
        AND e.church_id = auth.get_church_id()
        AND (
          auth.is_admin()
          OR (auth.is_group_leader() AND e.group_id = auth.get_group_id())
          OR (attendances.member_id IN (SELECT m.id FROM members m WHERE m.profile_id = auth.uid()))
        )
    )
  );

-- Policy: Admin et chef de groupe peuvent enregistrer des présences
CREATE POLICY "attendances_insert" ON attendances
  FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.is_superadmin()
    OR EXISTS (
      SELECT 1 FROM events e
      WHERE e.id = event_id
        AND e.church_id = auth.get_church_id()
        AND (auth.is_admin() OR (auth.is_group_leader() AND e.group_id = auth.get_group_id()))
    )
  );

-- Policy: Admin et chef de groupe peuvent modifier les présences
CREATE POLICY "attendances_update" ON attendances
  FOR UPDATE
  TO authenticated
  USING (
    auth.is_superadmin()
    OR EXISTS (
      SELECT 1 FROM events e
      WHERE e.id = attendances.event_id
        AND e.church_id = auth.get_church_id()
        AND (auth.is_admin() OR (auth.is_group_leader() AND e.group_id = auth.get_group_id()))
    )
  )
  WITH CHECK (
    auth.is_superadmin()
    OR EXISTS (
      SELECT 1 FROM events e
      WHERE e.id = attendances.event_id
        AND e.church_id = auth.get_church_id()
        AND (auth.is_admin() OR (auth.is_group_leader() AND e.group_id = auth.get_group_id()))
    )
  );

-- Policy: Seul admin peut supprimer des présences
CREATE POLICY "attendances_delete" ON attendances
  FOR DELETE
  TO authenticated
  USING (
    auth.is_superadmin()
    OR EXISTS (
      SELECT 1 FROM events e
      WHERE e.id = attendances.event_id
        AND e.church_id = auth.get_church_id()
        AND auth.is_admin()
    )
  );


-- ============================================================
-- VÉRIFICATION FINALE
-- ============================================================
DO $$
DECLARE
  tables_count INTEGER;
  policies_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO tables_count
  FROM pg_tables
  WHERE schemaname = 'public'
    AND rowsecurity = true
    AND tablename IN (
      'profiles', 'members', 'transactions', 'events',
      'announcements', 'groups', 'prayer_requests',
      'audit_logs', 'budgets', 'attendances'
    );

  SELECT COUNT(*) INTO policies_count
  FROM pg_policies
  WHERE schemaname = 'public'
    AND tablename IN (
      'profiles', 'members', 'transactions', 'events',
      'announcements', 'groups', 'prayer_requests',
      'audit_logs', 'budgets', 'attendances'
    );

  RAISE NOTICE '';
  RAISE NOTICE '============================================================';
  RAISE NOTICE 'RLS Architecture V2 — INSTALLATION TERMINÉE';
  RAISE NOTICE '============================================================';
  RAISE NOTICE 'Tables avec RLS activé: %', tables_count;
  RAISE NOTICE 'Policies créées: %', policies_count;
  RAISE NOTICE '✅ Attendu: 10 tables, ~38 policies';
  RAISE NOTICE '============================================================';
END $$;
