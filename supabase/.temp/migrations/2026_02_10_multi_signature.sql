-- Migration: Multi-Signature Approval Logic
-- Date: 2026-02-10
-- 1. Configuration table for thresholds
CREATE TABLE IF NOT EXISTS validation_thresholds (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    min_amount BIGINT NOT NULL,
    required_signatures INT NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
-- Insert default thresholds (examples)
INSERT INTO validation_thresholds (min_amount, required_signatures, description)
VALUES (0, 1, 'Validation standard'),
    (10000000, 2, 'Validation double (> 100k XOF)'),
    -- amounts in cents
    (100000000, 3, 'Validation triple (> 1M XOF)');
-- 2. Function to sign and validate
CREATE OR REPLACE FUNCTION sign_transaction(
        p_transaction_id UUID,
        p_comment TEXT DEFAULT NULL
    ) RETURNS TABLE (
        status TEXT,
        signatures_needed INT,
        signatures_count INT
    ) AS $$
DECLARE v_amount BIGINT;
v_req_signs INT;
v_cur_signs INT;
v_req_id UUID;
BEGIN -- Get transaction amount
SELECT amount_bigint INTO v_amount
FROM transactions
WHERE id = p_transaction_id;
-- Get required signatures based on threshold
SELECT required_signatures INTO v_req_signs
FROM validation_thresholds
WHERE v_amount >= min_amount
ORDER BY min_amount DESC
LIMIT 1;
-- Ensure approval request exists
INSERT INTO approval_requests (
        transaction_id,
        requested_amount,
        required_signatures
    )
VALUES (p_transaction_id, v_amount, v_req_signs) ON CONFLICT (transaction_id) DO
UPDATE
SET required_signatures = v_req_signs
RETURNING id INTO v_req_id;
-- Add the signature
INSERT INTO approval_signatures (request_id, signed_by, comment)
VALUES (v_req_id, auth.uid(), p_comment) ON CONFLICT (request_id, signed_by) DO NOTHING;
-- Count current signatures
SELECT COUNT(*)::INT INTO v_cur_signs
FROM approval_signatures
WHERE request_id = v_req_id;
-- Update request status
IF v_cur_signs >= v_req_signs THEN
UPDATE approval_requests
SET status = 'approved',
    current_signatures = v_cur_signs
WHERE id = v_req_id;
UPDATE transactions
SET status = 'validated'
WHERE id = p_transaction_id;
-- Audit log for final validation
INSERT INTO audit_logs (
        table_name,
        record_id,
        action,
        changed_by,
        new_data
    )
VALUES (
        'transactions',
        p_transaction_id,
        'VALIDATE',
        auth.uid(),
        jsonb_build_object(
            'status',
            'validated',
            'all_signatures',
            v_cur_signs
        )
    );
ELSE
UPDATE approval_requests
SET status = 'partial',
    current_signatures = v_cur_signs
WHERE id = v_req_id;
-- Audit log for partial signature
INSERT INTO audit_logs (
        table_name,
        record_id,
        action,
        changed_by,
        new_data
    )
VALUES (
        'transactions',
        p_transaction_id,
        'PARTIAL_SIGN',
        auth.uid(),
        jsonb_build_object(
            'signature_count',
            v_cur_signs,
            'required',
            v_req_signs
        )
    );
END IF;
RETURN QUERY
SELECT CASE
        WHEN v_cur_signs >= v_req_signs THEN 'approved'::TEXT
        ELSE 'partial'::TEXT
    END,
    v_req_signs - v_cur_signs,
    v_cur_signs;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;