-- 1. MEMBERS MODULE ENHANCEMENTS
-- 1.1 Members Table Extensions (if not already existing or needs refinement)
-- Note: Sprint 5 README suggests a specific schema. We ensure it matches.
CREATE TABLE IF NOT EXISTS members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    church_id UUID NOT NULL REFERENCES churches(id),
    user_id UUID REFERENCES auth.users(id),
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    display_name TEXT,
    gender TEXT CHECK (gender IN ('male', 'female')),
    birth_date DATE,
    phone TEXT,
    email TEXT,
    address TEXT,
    photo_url TEXT,
    photo_drive_id TEXT,
    member_number TEXT UNIQUE,
    status TEXT DEFAULT 'active' CHECK (
        status IN (
            'active',
            'inactive',
            'visitor',
            'transferred',
            'deceased'
        )
    ),
    membership_date DATE,
    baptism_date DATE,
    shepherd_id UUID REFERENCES members(id),
    -- Self-reference for sheep/shepherd
    family_id UUID,
    -- Group identifier for family
    marital_status TEXT CHECK (
        marital_status IN ('single', 'married', 'widowed', 'divorced')
    ),
    occupation TEXT,
    notes TEXT,
    tags TEXT [],
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
-- 1.2 Family Relationships
CREATE TABLE IF NOT EXISTS family_relationships (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    related_member_id UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    relationship_type TEXT NOT NULL CHECK (
        relationship_type IN ('spouse', 'parent', 'child', 'sibling', 'other')
    ),
    is_primary BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    UNIQUE(member_id, related_member_id)
);
-- 1.3 Member History
CREATE TABLE IF NOT EXISTS member_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    event_type TEXT NOT NULL CHECK (
        event_type IN (
            'created',
            'updated',
            'status_changed',
            'baptized',
            'married',
            'transferred',
            'deleted'
        )
    ),
    event_date TIMESTAMP WITH TIME ZONE DEFAULT now(),
    description TEXT,
    performed_by UUID REFERENCES auth.users(id),
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
-- 1.4 Spiritual Tracking
CREATE TABLE IF NOT EXISTS spiritual_tracking (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    shepherd_id UUID REFERENCES members(id),
    last_contact_date DATE,
    next_follow_up_date DATE,
    spiritual_level TEXT,
    -- e.g. 'beginner', 'intermediate', 'mature', 'leader'
    prayer_requests TEXT,
    notes TEXT,
    growth_milestones TEXT [],
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
-- 2. EVENTS MODULE
-- 2.1 Events
CREATE TABLE IF NOT EXISTS events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    church_id UUID NOT NULL REFERENCES churches(id),
    title TEXT NOT NULL,
    description TEXT,
    event_type TEXT NOT NULL CHECK (
        event_type IN (
            'worship',
            'prayer',
            'bible_study',
            'conference',
            'special',
            'youth',
            'children',
            'meeting'
        )
    ),
    category TEXT,
    location TEXT,
    start_date TIMESTAMP WITH TIME ZONE NOT NULL,
    end_date TIMESTAMP WITH TIME ZONE,
    is_all_day BOOLEAN DEFAULT false,
    is_recurring BOOLEAN DEFAULT false,
    recurrence_rule TEXT,
    -- RRULE format
    max_attendees INTEGER,
    registration_required BOOLEAN DEFAULT false,
    registration_deadline TIMESTAMP WITH TIME ZONE,
    organizer_id UUID REFERENCES auth.users(id),
    status TEXT DEFAULT 'draft' CHECK (
        status IN ('draft', 'published', 'cancelled', 'completed')
    ),
    image_url TEXT,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
-- 2.2 Event Attendances
CREATE TABLE IF NOT EXISTS event_attendances (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    member_id UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    status TEXT DEFAULT 'registered' CHECK (
        status IN ('registered', 'attended', 'absent', 'cancelled')
    ),
    check_in_time TIMESTAMP WITH TIME ZONE,
    check_out_time TIMESTAMP WITH TIME ZONE,
    checked_in_by UUID REFERENCES auth.users(id),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    UNIQUE(event_id, member_id)
);
-- 2.3 Event Recurrence Instances (Optional helper)
CREATE TABLE IF NOT EXISTS event_recurrence (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    frequency TEXT NOT NULL CHECK (
        frequency IN ('daily', 'weekly', 'monthly', 'yearly')
    ),
    interval INTEGER DEFAULT 1,
    days_of_week INTEGER [],
    -- 0-6
    end_date DATE,
    occurrences_count INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
-- 3. RLS POLICIES
ALTER TABLE members ENABLE ROW LEVEL SECURITY;
ALTER TABLE family_relationships ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE spiritual_tracking ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_attendances ENABLE ROW LEVEL SECURITY;
-- Default policy: Church members can view, admins can manage
CREATE POLICY "View Members" ON members FOR
SELECT USING (true);
CREATE POLICY "View Events" ON events FOR
SELECT USING (true);
-- To be refined with real RBAC permissions later
-- 4. RPCs
-- 4.1 Member Stats
CREATE OR REPLACE FUNCTION get_member_stats(p_church_id UUID) RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE result JSONB;
BEGIN
SELECT jsonb_build_object(
        'total',
        COUNT(*),
        'active',
        COUNT(*) FILTER (
            WHERE status = 'active'
        ),
        'new_this_month',
        COUNT(*) FILTER (
            WHERE created_at > now() - interval '1 month'
        )
    ) INTO result
FROM members
WHERE church_id = p_church_id;
RETURN result;
END;
$$;