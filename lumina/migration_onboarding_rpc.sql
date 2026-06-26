-- ----------------------------------------------------------------------------
-- Script SQL: Onboarding Membre (Assignations de Groupes V2)
-- A exécuter dans le SQL Editor de Supabase
-- ----------------------------------------------------------------------------

-- Cette fonction remplace toute ancienne logique pour s'appuyer sur la table `group_memberships`
-- Elle met à jour le profil du membre avec son genre et date de naissance.
-- Elle insère l'adhésion au groupe principal (statut: active)
-- Et les adhésions aux ministères optionnels (statut: pending)

CREATE OR REPLACE FUNCTION public.complete_member_onboarding_v2(
  p_profile_id UUID,
  p_gender TEXT,
  p_birth_date DATE,
  p_primary_group_id UUID,
  p_optional_group_ids UUID[],
  p_accepted_group_comms BOOLEAN
) RETURNS VOID AS $$
DECLARE
  v_member_id UUID;
  v_church_id UUID;
  v_group_id UUID;
BEGIN
  -- 1. Récupération du member_id et church_id liés à ce profil utilisateur
  SELECT id, church_id INTO v_member_id, v_church_id
  FROM public.members
  WHERE user_id = p_profile_id
  LIMIT 1;

  IF v_member_id IS NULL THEN
    RAISE EXCEPTION 'Aucun profil membre trouvé pour le user_id %', p_profile_id;
  END IF;

  -- 2. Mise à jour des informations démographiques basiques (genre, naissance)
  -- Optionnel: Si vous avez "gender" et "birth_date" dans la table profiles,
  -- mettez aussi à jour public.profiles. Ici on met à jour members.
  UPDATE public.members
  SET gender = p_gender,
      birth_date = p_birth_date
  WHERE id = v_member_id;

  -- 3. Insère le groupe primaire (ex: Hommes, Femmes) avec le statut 'active'
  -- On gère le ON CONFLICT pour ne pas dupliquer si le membre a déjà été assigné.
  IF p_primary_group_id IS NOT NULL THEN
    INSERT INTO public.group_memberships (
       church_id, group_id, member_id, role, status
    ) VALUES (
       v_church_id, p_primary_group_id, v_member_id, 'MEMBER', 'active'
    ) ON CONFLICT (group_id, member_id) DO UPDATE 
      SET status = 'active'; -- On garantit qu'il est actif
  END IF;

  -- 4. Insère les groupes optionnels (Ministères) avec le statut 'pending'
  -- Le leader de ces groupes cliquera sur Approuver de son côté.
  IF p_optional_group_ids IS NOT NULL THEN
    FOREACH v_group_id IN ARRAY p_optional_group_ids
    LOOP
      INSERT INTO public.group_memberships (
         church_id, group_id, member_id, role, status
      ) VALUES (
         v_church_id, v_group_id, v_member_id, 'MEMBER', 'pending'
      ) ON CONFLICT (group_id, member_id) DO NOTHING;
    END LOOP;
  END IF;

END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
