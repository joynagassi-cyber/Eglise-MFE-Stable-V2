-- ============================================================================
-- TRIGGER SUPABASE : member_photo_insert_trigger
-- ============================================================================
-- Trigger pour gérer l'activation automatique des photos de membres
-- Désactive toutes les autres photos du même membre lorsqu'une nouvelle est insérée
-- ============================================================================

-- 1. Créer la table de logs pour auditer les actions trigger
CREATE TABLE IF NOT EXISTS member_photo_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id UUID NOT NULL,
    file_id TEXT NOT NULL,
    uploaded_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    action TEXT NOT NULL CHECK (action IN ('insert', 'activate', 'deactivate')),
    triggered_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    triggered_by TEXT DEFAULT 'system_trigger'
);

-- Index pour les requêtes par membre
CREATE INDEX IF NOT EXISTS idx_member_photo_logs_member_id ON member_photo_logs(member_id);
CREATE INDEX IF NOT EXISTS idx_member_photo_logs_triggered_at ON member_photo_logs(triggered_at DESC);

-- 2. Fonction de trigger pour INSERT
CREATE OR REPLACE FUNCTION handle_member_photo_insert()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    deactivated_count INTEGER;
    log_id UUID;
BEGIN
    -- Validation de base
    IF NEW.member_id IS NULL OR NEW.file_id IS NULL OR NEW.uploaded_at IS NULL THEN
        RAISE EXCEPTION 'member_id, file_id, and uploaded_at are required';
    END IF;
    
    -- Si la photo insérée est active, désactiver les autres photos du même membre
    IF NEW.is_active = TRUE THEN
        UPDATE member_photos
        SET is_active = FALSE
        WHERE member_id = NEW.member_id
          AND id != NEW.id
          AND is_active = TRUE;
        
        GET DIAGNOSTICS deactivated_count = ROW_COUNT;
        
        -- Log des photos désactivées
        INSERT INTO member_photo_logs (member_id, file_id, uploaded_at, action, triggered_by)
        SELECT 
            member_id,
            file_id,
            NOW(),
            'deactivate',
            'system_trigger'
        FROM member_photos
        WHERE member_id = NEW.member_id
          AND id != NEW.id
          AND is_active = FALSE
        ON CONFLICT DO NOTHING;
    END IF;
    
    -- Log de la nouvelle photo
    INSERT INTO member_photo_logs (member_id, file_id, uploaded_at, action, triggered_by)
    VALUES (NEW.member_id, NEW.file_id, NOW(), 
            CASE WHEN NEW.is_active = TRUE THEN 'activate' ELSE 'insert' END,
            'system_trigger')
    RETURNING id INTO log_id;
    
    -- Pas besoin de retourner NEW modifié (sauf pour validation)
    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        -- Log de l'erreur dans une table séparée ou dans les logs système
        INSERT INTO member_photo_logs (member_id, file_id, uploaded_at, action, triggered_by)
        VALUES (NEW.member_id, NEW.file_id, NOW(), 'error', 'system_trigger');
        RAISE;
END;
$$;

-- 3. Fonction de trigger pour UPDATE (si is_active change)
CREATE OR REPLACE FUNCTION handle_member_photo_update()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    -- Si is_active passe de FALSE à TRUE, désactiver les autres
    IF OLD.is_active = FALSE AND NEW.is_active = TRUE THEN
        UPDATE member_photos
        SET is_active = FALSE
        WHERE member_id = NEW.member_id
          AND id != NEW.id
          AND is_active = TRUE;
        
        -- Log de l'activation
        INSERT INTO member_photo_logs (member_id, file_id, uploaded_at, action, triggered_by)
        VALUES (NEW.member_id, NEW.file_id, NOW(), 'activate', 'system_trigger');
    END IF;
    
    -- Si is_active passe de TRUE à FALSE, vérifier qu'il reste au moins une photo active
    IF OLD.is_active = TRUE AND NEW.is_active = FALSE THEN
        DECLARE
            active_count INTEGER;
        BEGIN
            SELECT COUNT(*) INTO active_count
            FROM member_photos
            WHERE member_id = NEW.member_id
              AND is_active = TRUE
              AND id != NEW.id;
            
            -- S'il n'y a plus de photo active, réactiver la dernière photo
            IF active_count = 0 THEN
                UPDATE member_photos
                SET is_active = TRUE
                WHERE member_id = NEW.member_id
                  AND uploaded_at = (
                      SELECT MAX(uploaded_at)
                      FROM member_photos
                      WHERE member_id = NEW.member_id
                  )
                RETURNING id INTO NEW.id;
            END IF;
        END;
    END IF;
    
    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        INSERT INTO member_photo_logs (member_id, file_id, uploaded_at, action, triggered_by)
        VALUES (NEW.member_id, NEW.file_id, NOW(), 'error', 'system_trigger');
        RAISE;
END;
$$;

-- 4. Créer les triggers
DROP TRIGGER IF EXISTS member_photo_insert_trigger ON member_photos;
CREATE TRIGGER member_photo_insert_trigger
    AFTER INSERT ON member_photos
    FOR EACH ROW
    EXECUTE FUNCTION handle_member_photo_insert();

DROP TRIGGER IF EXISTS member_photo_update_trigger ON member_photos;
CREATE TRIGGER member_photo_update_trigger
    AFTER UPDATE OF is_active ON member_photos
    FOR EACH ROW
    WHEN (OLD.is_active IS DISTINCT FROM NEW.is_active)
    EXECUTE FUNCTION handle_member_photo_update();

-- 5. Configuration Realtime Supabase pour la table member_photos
-- Cette configuration se fait dans le dashboard Supabase:
-- 1. Allez dans Database > Replication
-- 2. Activez "Realtime" pour la table "member_photos"
-- 3. Configurez les publications:
--    - INSERTS: OUI
--    - UPDATES: OUI  
--    - DELETES: NON (nous ne supprimons jamais de photos)
-- 4. Filtrer par user si nécessaire (ROW LEVEL SECURITY)

-- 6. Fonction utilitaire pour vérifier l'état des triggers
CREATE OR REPLACE FUNCTION get_trigger_status()
RETURNS TABLE (
    trigger_name TEXT,
    table_name TEXT,
    function_name TEXT,
    is_enabled BOOLEAN,
    created_at TIMESTAMP WITH TIME ZONE
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        tg.tgname::TEXT as trigger_name,
        relname::TEXT as table_name,
        proname::TEXT as function_name,
        tg.tgenabled = 'O' as is_enabled,
        tg.oid::regproc::oid::timestamp as created_at
    FROM pg_trigger tg
    JOIN pg_class cls ON tg.tgrelid = cls.oid
    JOIN pg_proc proc ON tg.tgfoid = proc.oid
    WHERE tg.tgname IN ('member_photo_insert_trigger', 'member_photo_update_trigger')
    ORDER BY tg.tgname;
END;
$$ LANGUAGE plpgsql;

-- 7. Vue pour monitoring des actions trigger
CREATE OR REPLACE VIEW member_photo_activity AS
SELECT 
    mpl.member_id,
    mpl.file_id,
    mpl.action,
    mpl.triggered_at,
    mp.uploaded_at as photo_uploaded_at,
    mp.is_active,
    CASE 
        WHEN mpl.action = 'activate' THEN '🟢 Photo activée'
        WHEN mpl.action = 'deactivate' THEN '🔴 Photo désactivée'
        WHEN mpl.action = 'insert' THEN '📄 Nouvelle photo'
        ELSE '⚠️ ' || mpl.action
    END as action_description
FROM member_photo_logs mpl
LEFT JOIN member_photos mp ON mpl.file_id = mp.file_id
ORDER BY mpl.triggered_at DESC;

-- 8. Commentaires et documentation
COMMENT ON TABLE member_photo_logs IS 'Audit trail des actions trigger sur les photos de membres';
COMMENT ON COLUMN member_photo_logs.action IS 'insert: nouvelle photo, activate: photo activée, deactivate: photo désactivée';
COMMENT ON COLUMN member_photo_logs.triggered_by IS 'system_trigger pour les actions automatiques, user_id pour les actions manuelles';

COMMENT ON FUNCTION handle_member_photo_insert() IS 'Trigger exécuté après INSERT sur member_photos. Désactive les anciennes photos et active la nouvelle.';
COMMENT ON FUNCTION handle_member_photo_update() IS 'Trigger exécuté après UPDATE de is_active. Gère la cohérence des états.';

-- 9. Exemple de test du trigger
-- INSERT INTO member_photos (member_id, file_id, file_url, uploaded_at, is_active, checksum)
-- VALUES ('123e4567-e89b-12d3-a456-426614174000', 'drive_file_id_1', 'https://drive.google.com/file/d/...', NOW(), TRUE, 'sha256_checksum');
-- -- Vérifier que les logs sont créés
-- SELECT * FROM member_photo_activity WHERE member_id = '123e4567-e89b-12d3-a456-426614174000';