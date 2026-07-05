-- 20260704_create_notification_rpc.sql
-- 
-- RPC sécurisé pour créer des notifications depuis l'application Flutter
-- SECURITY DEFINER permet de bypasser les RLS et d'insérer pour n'importe quel user_id

-- ============================================================
-- 1. Création d'une notification unique
-- ============================================================
CREATE OR REPLACE FUNCTION public.create_notification(
  p_user_id UUID,
  p_title TEXT,
  p_message TEXT,
  p_type TEXT DEFAULT 'general',
  p_link_url TEXT DEFAULT NULL,
  p_payload JSONB DEFAULT '{}'::jsonb,
  p_priority TEXT DEFAULT 'NORMAL',
  p_church_id UUID DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_id UUID;
  v_result JSONB;
BEGIN
  -- Validation des paramètres obligatoires
  IF p_user_id IS NULL THEN
    RAISE EXCEPTION 'p_user_id is required';
  END IF;
  IF p_title IS NULL OR p_title = '' THEN
    RAISE EXCEPTION 'p_title is required';
  END IF;
  IF p_message IS NULL OR p_message = '' THEN
    RAISE EXCEPTION 'p_message is required';
  END IF;

  INSERT INTO public.notifications (
    user_id,
    title,
    message,
    type,
    link_url,
    payload,
    priority,
    church_id
  ) VALUES (
    p_user_id,
    p_title,
    p_message,
    p_type,
    p_link_url,
    p_payload,
    p_priority,
    p_church_id
  )
  RETURNING id INTO v_id;

  SELECT row_to_json(n.*)::jsonb INTO v_result
  FROM public.notifications n
  WHERE n.id = v_id;

  RETURN v_result;
END;
$$;

-- ============================================================
-- 2. Création de notifications pour tous les membres d'un groupe
-- ============================================================
CREATE OR REPLACE FUNCTION public.create_notifications_for_group(
  p_group_id UUID,
  p_title TEXT,
  p_message TEXT,
  p_type TEXT DEFAULT 'general',
  p_link_url TEXT DEFAULT NULL,
  p_payload JSONB DEFAULT '{}'::jsonb,
  p_priority TEXT DEFAULT 'NORMAL'
)
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_count INTEGER := 0;
  v_member RECORD;
BEGIN
  FOR v_member IN
    SELECT DISTINCT m.profile_id
    FROM public.group_memberships gm
    JOIN public.members m ON m.id = gm.member_id
    WHERE gm.group_id = p_group_id
      AND gm.status = 'active'
      AND m.profile_id IS NOT NULL
  LOOP
    PERFORM public.create_notification(
      v_member.profile_id,
      p_title,
      p_message,
      p_type,
      p_link_url,
      p_payload,
      p_priority
    );
    v_count := v_count + 1;
  END LOOP;

  RETURN v_count;
END;
$$;

-- ============================================================
-- 3. Création de notifications pour tous les administrateurs d'une église
-- ============================================================
CREATE OR REPLACE FUNCTION public.create_notifications_for_admins(
  p_church_id UUID,
  p_title TEXT,
  p_message TEXT,
  p_type TEXT DEFAULT 'general',
  p_link_url TEXT DEFAULT NULL,
  p_payload JSONB DEFAULT '{}'::jsonb,
  p_priority TEXT DEFAULT 'NORMAL'
)
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_count INTEGER := 0;
  v_admin RECORD;
BEGIN
  FOR v_admin IN
    SELECT DISTINCT ur.user_id
    FROM public.user_roles ur
    WHERE ur.church_id = p_church_id
      AND (ur.role IN ('admin_total', 'superadmin', 'staff', 'admin_staff', 'pasteur', 'secretaire', 'tresorier'))
  LOOP
    PERFORM public.create_notification(
      v_admin.user_id,
      p_title,
      p_message,
      p_type,
      p_link_url,
      p_payload,
      p_priority,
      p_church_id
    );
    v_count := v_count + 1;
  END LOOP;

  RETURN v_count;
END;
$$;

-- ============================================================
-- 4. Création de notifications pour tous les chefs de groupe d'une église
-- ============================================================
CREATE OR REPLACE FUNCTION public.create_notifications_for_group_leaders(
  p_church_id UUID,
  p_title TEXT,
  p_message TEXT,
  p_type TEXT DEFAULT 'general',
  p_link_url TEXT DEFAULT NULL,
  p_payload JSONB DEFAULT '{}'::jsonb,
  p_priority TEXT DEFAULT 'NORMAL'
)
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_count INTEGER := 0;
  v_leader RECORD;
BEGIN
  FOR v_leader IN
    SELECT DISTINCT ur.user_id
    FROM public.user_roles ur
    WHERE ur.church_id = p_church_id
      AND (ur.role IN ('chef_groupe', 'leader', 'co_chef_groupe', 'co_leader'))
  LOOP
    PERFORM public.create_notification(
      v_leader.user_id,
      p_title,
      p_message,
      p_type,
      p_link_url,
      p_payload,
      p_priority,
      p_church_id
    );
    v_count := v_count + 1;
  END LOOP;

  RETURN v_count;
END;
$$;

-- ============================================================
-- 5. Création de notifications pour tous les membres d'une église
-- ============================================================
CREATE OR REPLACE FUNCTION public.create_notifications_for_all_members(
  p_church_id UUID,
  p_title TEXT,
  p_message TEXT,
  p_type TEXT DEFAULT 'general',
  p_link_url TEXT DEFAULT NULL,
  p_payload JSONB DEFAULT '{}'::jsonb,
  p_priority TEXT DEFAULT 'NORMAL'
)
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_count INTEGER := 0;
  v_member RECORD;
BEGIN
  FOR v_member IN
    SELECT DISTINCT m.profile_id
    FROM public.members m
    WHERE m.church_id = p_church_id
      AND m.profile_id IS NOT NULL
  LOOP
    PERFORM public.create_notification(
      v_member.profile_id,
      p_title,
      p_message,
      p_type,
      p_link_url,
      p_payload,
      p_priority,
      p_church_id
    );
    v_count := v_count + 1;
  END LOOP;

  RETURN v_count;
END;
$$;

-- Accorder les permissions d'exécution aux utilisateurs authentifiés
GRANT EXECUTE ON FUNCTION public.create_notification TO authenticated;
GRANT EXECUTE ON FUNCTION public.create_notifications_for_group TO authenticated;
GRANT EXECUTE ON FUNCTION public.create_notifications_for_admins TO authenticated;
GRANT EXECUTE ON FUNCTION public.create_notifications_for_group_leaders TO authenticated;
GRANT EXECUTE ON FUNCTION public.create_notifications_for_all_members TO authenticated;
