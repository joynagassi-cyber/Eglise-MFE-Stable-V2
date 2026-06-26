-- Migration: Create drive_files table for R2 metadata
-- Created: 2025-01-28
-- Purpose: Store metadata for files uploaded to Cloudflare R2

CREATE TABLE IF NOT EXISTS public.drive_files (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  church_id UUID NOT NULL REFERENCES public.churches(id) ON DELETE CASCADE,
  file_name TEXT NOT NULL,
  file_size BIGINT NOT NULL,
  mime_type TEXT NOT NULL,
  r2_key TEXT NOT NULL UNIQUE,
  r2_url TEXT NOT NULL,
  uploaded_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  entity_type TEXT CHECK (entity_type IN ('member', 'report', 'document', 'invoice')),
  entity_id UUID,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_drive_files_church ON public.drive_files(church_id);
CREATE INDEX idx_drive_files_entity ON public.drive_files(entity_type, entity_id);
CREATE INDEX idx_drive_files_r2_key ON public.drive_files(r2_key);
CREATE INDEX idx_drive_files_uploaded_by ON public.drive_files(uploaded_by);

-- Enable RLS
ALTER TABLE public.drive_files ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view files from their church"
  ON public.drive_files FOR SELECT
  USING (
    church_id IN (
      SELECT church_id FROM public.user_churches 
      WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can upload files to their church"
  ON public.drive_files FOR INSERT
  WITH CHECK (
    church_id IN (
      SELECT church_id FROM public.user_churches 
      WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete files from their church"
  ON public.drive_files FOR DELETE
  USING (
    church_id IN (
      SELECT church_id FROM public.user_churches 
      WHERE user_id = auth.uid()
    )
  );

-- Trigger for updated_at
CREATE OR REPLACE FUNCTION update_drive_files_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_drive_files_updated_at
  BEFORE UPDATE ON public.drive_files
  FOR EACH ROW
  EXECUTE FUNCTION update_drive_files_updated_at();

-- Comment
COMMENT ON TABLE public.drive_files IS 'Metadata for files stored in Cloudflare R2';
COMMENT ON COLUMN public.drive_files.r2_key IS 'Cloudflare R2 object key';
COMMENT ON COLUMN public.drive_files.r2_url IS 'Cloudflare R2 public URL';
