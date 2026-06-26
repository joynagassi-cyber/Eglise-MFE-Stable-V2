CREATE OR REPLACE FUNCTION public.complete_member_onboarding_v2(
  p_profile_id uuid,
  p_gender text DEFAULT NULL::text,
  p_birth_date date DEFAULT NULL::date,
  p_primary_group_id uuid DEFAULT NULL::uuid,
  p_optional_group_ids uuid[] DEFAULT NULL::uuid[],
  p_accepted_group_comms boolean DEFAULT false
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
  v_member_id TEXT;
  v_exists INTEGER;
  v_optional_group_id UUID;
BEGIN
  UPDATE public.profiles
  SET
    needs_onboarding = false,
    onboarding_completed_at = NOW()
  WHERE id = p_profile_id;

  SELECT id INTO v_member_id
  FROM public.members
  WHERE id = p_profile_id::text
  LIMIT 1;

  IF v_member_id IS NULL THEN
    RETURN;
  END IF;

  IF p_primary_group_id IS NOT NULL THEN
    SELECT COUNT(*) INTO v_exists
    FROM public.group_memberships
    WHERE member_id = v_member_id AND group_id = p_primary_group_id::text;

    IF v_exists = 0 THEN
      INSERT INTO public.group_memberships (
        id, group_id, member_id, role, status, joined_at, is_active
      )
      VALUES (
        gen_random_uuid()::text,
        p_primary_group_id::text,
        v_member_id,
        'MEMBRE',
        'active',
        CURRENT_DATE,
        true
      );
    ELSE
      UPDATE public.group_memberships
      SET
        status = 'active',
        role = 'MEMBRE',
        is_active = true
      WHERE member_id = v_member_id
        AND group_id = p_primary_group_id::text;
    END IF;
  END IF;

  IF p_optional_group_ids IS NOT NULL AND array_length(p_optional_group_ids, 1) > 0 THEN
    FOREACH v_optional_group_id IN ARRAY p_optional_group_ids LOOP
      SELECT COUNT(*) INTO v_exists
      FROM public.group_memberships
      WHERE member_id = v_member_id
        AND group_id = v_optional_group_id::text;

      IF v_exists = 0 THEN
        INSERT INTO public.group_memberships (
          id, group_id, member_id, role, status, joined_at, is_active
        )
        VALUES (
          gen_random_uuid()::text,
          v_optional_group_id::text,
          v_member_id,
          'MEMBRE',
          'pending',
          CURRENT_DATE,
          false
        );
      ELSE
        UPDATE public.group_memberships
        SET
          status = 'pending',
          role = 'MEMBRE',
          is_active = false
        WHERE member_id = v_member_id
          AND group_id = v_optional_group_id::text;
      END IF;
    END LOOP;
  END IF;
END;
$function$;
