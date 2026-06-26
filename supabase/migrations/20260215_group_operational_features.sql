-- ═══════════════════════════════════════════════════════════════════════════════
-- Leader Operational Features Hardening
-- Date: 2026-02-15
-- Purpose: Add support for attendance tracking and member transfer requests
-- ═══════════════════════════════════════════════════════════════════════════════
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ 1. GROUP ATTENDANCE                                                        │
-- └─────────────────────────────────────────────────────────────────────────────┘
CREATE TABLE IF NOT EXISTS group_attendance (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
    member_id TEXT NOT NULL,
    -- Logical ID of the member
    attendance_date DATE NOT NULL DEFAULT CURRENT_DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'PRESENT',
    -- PRESENT, ABSENT, LATE, EXCUSED
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(group_id, member_id, attendance_date)
);
CREATE INDEX IF NOT EXISTS idx_group_attendance_group ON group_attendance(group_id, attendance_date);
CREATE INDEX IF NOT EXISTS idx_group_attendance_member ON group_attendance(member_id);
-- RLS
ALTER TABLE group_attendance ENABLE ROW LEVEL SECURITY;
CREATE POLICY "group_attendance_select" ON group_attendance FOR
SELECT TO authenticated USING (true);
CREATE POLICY "group_attendance_manage" ON group_attendance FOR ALL TO authenticated USING (
    EXISTS (
        SELECT 1
        FROM user_roles ur
            JOIN roles r ON ur.role_id = r.id
        WHERE ur.user_id = auth.uid()
            AND r.name IN ('admin', 'pasteur', 'berger')
            AND ur.is_active = true
    )
);
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ 2. MEMBER TRANSFER REQUESTS                                               │
-- └─────────────────────────────────────────────────────────────────────────────┘
CREATE TABLE IF NOT EXISTS member_transfer_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id TEXT NOT NULL,
    from_group_id UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
    to_group_id UUID REFERENCES groups(id) ON DELETE
    SET NULL,
        -- Can be null for "exit from groups"
        requester_id UUID NOT NULL REFERENCES auth.users(id),
        reason TEXT,
        status VARCHAR(20) DEFAULT 'PENDING',
        -- PENDING, APPROVED, REJECTED, CANCELLED
        notes TEXT,
        approved_by UUID REFERENCES auth.users(id),
        approved_at TIMESTAMPTZ,
        created_at TIMESTAMPTZ DEFAULT NOW(),
        updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_member_transfers_member ON member_transfer_requests(member_id);
CREATE INDEX IF NOT EXISTS idx_member_transfers_status ON member_transfer_requests(status);
-- RLS
ALTER TABLE member_transfer_requests ENABLE ROW LEVEL SECURITY;
CREATE POLICY "member_transfer_requests_select" ON member_transfer_requests FOR
SELECT TO authenticated USING (true);
CREATE POLICY "member_transfer_requests_manage" ON member_transfer_requests FOR ALL TO authenticated USING (
    EXISTS (
        SELECT 1
        FROM user_roles ur
            JOIN roles r ON ur.role_id = r.id
        WHERE ur.user_id = auth.uid()
            AND r.name IN ('admin', 'pasteur', 'berger')
            AND ur.is_active = true
    )
);
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ 3. TRIGGER FOR UPDATED_AT                                                 │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- (Assuming handle_updated_at function already exists from previous migrations)
DO $$ BEGIN IF EXISTS (
    SELECT 1
    FROM pg_proc
    WHERE proname = 'handle_updated_at'
) THEN CREATE TRIGGER set_updated_at_group_attendance BEFORE
UPDATE ON group_attendance FOR EACH ROW EXECUTE FUNCTION handle_updated_at();
CREATE TRIGGER set_updated_at_member_transfer_requests BEFORE
UPDATE ON member_transfer_requests FOR EACH ROW EXECUTE FUNCTION handle_updated_at();
END IF;
END $$;