-- Sprint 5 Migration: Members & Events Refinement
-- 1. Refine 'members' table (Enabling more fields from the new domain model)
ALTER TABLE public.members
ADD COLUMN IF NOT EXISTS display_name TEXT,
    ADD COLUMN IF NOT EXISTS gender TEXT CHECK (gender IN ('male', 'female', 'other')),
    ADD COLUMN IF NOT EXISTS birth_date DATE,
    ADD COLUMN IF NOT EXISTS address TEXT,
    ADD COLUMN IF NOT EXISTS photo_url TEXT,
    ADD COLUMN IF NOT EXISTS photo_drive_id TEXT,
    ADD COLUMN IF NOT EXISTS member_number TEXT UNIQUE,
    ADD COLUMN IF NOT EXISTS membership_date DATE,
    ADD COLUMN IF NOT EXISTS baptism_date DATE,
    ADD COLUMN IF NOT EXISTS shepherd_id TEXT,
    -- Link to members (shepherds are also members)
ADD COLUMN IF NOT EXISTS family_id TEXT,
    -- Optional logical grouping
ADD COLUMN IF NOT EXISTS marital_status TEXT,
    ADD COLUMN IF NOT EXISTS occupation TEXT,
    ADD COLUMN IF NOT EXISTS notes TEXT,
    ADD COLUMN IF NOT EXISTS tags TEXT [],
    ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;
-- 2. Create 'family_relationships' table
CREATE TABLE IF NOT EXISTS public.family_relationships (
    id TEXT PRIMARY KEY DEFAULT (gen_random_uuid())::text,
    member_id TEXT REFERENCES public.members(id) ON DELETE CASCADE,
    related_member_id TEXT REFERENCES public.members(id) ON DELETE CASCADE,
    relationship_type TEXT NOT NULL,
    -- spouse, parent, child, sibling, other
    is_primary BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now(),
    CONSTRAINT unique_relationship UNIQUE(member_id, related_member_id, relationship_type)
);
-- 3. Create 'member_history' table (Audit)
CREATE TABLE IF NOT EXISTS public.member_history (
    id TEXT PRIMARY KEY DEFAULT (gen_random_uuid())::text,
    member_id TEXT REFERENCES public.members(id) ON DELETE CASCADE,
    event_type TEXT NOT NULL,
    -- created, updated, status_changed, baptized, married, transferred, deleted
    event_date TIMESTAMPTZ DEFAULT now(),
    description TEXT,
    performed_by UUID REFERENCES auth.users(id),
    metadata JSONB DEFAULT '{}'::jsonb
);
-- 4. Create 'spiritual_tracking' table
CREATE TABLE IF NOT EXISTS public.spiritual_tracking (
    id TEXT PRIMARY KEY DEFAULT (gen_random_uuid())::text,
    member_id TEXT REFERENCES public.members(id) ON DELETE CASCADE,
    shepherd_id TEXT REFERENCES public.members(id),
    last_contact_date DATE,
    next_follow_up_date DATE,
    spiritual_level TEXT,
    -- beginner, growing, mature, leader
    prayer_requests TEXT,
    notes TEXT,
    growth_milestones TEXT [],
    -- List of completed milestones
    updated_at TIMESTAMPTZ DEFAULT now()
);
-- 5. Refine 'events' table
ALTER TABLE public.events
ADD COLUMN IF NOT EXISTS type TEXT,
    -- service, meeting, workshop, etc.
ADD COLUMN IF NOT EXISTS church_id TEXT,
    -- Ensure church_id exists
ADD COLUMN IF NOT EXISTS group_id TEXT,
    -- Linked to groups if applicable
ADD COLUMN IF NOT EXISTS recurrence_id TEXT;
-- 6. Create 'event_attendances' table
CREATE TABLE IF NOT EXISTS public.event_attendances (
    id TEXT PRIMARY KEY DEFAULT (gen_random_uuid())::text,
    event_id TEXT REFERENCES public.events(id) ON DELETE CASCADE,
    member_id TEXT REFERENCES public.members(id) ON DELETE
    SET NULL,
        guest_name TEXT,
        -- For non-members
        guest_phone TEXT,
        status TEXT DEFAULT 'present',
        -- present, absent, excused
        check_in_at TIMESTAMPTZ,
        notes TEXT,
        created_at TIMESTAMPTZ DEFAULT now()
);
-- 7. Create 'event_recurrence' table
CREATE TABLE IF NOT EXISTS public.event_recurrence (
    id TEXT PRIMARY KEY DEFAULT (gen_random_uuid())::text,
    frequency TEXT NOT NULL,
    -- daily, weekly, monthly, yearly
    interval INTEGER DEFAULT 1,
    by_day TEXT [],
    -- Monday, Tuesday, etc.
    by_month_day INTEGER [],
    end_date DATE,
    occurrences_count INTEGER,
    created_at TIMESTAMPTZ DEFAULT now()
);
-- 8. Add Foreign Keys for recursion/cross-linking
ALTER TABLE public.members
ADD CONSTRAINT members_shepherd_id_fkey FOREIGN KEY (shepherd_id) REFERENCES public.members(id);
-- RLS (Basic - logic inherited from church_id)
ALTER TABLE public.family_relationships ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.member_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.spiritual_tracking ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.event_attendances ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.event_recurrence ENABLE ROW LEVEL SECURITY;
-- Policies (Simplified)
CREATE POLICY "Church base access" ON public.family_relationships FOR ALL USING (true);
-- Placeholder: refine with church_id filter
CREATE POLICY "Church base access" ON public.member_history FOR ALL USING (true);
CREATE POLICY "Church base access" ON public.spiritual_tracking FOR ALL USING (true);
CREATE POLICY "Church base access" ON public.event_attendances FOR ALL USING (true);
CREATE POLICY "Church base access" ON public.event_recurrence FOR ALL USING (true);