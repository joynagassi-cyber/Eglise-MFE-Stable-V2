-- Migration: Audit Trail & Multi-Validation Workflow
-- Date: 2026-02-10
-- 1. Audit Logs Table (Generic for all modules)
CREATE TABLE IF NOT EXISTS audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    table_name TEXT NOT NULL,
    record_id UUID NOT NULL,
    action TEXT NOT NULL,
    -- INSERT, UPDATE, DELETE, VALIDATE, REJECT, SEAL
    changed_by UUID REFERENCES auth.users(id),
    changed_by_role TEXT,
    old_data JSONB,
    new_data JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
-- Enable RLS on audit_logs
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "SuperAdmins can view all audit logs" ON audit_logs FOR
SELECT USING (auth.jwt()->>'role' = 'super_admin');
-- 2. Approval Matrix / Requests
CREATE TABLE IF NOT EXISTS approval_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    transaction_id UUID REFERENCES transactions(id),
    requested_amount BIGINT NOT NULL,
    status TEXT DEFAULT 'pending',
    -- pending, partial, approved, rejected
    required_signatures INT DEFAULT 1,
    current_signatures INT DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS approval_signatures (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id UUID REFERENCES approval_requests(id),
    signed_by UUID REFERENCES auth.users(id),
    signed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    comment TEXT,
    UNIQUE(request_id, signed_by)
);
-- 3. Function to trigger audit on transaction changes
CREATE OR REPLACE FUNCTION audit_transaction_change() RETURNS TRIGGER AS $$ BEGIN
INSERT INTO audit_logs (
        table_name,
        record_id,
        action,
        changed_by,
        old_data,
        new_data
    )
VALUES (
        'transactions',
        COALESCE(NEW.id, OLD.id),
        TG_OP,
        auth.uid(),
        CASE
            WHEN TG_OP = 'DELETE' THEN to_jsonb(OLD)
            ELSE to_jsonb(OLD)
        END,
        CASE
            WHEN TG_OP = 'DELETE' THEN NULL
            ELSE to_jsonb(NEW)
        END
    );
RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- Trigger for transactions
-- DROP TRIGGER IF EXISTS trg_audit_transactions ON transactions;
-- CREATE TRIGGER trg_audit_transactions
-- AFTER INSERT OR UPDATE OR DELETE ON transactions
-- FOR EACH ROW EXECUTE FUNCTION audit_transaction_change();
-- 4. RPC for validating a transaction with audit
CREATE OR REPLACE FUNCTION validate_transaction(
        p_transaction_id UUID,
        p_comment TEXT DEFAULT NULL
    ) RETURNS VOID AS $$ BEGIN -- Update transaction status
UPDATE transactions
SET status = 'validated',
    updated_at = NOW()
WHERE id = p_transaction_id;
-- Record in audit log
INSERT INTO audit_logs (
        table_name,
        record_id,
        action,
        changed_by,
        old_data,
        new_data
    )
VALUES (
        'transactions',
        p_transaction_id,
        'VALIDATE',
        auth.uid(),
        NULL,
        jsonb_build_object('comment', p_comment, 'status', 'validated')
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;