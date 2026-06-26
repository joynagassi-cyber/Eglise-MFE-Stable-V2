-- migrations/sprint5_cleanup_and_fixes.sql
-- Goal: Fix schema discrepancies and prepare for Google Drive removal
-- 1. Add slug to churches table
ALTER TABLE churches
ADD COLUMN IF NOT EXISTS slug TEXT UNIQUE;
-- 2. Migrate data from old 'membres' to new 'members'
-- Note: Assuming the schema is compatible or mapped correctly
-- 'membres' columns: id, church_id, last_name, first_name, photo_url, role
-- 'members' columns: id, church_id, last_name, first_name, photo_url, ...
INSERT INTO members (
        id,
        church_id,
        first_name,
        last_name,
        photo_url,
        created_at
    )
SELECT id,
    church_id,
    prenom,
    nom,
    photo_url,
    created_at
FROM membres ON CONFLICT (id) DO NOTHING;
-- 3. Correct member_photos schema
-- Rename file_id to drive_file_id (legacy) and ensure r2_key column exists
DO $$ BEGIN IF EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_name = 'member_photos'
        AND column_name = 'file_id'
) THEN
ALTER TABLE member_photos
    RENAME COLUMN file_id TO drive_file_id;
END IF;
END $$;
ALTER TABLE member_photos
ADD COLUMN IF NOT EXISTS r2_key TEXT;
-- 4. Repurpose drive_files for R2 metadata (Optional, for logging)
ALTER TABLE drive_files
ADD COLUMN IF NOT EXISTS storage_provider TEXT DEFAULT 'R2';
-- 5. Drop legacy table (CAUTION: ensure data is migrated)
-- DROP TABLE membres; -- Recommended only after manual verification