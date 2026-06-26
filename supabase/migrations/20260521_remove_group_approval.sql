-- Suppression de la fonctionnalité d'approbation de groupe
-- Les groupes n'ont plus de demandes d'adhésion à valider
-- Les leaders n'ont plus de page d'approbation

-- 1. Supprimer les RPCs d'approbation
DROP FUNCTION IF EXISTS approve_group_join_request(UUID, UUID);
DROP FUNCTION IF EXISTS reject_group_join_request(UUID, UUID, TEXT);

-- 2. Supprimer les tables liées aux demandes d'adhésion
DROP TABLE IF EXISTS group_join_requests CASCADE;
DROP TABLE IF EXISTS member_groups CASCADE;

-- 3. Supprimer les index
DROP INDEX IF EXISTS idx_one_primary_group_per_member;
DROP INDEX IF EXISTS idx_member_groups_member_id;
DROP INDEX IF EXISTS idx_member_groups_group_id;
DROP INDEX IF EXISTS idx_member_groups_status;

-- 4. Supprimer les colonnes legacy si elles existent
ALTER TABLE members DROP COLUMN IF EXISTS group_id;

-- 5. Supprimer le champ legacy group_id (conservé pour compatibilité avec les policies RLS)
-- ALTER TABLE members DROP COLUMN IF EXISTS group_id;
