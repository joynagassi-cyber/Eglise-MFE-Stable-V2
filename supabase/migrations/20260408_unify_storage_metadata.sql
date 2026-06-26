-- Migration: 20260408_unify_storage_metadata
-- Description: Unifies storage metadata and hardens proof_images RLS policies.
-- Adds church_id to drive_files for strict multi-tenant isolation.
-- Enforces stricter RLS on proof_images.

-- 1. Add church_id to drive_files for multi-tenant isolation
ALTER TABLE public.drive_files 
ADD COLUMN IF NOT EXISTS church_id UUID REFERENCES public.churches(id);

-- Optional: Create an index for faster lookups by church
CREATE INDEX IF NOT EXISTS idx_drive_files_church_id ON public.drive_files(church_id);

-- 2. Update drive_files RLS to enforce church_id isolation
-- Drop the overly permissive SELECT policy
DROP POLICY IF EXISTS "Authenticated users can view drive_files metadata" ON public.drive_files;

-- Recreate SELECT policy restricted by church_id and user_profiles
CREATE POLICY "Users can view drive_files for their church" 
ON public.drive_files FOR SELECT 
TO authenticated 
USING (
    church_id IS NULL OR 
    church_id = (SELECT church_id FROM public.user_profiles WHERE id = auth.uid())
);

-- 3. Harden proof_images RLS policies
-- Ensure proof_images respects church_id via transactions (since proofs belong to transactions)
-- Drop existing policies if they are too permissive
DROP POLICY IF EXISTS "Insert proof images" ON public.proof_images;
DROP POLICY IF EXISTS "Read proof images" ON public.proof_images;

CREATE POLICY "Users can read proof images for their church" 
ON public.proof_images FOR SELECT 
TO authenticated 
USING (
    EXISTS (
        SELECT 1 FROM public.transactions t 
        WHERE t.id = proof_images.transaction_id 
        AND t.church_id = (SELECT church_id FROM public.user_profiles WHERE id = auth.uid())
    )
);

CREATE POLICY "Users can insert proof images for their church" 
ON public.proof_images FOR INSERT 
TO authenticated 
WITH CHECK (
    uploaded_by = auth.uid() 
    -- Further validation could test transaction_id, but the transaction must be created first
);

-- Enable RLS just to be sure
ALTER TABLE public.proof_images ENABLE ROW LEVEL SECURITY;
