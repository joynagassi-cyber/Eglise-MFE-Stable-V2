-- ✅ P0-SEC-03: Audit et Correction RLS Policies
-- Exécuter sur Supabase SQL Editor

-- 1. Vérifier tables sans RLS
SELECT schemaname, tablename 
FROM pg_tables 
WHERE schemaname = 'public' 
  AND tablename NOT IN (
    SELECT tablename FROM pg_policies WHERE schemaname = 'public'
  )
  AND rowsecurity = false;

-- 2. Activer RLS sur TOUTES les tables
DO $$
DECLARE
  tbl RECORD;
BEGIN
  FOR tbl IN 
    SELECT tablename FROM pg_tables WHERE schemaname = 'public'
  LOOP
    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', tbl.tablename);
  END LOOP;
END $$;

-- 3. Policies Standard Multi-Tenant (church_id)
CREATE OR REPLACE FUNCTION create_church_rls_policies(table_name TEXT)
RETURNS VOID AS $$
BEGIN
  -- SELECT: Voir seulement sa church
  EXECUTE format('
    CREATE POLICY %I_select ON public.%I
    FOR SELECT USING (
      church_id IN (
        SELECT church_id FROM public.members 
        WHERE user_id = auth.uid()
      )
    )', table_name || '_select', table_name);
  
  -- INSERT: Insérer seulement dans sa church
  EXECUTE format('
    CREATE POLICY %I_insert ON public.%I
    FOR INSERT WITH CHECK (
      church_id IN (
        SELECT church_id FROM public.members 
        WHERE user_id = auth.uid()
      )
    )', table_name || '_insert', table_name);
  
  -- UPDATE: Modifier seulement sa church
  EXECUTE format('
    CREATE POLICY %I_update ON public.%I
    FOR UPDATE USING (
      church_id IN (
        SELECT church_id FROM public.members 
        WHERE user_id = auth.uid()
      )
    )', table_name || '_update', table_name);
  
  -- DELETE: Supprimer seulement sa church
  EXECUTE format('
    CREATE POLICY %I_delete ON public.%I
    FOR DELETE USING (
      church_id IN (
        SELECT church_id FROM public.members 
        WHERE user_id = auth.uid()
      )
    )', table_name || '_delete', table_name);
END;
$$ LANGUAGE plpgsql;

-- 4. Appliquer aux tables critiques
SELECT create_church_rls_policies('members');
SELECT create_church_rls_policies('transactions');
SELECT create_church_rls_policies('events');
SELECT create_church_rls_policies('groups');
SELECT create_church_rls_policies('donations');
SELECT create_church_rls_policies('sacraments');
SELECT create_church_rls_policies('budgets');
SELECT create_church_rls_policies('announcements');

-- 5. Policy spéciale pour role_secret_codes (lecture seule)
CREATE POLICY role_codes_select ON public.role_secret_codes
FOR SELECT USING (true);

CREATE POLICY role_codes_update ON public.role_secret_codes
FOR UPDATE USING (false); -- Aucun update direct

-- 6. Vérification finale
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd
FROM pg_policies 
WHERE schemaname = 'public'
ORDER BY tablename, cmd;
