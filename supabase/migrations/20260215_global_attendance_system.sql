-- ═══════════════════════════════════════════════════════════════════════════════
-- Global Attendance System (360° View)
-- Date: 2026-02-15
-- Purpose: Add service_attendance table for global church services pointage
-- ═══════════════════════════════════════════════════════════════════════════════
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ 1. SERVICE ATTENDANCE                                                      │
-- └─────────────────────────────────────────────────────────────────────────────┘
CREATE TABLE IF NOT EXISTS service_attendance (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    service_id UUID NOT NULL REFERENCES church_services(id) ON DELETE CASCADE,
    member_id TEXT NOT NULL,
    -- Logical ID of the member
    check_in_time TIMESTAMPTZ DEFAULT NOW(),
    status VARCHAR(20) NOT NULL DEFAULT 'PRESENT',
    -- PRESENT, ABSENT, LATE, EXCUSED
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(service_id, member_id)
);
CREATE INDEX IF NOT EXISTS idx_service_attendance_service ON service_attendance(service_id);
CREATE INDEX IF NOT EXISTS idx_service_attendance_member ON service_attendance(member_id);
-- RLS
ALTER TABLE service_attendance ENABLE ROW LEVEL SECURITY;
CREATE POLICY "service_attendance_select" ON service_attendance FOR
SELECT TO authenticated USING (true);
CREATE POLICY "service_attendance_manage" ON service_attendance FOR ALL TO authenticated USING (
    EXISTS (
        SELECT 1
        FROM user_roles ur
            JOIN roles r ON ur.role_id = r.id
        WHERE ur.user_id = auth.uid()
            AND r.name IN ('admin', 'pasteur', 'superadmin')
            AND ur.is_active = true
    )
);
-- Trigger for updated_at
DO $$ BEGIN IF EXISTS (
    SELECT 1
    FROM pg_proc
    WHERE proname = 'handle_updated_at'
) THEN CREATE TRIGGER set_updated_at_service_attendance BEFORE
UPDATE ON service_attendance FOR EACH ROW EXECUTE FUNCTION handle_updated_at();
END IF;
END $$;