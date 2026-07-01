-- SQL pour créer la table member_photos dans Supabase
-- À exécuter via MCP Supabase ou SQL Editor
-- Table principale pour les photos de membres
CREATE TABLE IF NOT EXISTS member_photos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id UUID NOT NULL,
    file_id TEXT NOT NULL,
    file_url TEXT NOT NULL,
    uploaded_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    checksum TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);
-- Index pour les requêtes par membre
CREATE INDEX IF NOT EXISTS idx_member_photos_member_id ON member_photos(member_id);
-- Index pour les requêtes temporelles
CREATE INDEX IF NOT EXISTS idx_member_photos_uploaded_at ON member_photos(uploaded_at);
-- Contrainte: une seule photo active par membre
CREATE UNIQUE INDEX IF NOT EXISTS idx_member_photos_unique_active ON member_photos(member_id)
WHERE is_active = TRUE;
-- Index composite pour les requêtes de restauration temporelle
CREATE INDEX IF NOT EXISTS idx_member_photos_member_date ON member_photos(member_id, uploaded_at DESC);
-- Table d'audit pour suivre les modifications (optionnelle mais recommandée)
CREATE TABLE IF NOT EXISTS member_photos_audit (
    audit_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    photo_id UUID NOT NULL,
    action TEXT NOT NULL CHECK (action IN ('INSERT', 'UPDATE', 'DELETE')),
    old_data JSONB,
    new_data JSONB,
    changed_by TEXT,
    changed_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);
-- Fonction de déclencheur pour l'audit
CREATE OR REPLACE FUNCTION audit_member_photos() RETURNS TRIGGER AS $$ BEGIN IF TG_OP = 'INSERT' THEN
INSERT INTO member_photos_audit (photo_id, action, new_data, changed_at)
VALUES (NEW.id, 'INSERT', row_to_json(NEW), NOW());
RETURN NEW;
ELSIF TG_OP = 'UPDATE' THEN
INSERT INTO member_photos_audit (photo_id, action, old_data, new_data, changed_at)
VALUES (
        NEW.id,
        'UPDATE',
        row_to_json(OLD),
        row_to_json(NEW),
        NOW()
    );
RETURN NEW;
ELSIF TG_OP = 'DELETE' THEN
INSERT INTO member_photos_audit (photo_id, action, old_data, changed_at)
VALUES (OLD.id, 'DELETE', row_to_json(OLD), NOW());
RETURN OLD;
END IF;
RETURN NULL;
END;
$$ LANGUAGE plpgsql;
-- Déclencheur d'audit
DROP TRIGGER IF EXISTS trg_audit_member_photos ON member_photos;
CREATE TRIGGER trg_audit_member_photos
AFTER
INSERT
    OR
UPDATE
    OR DELETE ON member_photos FOR EACH ROW EXECUTE FUNCTION audit_member_photos();
-- Fonction pour récupérer la photo active d'un membre
CREATE OR REPLACE FUNCTION get_active_member_photo(p_member_id UUID) RETURNS TABLE (
        file_id TEXT,
        file_url TEXT,
        uploaded_at TIMESTAMP WITH TIME ZONE,
        checksum TEXT
    ) AS $$ BEGIN RETURN QUERY
SELECT mp.file_id,
    mp.file_url,
    mp.uploaded_at,
    mp.checksum
FROM member_photos mp
WHERE mp.member_id = p_member_id
    AND mp.is_active = TRUE
LIMIT 1;
END;
$$ LANGUAGE plpgsql;
-- Fonction pour récupérer la photo à une date spécifique
CREATE OR REPLACE FUNCTION get_member_photo_at_date(
        p_member_id UUID,
        p_target_date TIMESTAMP WITH TIME ZONE
    ) RETURNS TABLE (
        file_id TEXT,
        file_url TEXT,
        uploaded_at TIMESTAMP WITH TIME ZONE,
        checksum TEXT
    ) AS $$ BEGIN RETURN QUERY
SELECT mp.file_id,
    mp.file_url,
    mp.uploaded_at,
    mp.checksum
FROM member_photos mp
WHERE mp.member_id = p_member_id
    AND mp.uploaded_at <= p_target_date
ORDER BY mp.uploaded_at DESC
LIMIT 1;
END;
$$ LANGUAGE plpgsql;
-- Fonction pour désactiver l'ancienne photo lors d'un nouvel upload
CREATE OR REPLACE FUNCTION deactivate_old_photo(p_member_id UUID) RETURNS INTEGER AS $$
DECLARE deactivated_count INTEGER;
BEGIN
UPDATE member_photos
SET is_active = FALSE
WHERE member_id = p_member_id
    AND is_active = TRUE;
GET DIAGNOSTICS deactivated_count = ROW_COUNT;
RETURN deactivated_count;
END;
$$ LANGUAGE plpgsql;
-- Vérification des permissions (utile pour le débogage)
COMMENT ON TABLE member_photos IS 'Stockage des métadonnées des photos de membres (fichiers dans Cloudflare R2)';
COMMENT ON COLUMN member_photos.file_id IS 'ID unique du fichier dans Cloudflare R2';
COMMENT ON COLUMN member_photos.file_url IS 'URL publique de visualisation dans Cloudflare R2';
COMMENT ON COLUMN member_photos.checksum IS 'SHA-256 checksum pour vérifier l''intégrité du fichier';
COMMENT ON COLUMN member_photos.is_active IS 'TRUE pour la photo actuellement active du membre';