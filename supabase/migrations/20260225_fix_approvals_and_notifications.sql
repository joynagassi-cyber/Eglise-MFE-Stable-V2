-- ═══════════════════════════════════════════════════════════════════════════════
-- Migration: 20260225_fix_approvals_and_notifications.sql (v4: Force Redefine)
-- Date: 2026-02-25
-- Purpose: Implement missing RPCs and automate notifications for approvals & audit
-- ═══════════════════════════════════════════════════════════════════════════════
-- 1. Progressively drop functions to avoid return type conflicts
DROP FUNCTION IF EXISTS public.submit_approval_decision(UUID, TEXT, TEXT);
DROP FUNCTION IF EXISTS public.get_my_pending_approvals();
DROP FUNCTION IF EXISTS public.create_approval_request(TEXT, UUID, TEXT, NUMERIC, JSONB);
DROP FUNCTION IF EXISTS public.create_approval_request(TEXT, UUID, UUID, UUID [], JSONB);
-- Handle previous skeleton signature
-- 2. Table Evolution for Approval Requests
ALTER TABLE public.approval_requests
ADD COLUMN IF NOT EXISTS entity_type TEXT,
    ADD COLUMN IF NOT EXISTS entity_label TEXT,
    ADD COLUMN IF NOT EXISTS entity_amount NUMERIC(18, 2);
-- 3. Ensure Table Consistency for Notifications
ALTER TABLE public.notifications
ADD COLUMN IF NOT EXISTS link_url TEXT,
    ADD COLUMN IF NOT EXISTS payload JSONB DEFAULT '{}'::jsonb,
    ADD COLUMN IF NOT EXISTS priority TEXT DEFAULT 'NORMAL';
-- 4. Implement submit_approval_decision RPC
CREATE OR REPLACE FUNCTION public.submit_approval_decision(
        p_request_id UUID,
        p_decision TEXT,
        -- 'approved' or 'rejected'
        p_comment TEXT DEFAULT NULL
    ) RETURNS VOID AS $$
DECLARE v_request RECORD;
BEGIN
SELECT ar.* INTO v_request
FROM approval_requests ar
WHERE ar.id = p_request_id;
IF NOT FOUND THEN RAISE EXCEPTION 'Approval request not found';
END IF;
IF v_request.status != 'pending' THEN RAISE EXCEPTION 'Request is already processed';
END IF;
INSERT INTO approval_decisions (
        request_id,
        step_id,
        decider_id,
        decision,
        comment
    )
VALUES (
        p_request_id,
        v_request.current_step_id,
        auth.uid(),
        p_decision,
        p_comment
    );
UPDATE approval_requests
SET status = p_decision,
    updated_at = NOW()
WHERE id = p_request_id;
INSERT INTO notifications (user_id, title, message, type, link_url, payload)
VALUES (
        v_request.requested_by,
        'Décision d''approbation',
        'Votre demande ' || COALESCE(v_request.entity_label, '') || ' a été ' || CASE
            WHEN p_decision = 'approved' THEN 'approuvée.'
            ELSE 'rejetée.'
        END,
        'APPROVAL_RESULT',
        '/approvals/' || p_request_id,
        jsonb_build_object('request_id', p_request_id, 'status', p_decision)
    );
INSERT INTO audit_logs (
        table_name,
        record_id,
        action,
        changed_by,
        new_data
    )
VALUES (
        'approval_requests',
        p_request_id,
        'DECISION_' || UPPER(p_decision),
        auth.uid(),
        jsonb_build_object(
            'comment',
            p_comment,
            'step_id',
            v_request.current_step_id
        )
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- 5. Implement get_my_pending_approvals RPC
-- Returning a table shape that matches Flutter expectations exactly
CREATE OR REPLACE FUNCTION public.get_my_pending_approvals() RETURNS TABLE (
        request_id UUID,
        entity_type TEXT,
        entity_id UUID,
        entity_label TEXT,
        entity_amount NUMERIC(18, 2),
        requested_at TIMESTAMPTZ,
        status TEXT,
        current_step_order INT,
        total_steps INT
    ) AS $$ BEGIN RETURN QUERY
SELECT ar.id,
    ar.entity_type,
    ar.entity_id,
    ar.entity_label,
    ar.entity_amount,
    ar.created_at,
    ar.status,
    ams.step_order,
    (
        SELECT COUNT(*)::INT
        FROM approval_matrix_steps
        WHERE matrix_id = ar.matrix_id
    )
FROM approval_requests ar
    JOIN approval_matrix_steps ams ON ar.current_step_id = ams.id
    JOIN user_roles ur ON ur.user_id = auth.uid()
    JOIN roles r ON ur.role_id = r.id
WHERE ar.status = 'pending'
    AND r.name = ams.approver_role
    AND ur.is_active = true
    AND ur.church_id = ar.church_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;
-- 6. Implement create_approval_request RPC
CREATE OR REPLACE FUNCTION public.create_approval_request(
        p_entity_type TEXT,
        p_entity_id UUID,
        p_entity_label TEXT,
        p_entity_amount NUMERIC,
        p_entity_data JSONB DEFAULT '{}'
    ) RETURNS UUID AS $$
DECLARE v_matrix_id UUID;
v_first_step_id UUID;
v_request_id UUID;
v_church_id UUID;
v_approver_role TEXT;
BEGIN
SELECT id,
    church_id INTO v_matrix_id,
    v_church_id
FROM approval_matrices
WHERE name = p_entity_type;
IF NOT FOUND THEN
SELECT id,
    church_id INTO v_matrix_id,
    v_church_id
FROM approval_matrices
LIMIT 1;
IF NOT FOUND THEN RAISE EXCEPTION 'No approval matrix found';
END IF;
END IF;
SELECT id,
    approver_role INTO v_first_step_id,
    v_approver_role
FROM approval_matrix_steps
WHERE matrix_id = v_matrix_id
ORDER BY step_order ASC
LIMIT 1;
INSERT INTO approval_requests (
        matrix_id,
        church_id,
        entity_type,
        entity_id,
        entity_label,
        entity_amount,
        requested_by,
        current_step_id,
        status,
        metadata
    )
VALUES (
        v_matrix_id,
        v_church_id,
        p_entity_type,
        p_entity_id,
        p_entity_label,
        p_entity_amount,
        auth.uid(),
        v_first_step_id,
        'pending',
        p_entity_data
    )
RETURNING id INTO v_request_id;
INSERT INTO notifications (user_id, title, message, type, link_url, payload)
SELECT ur.user_id,
    'Approbaton requise',
    'Action requise pour ' || p_entity_label,
    'APPROVAL_REQUEST',
    '/approvals/' || v_request_id,
    jsonb_build_object('request_id', v_request_id)
FROM user_roles ur
    JOIN roles r ON ur.role_id = r.id
WHERE r.name = v_approver_role
    AND ur.church_id = v_church_id
    AND ur.is_active = true;
INSERT INTO audit_logs (
        table_name,
        record_id,
        action,
        changed_by,
        new_data
    )
VALUES (
        'approval_requests',
        v_request_id,
        'CREATE',
        auth.uid(),
        p_entity_data
    );
RETURN v_request_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- 7. Finalize Audit Triggers
DO $$ BEGIN IF NOT EXISTS (
    SELECT 1
    FROM pg_trigger
    WHERE tgname = 'trg_audit_transactions'
) THEN CREATE TRIGGER trg_audit_transactions
AFTER
INSERT
    OR
UPDATE
    OR DELETE ON transactions FOR EACH ROW EXECUTE FUNCTION audit_transaction_change();
END IF;
END $$;