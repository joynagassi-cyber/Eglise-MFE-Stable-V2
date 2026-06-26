-- Migration: Ajouter colonne slug à churches
-- Date: 2025-02-10

ALTER TABLE churches 
ADD COLUMN IF NOT EXISTS slug TEXT UNIQUE;

-- Générer slugs pour églises existantes
UPDATE churches 
SET slug = LOWER(REGEXP_REPLACE(name, '[^a-zA-Z0-9]+', '-', 'g'))
WHERE slug IS NULL;

-- Index pour recherche rapide
CREATE INDEX IF NOT EXISTS idx_churches_slug ON churches(slug);

COMMENT ON COLUMN churches.slug IS 'URL-friendly identifier for church';
