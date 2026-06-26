-- ============================================================
-- MIGRATION: Add Missing Profile RLS Policies
-- FILE: supabase/migrations/20260407_add_missing_profile_rls.sql
-- DATE: 2026-04-07
-- DESCRIPTION: Ajout des politiques INSERT et DELETE manquantes
--              sur la table profiles pour couvrir toutes les opérations.
--
-- CONTEXT:
--   Les politiques SELECT et UPDATE existaient déjà (rbac_v3_profiles_*).
--   Sans INSERT/DELETE, un utilisateur avec credentials volés pouvait :
--   - Créer un profil avec role_level='superadmin' pour une autre église
--   - Supprimer des profils d'autres utilisateurs
--   OWASP A01:2021 - Broken Access Control
-- ============================================================

-- ============================================================
-- 1. INSERT Policy
--    Un utilisateur ne peut créer que son propre profil (signup).
--    Un admin peut créer un profil dans son église.
-- ============================================================
DROP POLICY IF EXISTS "rbac_v3_profiles_insert" ON profiles;
CREATE POLICY "rbac_v3_profiles_insert" ON profiles
  FOR INSERT
  TO authenticated
  WITH CHECK (
    -- Cas 1 : utilisateur crée son propre profil (flux signup normal)
    id = auth.uid()
    OR
    -- Cas 2 : admin crée un profil dans son église
    (
      (SELECT role_level FROM profiles WHERE id = auth.uid()) IN ('admin', 'superadmin')
      AND church_id = (SELECT church_id FROM profiles WHERE id = auth.uid())
    )
  );

-- ============================================================
-- 2. DELETE Policy
--    Seul le superadmin peut supprimer des profils.
--    Protège contre la suppression accidentelle ou malveillante.
-- ============================================================
DROP POLICY IF EXISTS "rbac_v3_profiles_delete" ON profiles;
CREATE POLICY "rbac_v3_profiles_delete" ON profiles
  FOR DELETE
  TO authenticated
  USING (
    (SELECT role_level FROM profiles WHERE id = auth.uid()) = 'superadmin'
  );

-- ============================================================
-- 3. Trigger updated_at (idempotent)
-- ============================================================
ALTER TABLE profiles
  ALTER COLUMN created_at SET DEFAULT NOW();

-- S'assurer que la fonction update_updated_at_column existe
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_profiles_updated_at ON profiles;
CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- 4. Vérification post-migration (à exécuter en console Supabase)
-- ============================================================
-- SELECT policyname, cmd
-- FROM pg_policies
-- WHERE tablename = 'profiles'
-- ORDER BY cmd;
--
-- Résultat attendu :
--   rbac_v3_profiles_select   | SELECT
--   rbac_v3_profiles_insert   | INSERT   ← NOUVEAU
--   rbac_v3_profiles_update   | UPDATE
--   rbac_v3_profiles_delete   | DELETE   ← NOUVEAU
--
-- Test RLS INSERT (doit ÉCHOUER) :
-- SET LOCAL role = authenticated;
-- SET LOCAL "request.jwt.claims" TO '{"sub": "fake-uuid"}';
-- INSERT INTO profiles (id, church_id, role_level)
-- VALUES ('00000000-0000-0000-0000-000000000000', 'any-church', 'superadmin');
-- → ERROR: new row violates row-level security policy
