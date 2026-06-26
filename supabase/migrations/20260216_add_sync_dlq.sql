-- ═══════════════════════════════════════════════════════════════════════════════
-- Migration: 20260216_add_sync_dlq.sql
-- Date: 2026-02-16
-- Objective: CRATOS 2.3 - Sync Resilience
-- Description: Create a Dead Letter Queue table for persistent sync failures.
-- ═══════════════════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.sync_dead_letter_queue (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    church_id TEXT,
    -- Optional, for filtering
    table_name TEXT NOT NULL,
    action TEXT NOT NULL,
    json_data JSONB NOT NULL,
    local_id TEXT,
    last_error TEXT,
    attempts INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    resolved_at TIMESTAMPTZ,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'resolved', 'ignored'))
);
-- Active RLS
ALTER TABLE public.sync_dead_letter_queue ENABLE ROW LEVEL SECURITY;
-- Politique : Seuls les administrateurs peuvent voir/gérer la DLQ
DROP POLICY IF EXISTS "Only admins can manage sync DLQ" ON public.sync_dead_letter_queue;
CREATE POLICY "Only admins can manage sync DLQ" ON public.sync_dead_letter_queue FOR ALL TO authenticated USING (
    public.is_super_admin()
    OR public.has_permission('audit', 'read')
);
-- Index pour la performance
CREATE INDEX IF NOT EXISTS idx_sync_dlq_church_id ON public.sync_dead_letter_queue(church_id);
CREATE INDEX IF NOT EXISTS idx_sync_dlq_status ON public.sync_dead_letter_queue(status);
COMMENT ON TABLE public.sync_dead_letter_queue IS 'Stocke les mutations ayant échoué après le nombre maximal de tentatives de synchronisation.';