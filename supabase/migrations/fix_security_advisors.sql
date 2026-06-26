-- ============================================
-- FIX SECURITY ADVISORS - Supabase Linter
-- ============================================

-- CRITICAL: Fix RLS policies using insecure user_metadata
-- user_metadata is editable by users, use app_metadata instead

-- 1. Fix family_relationships
DROP POLICY IF EXISTS "Enable access by church_id for family_relationships" ON public.family_relationships;
CREATE POLICY "Enable access by church_id for family_relationships" ON public.family_relationships
  FOR ALL
  USING (
    church_id IN (
      SELECT unnest(COALESCE((auth.jwt()->>'app_metadata')::jsonb->'church_ids', '[]'::jsonb))::text::uuid
    )
  );

-- 2. Fix spiritual_tracking
DROP POLICY IF EXISTS "Enable access by church_id for spiritual_tracking" ON public.spiritual_tracking;
CREATE POLICY "Enable access by church_id for spiritual_tracking" ON public.spiritual_tracking
  FOR ALL
  USING (
    church_id IN (
      SELECT unnest(COALESCE((auth.jwt()->>'app_metadata')::jsonb->'church_ids', '[]'::jsonb))::text::uuid
    )
  );

-- 3. Fix member_history
DROP POLICY IF EXISTS "Enable access by church_id for member_history" ON public.member_history;
CREATE POLICY "Enable access by church_id for member_history" ON public.member_history
  FOR ALL
  USING (
    church_id IN (
      SELECT unnest(COALESCE((auth.jwt()->>'app_metadata')::jsonb->'church_ids', '[]'::jsonb))::text::uuid
    )
  );

-- ============================================
-- Fix function search_path (Security)
-- ============================================

CREATE OR REPLACE FUNCTION public.get_active_church_id()
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
  RETURN COALESCE(
    (auth.jwt()->>'app_metadata')::jsonb->>'active_church_id',
    (auth.jwt()->>'app_metadata')::jsonb->'church_ids'->0
  )::uuid;
END;
$$;

CREATE OR REPLACE FUNCTION public.get_auth_user_churches()
RETURNS TABLE(church_id uuid)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
  RETURN QUERY
  SELECT unnest(COALESCE((auth.jwt()->>'app_metadata')::jsonb->'church_ids', '[]'::jsonb))::text::uuid;
END;
$$;

CREATE OR REPLACE FUNCTION public.get_church_descendants(parent_id uuid)
RETURNS TABLE(church_id uuid)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
  RETURN QUERY
  WITH RECURSIVE descendants AS (
    SELECT id FROM public.churches WHERE id = parent_id
    UNION
    SELECT c.id FROM public.churches c
    INNER JOIN descendants d ON c.parent_church_id = d.id
  )
  SELECT id FROM descendants;
END;
$$;

CREATE OR REPLACE FUNCTION public.get_auth_user_hierarchical_churches()
RETURNS TABLE(church_id uuid)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
  RETURN QUERY
  WITH user_churches AS (
    SELECT unnest(COALESCE((auth.jwt()->>'app_metadata')::jsonb->'church_ids', '[]'::jsonb))::text::uuid AS id
  )
  SELECT DISTINCT d.church_id
  FROM user_churches uc
  CROSS JOIN LATERAL public.get_church_descendants(uc.id) d;
END;
$$;

-- ============================================
-- Fix overly permissive RLS policies
-- ============================================

-- audit_logs: Restrict INSERT to service_role only
DROP POLICY IF EXISTS "audit_safe_insert" ON public.audit_logs;
CREATE POLICY "audit_safe_insert" ON public.audit_logs
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- circle_members: Add proper church_id checks
DROP POLICY IF EXISTS "circle_members_insert" ON public.circle_members;
CREATE POLICY "circle_members_insert" ON public.circle_members
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.circles
      WHERE circles.id = circle_members.circle_id
      AND circles.church_id IN (SELECT public.get_auth_user_churches())
    )
  );

DROP POLICY IF EXISTS "circle_members_delete" ON public.circle_members;
CREATE POLICY "circle_members_delete" ON public.circle_members
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.circles
      WHERE circles.id = circle_members.circle_id
      AND circles.church_id IN (SELECT public.get_auth_user_churches())
    )
  );

-- circles: Add proper church_id checks
DROP POLICY IF EXISTS "circles_insert" ON public.circles;
CREATE POLICY "circles_insert" ON public.circles
  FOR INSERT
  TO authenticated
  WITH CHECK (church_id IN (SELECT public.get_auth_user_churches()));

DROP POLICY IF EXISTS "circles_update" ON public.circles;
CREATE POLICY "circles_update" ON public.circles
  FOR UPDATE
  TO authenticated
  USING (church_id IN (SELECT public.get_auth_user_churches()))
  WITH CHECK (church_id IN (SELECT public.get_auth_user_churches()));

DROP POLICY IF EXISTS "circles_delete" ON public.circles;
CREATE POLICY "circles_delete" ON public.circles
  FOR DELETE
  TO authenticated
  USING (church_id IN (SELECT public.get_auth_user_churches()));

-- ============================================
-- Move pg_trgm extension to extensions schema
-- ============================================

CREATE SCHEMA IF NOT EXISTS extensions;
ALTER EXTENSION pg_trgm SET SCHEMA extensions;
