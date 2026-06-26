-- ═══════════════════════════════════════════════════════════════════════════════
-- Migration: 20260215_search_and_feature_parity.sql
-- Date: 2026-02-15
-- Purpose: Add granular attendance, missing donations table, and search indices
-- ═══════════════════════════════════════════════════════════════════════════════
-- 1. Enable pg_trgm for high-performance text searching
CREATE EXTENSION IF NOT EXISTS pg_trgm;
-- 2. church_services: Add granular attendance tracking
DO $$ BEGIN IF NOT EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_name = 'church_services'
        AND column_name = 'men_count'
) THEN
ALTER TABLE public.church_services
ADD COLUMN men_count INTEGER DEFAULT 0;
END IF;
IF NOT EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_name = 'church_services'
        AND column_name = 'women_count'
) THEN
ALTER TABLE public.church_services
ADD COLUMN women_count INTEGER DEFAULT 0;
END IF;
IF NOT EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_name = 'church_services'
        AND column_name = 'children_count'
) THEN
ALTER TABLE public.church_services
ADD COLUMN children_count INTEGER DEFAULT 0;
END IF;
END $$;
COMMENT ON COLUMN public.church_services.men_count IS 'Nombre d''hommes présents lors du service.';
COMMENT ON COLUMN public.church_services.women_count IS 'Nombre de femmes présentes lors du service.';
COMMENT ON COLUMN public.church_services.children_count IS 'Nombre d''enfants présents lors du service.';
-- 3. donations: Create table if missing (linking donors to finance_transactions)
CREATE TABLE IF NOT EXISTS public.donations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    donor_id UUID NOT NULL REFERENCES public.donors(id) ON DELETE CASCADE,
    transaction_id UUID NOT NULL REFERENCES public.finance_transactions(id) ON DELETE CASCADE,
    amount NUMERIC NOT NULL,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    category TEXT,
    notes TEXT,
    is_anonymous BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
-- RLS for donations
ALTER TABLE public.donations ENABLE ROW LEVEL SECURITY;
DO $$ BEGIN DROP POLICY IF EXISTS "donations_select" ON public.donations;
CREATE POLICY "donations_select" ON public.donations FOR
SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "donations_manage" ON public.donations;
CREATE POLICY "donations_manage" ON public.donations FOR ALL TO authenticated USING (
    EXISTS (
        SELECT 1
        FROM user_roles ur
            JOIN roles r ON ur.role_id = r.id
        WHERE ur.user_id = auth.uid()
            AND r.code IN ('admin', 'pasteur', 'tresorier')
    )
);
END $$;
-- 4. SEARCH INDICES (Trigram for fuzzy/case-insensitive search)
-- Finance Transactions
CREATE INDEX IF NOT EXISTS idx_finance_transactions_desc_trgm ON public.finance_transactions USING gin (description gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_finance_transactions_cat_date ON public.finance_transactions (category_id, date DESC);
-- Sacraments (B-tree is fine for exact/prefix matches on names)
CREATE INDEX IF NOT EXISTS idx_sacraments_member_names ON public.sacraments (member_first_name, member_last_name);
CREATE INDEX IF NOT EXISTS idx_sacraments_godparents ON public.sacraments (godfather, godmother);
CREATE INDEX IF NOT EXISTS idx_sacraments_cert_number ON public.sacraments (certificate_number);
-- Groups
CREATE INDEX IF NOT EXISTS idx_groups_label_trgm ON public.groups USING gin (label gin_trgm_ops);
-- Annonces
CREATE INDEX IF NOT EXISTS idx_annonces_title_content_trgm ON public.annonces USING gin (title gin_trgm_ops, content gin_trgm_ops);
-- Pastoral Visits
CREATE INDEX IF NOT EXISTS idx_pastoral_visits_notes_trgm ON public.pastoral_visits USING gin (notes gin_trgm_ops);
-- ═══════════════════════════════════════════════════════════════════════════════
-- FIN MIGRATION
-- ═══════════════════════════════════════════════════════════════════════════════