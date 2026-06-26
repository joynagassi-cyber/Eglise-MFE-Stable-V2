-- cleanup_legacy.sql
-- Supprime les tables RBAC legacy pour préparer la v3.0
-- ATTENTION : Destructif !
BEGIN;
-- Supprimer tables RBAC v3 potentielles (si ré-exécution)
DROP TABLE IF EXISTS audit_user_roles CASCADE;
DROP TABLE IF EXISTS user_sessions CASCADE;
DROP TABLE IF EXISTS user_roles CASCADE;
DROP TABLE IF EXISTS role_permissions CASCADE;
DROP TABLE IF EXISTS permissions CASCADE;
DROP TABLE IF EXISTS roles CASCADE;
DROP TABLE IF EXISTS groups CASCADE;
DROP TABLE IF EXISTS users CASCADE;
-- On recrée users propre
-- Supprimer types si existent
DROP TYPE IF EXISTS role_scope CASCADE;
COMMIT;