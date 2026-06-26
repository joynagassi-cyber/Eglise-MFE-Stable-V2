-- ============================================================
-- MIGRATION : Système de groupes multi-niveaux
-- ============================================================

-- Étape 1 : Créer la table de relation membre ↔ groupe
CREATE TABLE IF NOT EXISTS member_groups (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  member_id    UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
  group_id     UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
  is_primary   BOOLEAN NOT NULL DEFAULT false,
  status       TEXT NOT NULL DEFAULT 'pending'
                 CHECK (status IN ('pending', 'active', 'rejected')),
  approved_by  UUID REFERENCES profiles(id),
  approved_at  TIMESTAMPTZ,
  joined_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),

  -- Un membre ne peut être dans le même groupe qu'une seule fois
  UNIQUE (member_id, group_id)
);

-- Étape 2 : Garantir qu'un membre n'a qu'UN SEUL groupe principal actif
-- Note: Un partial index permet d'avoir (member_id) unique seulement quand (is_primary=true et status='active')
CREATE UNIQUE INDEX idx_one_primary_group_per_member
  ON member_groups (member_id)
  WHERE is_primary = true AND status = 'active';

-- Étape 3 : Index de performance
CREATE INDEX idx_member_groups_member_id ON member_groups (member_id);
CREATE INDEX idx_member_groups_group_id  ON member_groups (group_id);
CREATE INDEX idx_member_groups_status    ON member_groups (status);

-- Étape 4 : Table de log des demandes de groupes optionnels
CREATE TABLE IF NOT EXISTS group_join_requests (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  member_id    UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
  group_id     UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
  message      TEXT,                           -- Message optionnel du candidat
  status       TEXT NOT NULL DEFAULT 'pending'
                 CHECK (status IN ('pending', 'approved', 'rejected')),
  reviewed_by  UUID REFERENCES profiles(id),
  reviewed_at  TIMESTAMPTZ,
  rejection_reason TEXT,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),

  UNIQUE (member_id, group_id)
);

-- ============================================================
-- POLITIQUES RLS
-- ============================================================

-- Activer RLS
ALTER TABLE member_groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE group_join_requests ENABLE ROW LEVEL SECURITY;

-- Un membre voit uniquement SES appartenances
CREATE POLICY "member_sees_own_groups"
  ON member_groups FOR SELECT TO authenticated
  USING (
    member_id IN (
      SELECT id FROM members WHERE profile_id = auth.uid()
    )
  );

-- Le chef de groupe voit les membres de SON groupe
CREATE POLICY "group_leader_sees_group_members"
  ON member_groups FOR SELECT TO authenticated
  USING (
    group_id IN (
      SELECT id FROM groups
      WHERE leader_id = auth.uid()
         OR id = (SELECT group_id FROM profiles WHERE id = auth.uid())
    )
  );

-- Le superadmin voit tout
CREATE POLICY "superadmin_sees_all_member_groups"
  ON member_groups FOR ALL TO authenticated
  USING (
    (SELECT raw_user_meta_data->>'role' FROM auth.users WHERE id = auth.uid()) 
    IN ('superadmin', 'president', 'vice_president', 'secretaire_general',
        'directeur_regional', 'coordinateur_national', 'administrateur_systeme',
        'gestionnaire_multi_eglise', 'responsable_rh', 'responsable_conformite')
  );

-- Un membre peut insérer ses propres demandes de groupe optionnel
CREATE POLICY "member_can_request_optional_group"
  ON group_join_requests FOR INSERT TO authenticated
  WITH CHECK (
    member_id IN (
      SELECT id FROM members WHERE profile_id = auth.uid()
    )
    -- Seulement pour les groupes non-primaires (Chorale, Intercession)
    AND group_id IN (
      SELECT id FROM groups WHERE type IN ('chorale', 'intercession')
    )
  );

-- Le chef de groupe peut approuver/rejeter les demandes pour SON groupe
CREATE POLICY "group_leader_manages_requests"
  ON group_join_requests FOR ALL TO authenticated
  USING (
    group_id IN (
      SELECT id FROM groups WHERE leader_id = auth.uid()
    )
  );

-- Un membre peut voir ses requetes
CREATE POLICY "member_sees_own_requests"
  ON group_join_requests FOR SELECT TO authenticated
  USING (
    member_id IN (
      SELECT id FROM members WHERE profile_id = auth.uid()
    )
  );


-- ============================================================
-- RPC FUNCTIONS
-- ============================================================

-- RPC 1 : Déterminer le groupe principal selon genre + âge
CREATE OR REPLACE FUNCTION determine_primary_group(
  p_church_id UUID,
  p_gender    TEXT,   -- 'male' | 'female'
  p_birth_date DATE
)
RETURNS UUID AS $$
DECLARE
  v_age     INTEGER;
  v_type    TEXT;
  v_group_id UUID;
BEGIN
  v_age := DATE_PART('year', AGE(p_birth_date));

  -- Règle d'âge prioritaire sur le genre
  IF v_age < 13 THEN
    v_type := 'enfants';
  ELSIF v_age BETWEEN 13 AND 29 THEN
    v_type := 'jeunesse';
  ELSIF p_gender = 'male' THEN
    v_type := 'hommes';
  ELSE
    v_type := 'femmes';
  END IF;

  SELECT id INTO v_group_id
  FROM groups
  WHERE church_id = p_church_id AND type = v_type
  LIMIT 1;

  RETURN v_group_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- RPC 2 : Effectuer l'assignation complète lors de l'onboarding
CREATE OR REPLACE FUNCTION complete_member_onboarding(
  p_profile_id          UUID,
  p_gender              TEXT,
  p_birth_date          DATE,
  p_optional_group_ids  UUID[],  -- Groupes optionnels demandés (Chorale, etc.)
  p_accepted_group_comms BOOLEAN  -- A accepté les communications de groupe
)
RETURNS JSON AS $$
DECLARE
  v_church_id  UUID;
  v_member_id  UUID;
  v_primary_group_id UUID;
  v_opt_group_id UUID;
BEGIN
  -- Récupérer church_id et member_id
  SELECT church_id INTO v_church_id FROM profiles WHERE id = p_profile_id;
  SELECT id INTO v_member_id FROM members WHERE profile_id = p_profile_id;

  -- Déterminer le groupe principal
  v_primary_group_id := determine_primary_group(v_church_id, p_gender, p_birth_date);

  -- Mettre à jour le profil avec le genre et la date de naissance
  UPDATE profiles SET
    gender = p_gender,
    birth_date = p_birth_date,
    accepted_group_communications = p_accepted_group_comms,
    onboarding_completed = true
  WHERE id = p_profile_id;

  -- Assigner le groupe principal (status = 'active' directement, pas de validation)
  INSERT INTO member_groups (member_id, group_id, is_primary, status, approved_at)
  VALUES (v_member_id, v_primary_group_id, true, 'active', now())
  ON CONFLICT (member_id, group_id) DO UPDATE SET
    is_primary = true, status = 'active', approved_at = now();

  -- Mettre à jour legacy column `group_id` for backward compatibility
  UPDATE members SET group_id = v_primary_group_id WHERE id = v_member_id;

  -- Créer les demandes pour les groupes optionnels (status = 'pending')
  FOREACH v_opt_group_id IN ARRAY p_optional_group_ids LOOP
    INSERT INTO group_join_requests (member_id, group_id)
    VALUES (v_member_id, v_opt_group_id)
    ON CONFLICT (member_id, group_id) DO NOTHING;
  END LOOP;

  -- Audit log si la table existe
  -- INSERT INTO audit_logs (church_id, user_id, action, entity_type, entity_id, new_data)
  -- VALUES (
  --  v_church_id, p_profile_id, 'member_onboarding_completed',
  --  'member', v_member_id,
  --  json_build_object(
  --    'primary_group_id', v_primary_group_id,
  --    'optional_groups_requested', p_optional_group_ids,
  --    'accepted_group_comms', p_accepted_group_comms
  --  )
  -- );

  RETURN json_build_object(
    'success', true,
    'primary_group_id', v_primary_group_id,
    'optional_requests_count', array_length(p_optional_group_ids, 1)
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- RPC 3 : Approuver une demande de groupe optionnel (appelée par le chef de groupe)
CREATE OR REPLACE FUNCTION approve_group_join_request(
  p_request_id UUID,
  p_approved_by UUID
)
RETURNS BOOLEAN AS $$
DECLARE
  v_req group_join_requests%ROWTYPE;
BEGIN
  SELECT * INTO v_req FROM group_join_requests WHERE id = p_request_id;

  -- Mettre à jour la demande
  UPDATE group_join_requests SET
    status = 'approved',
    reviewed_by = p_approved_by,
    reviewed_at = now()
  WHERE id = p_request_id;

  -- Créer l'entrée dans member_groups
  INSERT INTO member_groups (member_id, group_id, is_primary, status, approved_by, approved_at)
  VALUES (v_req.member_id, v_req.group_id, false, 'active', p_approved_by, now())
  ON CONFLICT (member_id, group_id) DO UPDATE SET
    status = 'active', approved_by = p_approved_by, approved_at = now();

  -- Envoi Notification omis ici. A gérer en edge funct, trigger DB ou app side.

  RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- RPC 4 : Rejeter une demande
CREATE OR REPLACE FUNCTION reject_group_join_request(
  p_request_id     UUID,
  p_reviewed_by    UUID,
  p_reason         TEXT DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
  v_req group_join_requests%ROWTYPE;
BEGIN
  SELECT * INTO v_req FROM group_join_requests WHERE id = p_request_id;

  UPDATE group_join_requests SET
    status = 'rejected',
    reviewed_by = p_reviewed_by,
    reviewed_at = now(),
    rejection_reason = p_reason
  WHERE id = p_request_id;

  RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
