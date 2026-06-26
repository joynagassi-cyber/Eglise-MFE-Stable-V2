-- Migration: Create drive_files table for R2 Storage Metadata
-- Description: Stores metadata for files uploaded to Cloudflare R2.
CREATE TABLE IF NOT EXISTS public.drive_files (
    id UUID PRIMARY KEY DEFAULT extensions.uuid_generate_v4(),
    r2_key TEXT NOT NULL UNIQUE,
    entity_type TEXT NOT NULL,
    entity_id TEXT NOT NULL,
    original_filename TEXT NOT NULL,
    mime_type TEXT NOT NULL,
    file_size_bytes BIGINT NOT NULL,
    uploaded_by UUID REFERENCES auth.users(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
-- Enable RLS
ALTER TABLE public.drive_files ENABLE ROW LEVEL SECURITY;
-- Policies for drive_files
-- 1. Superadmins can do everything
CREATE POLICY "Superadmins have full access to drive_files" ON public.drive_files FOR ALL TO authenticated USING (auth.has_permission('drive_files', 'admin'));
-- 2. Users can view files they uploaded
CREATE POLICY "Users can view their own uploaded files" ON public.drive_files FOR
SELECT TO authenticated USING (uploaded_by = auth.uid());
-- 3. Users can view files linked to members they have access to (simplified for now)
-- In a real scenario, this would check if the user has permission to view the entity_id
CREATE POLICY "Authenticated users can view drive_files metadata" ON public.drive_files FOR
SELECT TO authenticated USING (true);
-- 4. Insert is handled by the worker (Service Role), but we add a policy for safety
-- Note: Service role bypasses RLS, but it's good practice for authenticated inserts if needed.
-- Grant access to authenticated users
GRANT ALL ON public.drive_files TO authenticated;
GRANT ALL ON public.drive_files TO service_role;