-- Simplification de l'onboarding membre
-- Plus de groupes automatiques, plus de groupes optionnels
-- Le membre voit une page de bienvenue puis atterrit directement sur son dashboard
-- Les rôles avec code aussi : plus de sélection de groupe

-- Suppression des fonctions groupes obsolètes (si elles existent)
DROP FUNCTION IF EXISTS determine_primary_group(UUID, TEXT, DATE);
DROP FUNCTION IF EXISTS determine_primary_group_v2(UUID, TEXT, DATE);
DROP FUNCTION IF EXISTS complete_member_onboarding(UUID, TEXT, DATE, UUID[], BOOLEAN);
DROP FUNCTION IF EXISTS complete_member_onboarding_v2(UUID, TEXT, TEXT, JSONB, BOOLEAN);
