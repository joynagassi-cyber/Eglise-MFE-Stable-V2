-- Migration Sprint 3: Approvals Workflow
-- ==============================================================================
-- 1. Tables Creation
-- ==============================================================================
-- 1.1 Approval Matrices
CREATE TABLE IF NOT EXISTS approval_matrices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    church_id UUID NOT NULL,
    -- Assuming multi-tenant or just strictly validated
    name TEXT NOT NULL,
    description TEXT,
    entity_type TEXT NOT NULL,
    -- transaction, budget, etc.
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
-- 1.2 Approval Matrix Steps
CREATE TABLE IF NOT EXISTS approval_matrix_steps (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    matrix_id UUID REFERENCES approval_matrices(id) ON DELETE CASCADE,
    step_order INT NOT NULL,
    step_label TEXT NOT NULL,
    approver_type TEXT NOT NULL,
    -- role, specific_user, etc.
    approver_role_codes TEXT [],
    -- Array of role codes
    approver_user_id UUID REFERENCES auth.users(id),
    min_amount NUMERIC,
    max_amount NUMERIC,
    sla_hours INT,
    escalation_role_code TEXT,
    requires_comment BOOLEAN DEFAULT false,
    auto_approve_if_same_user BOOLEAN DEFAULT true
);
-- 1.3 Approval Requests
CREATE TABLE IF NOT EXISTS approval_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    church_id UUID,
    matrix_id UUID REFERENCES approval_matrices(id),
    entity_type TEXT NOT NULL,
    entity_id UUID NOT NULL,
    -- Generic reference
    entity_label TEXT,
    entity_amount NUMERIC,
    entity_data JSONB,
    status TEXT NOT NULL DEFAULT 'pending',
    -- pending, in_progress, approved, rejected, cancelled
    current_step_order INT DEFAULT 1,
    total_steps INT,
    requested_by UUID REFERENCES auth.users(id),
    requested_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    completed_at TIMESTAMP WITH TIME ZONE,
    priority TEXT DEFAULT 'normal',
    due_date TIMESTAMP WITH TIME ZONE
);
-- 1.4 Approval Decisions
CREATE TABLE IF NOT EXISTS approval_decisions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id UUID REFERENCES approval_requests(id) ON DELETE CASCADE,
    step_id UUID REFERENCES approval_matrix_steps(id),
    step_order INT,
    decision TEXT NOT NULL,
    -- approved, rejected, delegated
    comment TEXT,
    decided_by UUID REFERENCES auth.users(id),
    decided_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    delegated_to UUID REFERENCES auth.users(id),
    decision_context JSONB -- Device info, IP, etc.
);
-- 1.5 Approval Notifications
CREATE TABLE IF NOT EXISTS approval_notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id UUID REFERENCES approval_requests(id) ON DELETE CASCADE,
    recipient_id UUID REFERENCES auth.users(id),
    type TEXT NOT NULL,
    -- action_required, approved, rejected...
    title TEXT,
    body TEXT,
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
-- ==============================================================================
-- 2. Indexes & RLS
-- ==============================================================================
CREATE INDEX IF NOT EXISTS idx_approval_requests_status ON approval_requests(status);
CREATE INDEX IF NOT EXISTS idx_approval_requests_requested_by ON approval_requests(requested_by);
CREATE INDEX IF NOT EXISTS idx_approval_notifications_recipient ON approval_notifications(recipient_id);
-- Enable RLS
ALTER TABLE approval_matrices ENABLE ROW LEVEL SECURITY;
ALTER TABLE approval_matrix_steps ENABLE ROW LEVEL SECURITY;
ALTER TABLE approval_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE approval_decisions ENABLE ROW LEVEL SECURITY;
ALTER TABLE approval_notifications ENABLE ROW LEVEL SECURITY;
-- Policies (Simplified for initial setup, refine as needed)
-- Matrices: Read-only for most, Write for admins
CREATE POLICY "Read matrices" ON approval_matrices FOR
SELECT USING (true);
-- Requests: Requesters see their own, Approvers see what they need to approve (complex logic usually, simplified here)
-- Allowing authenticated read for now to unblock UI dev.
CREATE POLICY "Read requests" ON approval_requests FOR
SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Insert requests" ON approval_requests FOR
INSERT WITH CHECK (auth.uid() = requested_by);
CREATE POLICY "Update requests" ON approval_requests FOR
UPDATE USING (true);
-- Managed via RPC typically
-- Decisions:
CREATE POLICY "Read decisions" ON approval_decisions FOR
SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Insert decisions" ON approval_decisions FOR
INSERT WITH CHECK (auth.uid() = decided_by);
-- Notifications:
CREATE POLICY "Read own notifications" ON approval_notifications FOR
SELECT USING (auth.uid() = recipient_id);
-- ==============================================================================
-- 3. Seed Default Matrix
-- ==============================================================================
INSERT INTO approval_matrices (
        id,
        church_id,
        name,
        description,
        entity_type,
        is_active
    )
VALUES (
        '00000000-0000-0000-0000-000000000001',
        '00000000-0000-0000-0000-000000000000',
        -- Placeholder/Global
        'Transactions > 50k',
        'Validation financière standard',
        'transaction',
        true
    ) ON CONFLICT (id) DO NOTHING;
INSERT INTO approval_matrix_steps (
        matrix_id,
        step_order,
        step_label,
        approver_type,
        approver_role_codes,
        min_amount
    )
VALUES (
        '00000000-0000-0000-0000-000000000001',
        1,
        'Contrôle Trésorier',
        'role',
        ARRAY ['tresorier'],
        50000
    ),
    (
        '00000000-0000-0000-0000-000000000001',
        2,
        'Validation Président',
        'role',
        ARRAY ['president'],
        500000 -- Second step only if > 500k ? Or always? Spec says > 50k triggers workflow.
        -- Let's make step 1 always, step 2 if > 200k.
    );
-- ==============================================================================
-- 4. RPCs
-- ==============================================================================
-- 4.1 Create Approval Request
CREATE OR REPLACE FUNCTION create_approval_request(
        p_entity_type TEXT,
        p_entity_id UUID,
        p_entity_label TEXT,
        p_entity_amount NUMERIC,
        p_entity_data JSONB
    ) RETURNS UUID LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_matrix_id UUID;
v_request_id UUID;
v_total_steps INT;
BEGIN -- 1. Find matching matrix
SELECT id INTO v_matrix_id
FROM approval_matrices
WHERE entity_type = p_entity_type
    AND is_active = true
LIMIT 1;
IF v_matrix_id IS NULL THEN RETURN NULL;
-- No approval needed
END IF;
-- 2. Count steps
SELECT COUNT(*) INTO v_total_steps
FROM approval_matrix_steps
WHERE matrix_id = v_matrix_id;
-- 3. Create Request
INSERT INTO approval_requests (
        matrix_id,
        entity_type,
        entity_id,
        entity_label,
        entity_amount,
        entity_data,
        status,
        current_step_order,
        total_steps,
        requested_by
    )
VALUES (
        v_matrix_id,
        p_entity_type,
        p_entity_id,
        p_entity_label,
        p_entity_amount,
        p_entity_data,
        'pending',
        1,
        v_total_steps,
        auth.uid()
    )
RETURNING id INTO v_request_id;
-- 4. Notify first approvers (Simplified: creates notif logic would go here)
-- This is better handled via Trigger or specific notification service RPC.
RETURN v_request_id;
END;
$$;