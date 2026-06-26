-- Migration: Report Sealing & Snapshots
-- Date: 2026-02-10
-- 1. Table for Report Snapshots (Immutable record of a BILAN)
CREATE TABLE IF NOT EXISTS report_snapshots (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    report_id UUID REFERENCES reports(id),
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    data JSONB NOT NULL,
    -- Full aggregate data at the time of sealing
    signature TEXT NOT NULL,
    -- SHA-256 or ECDSA hash/signature
    sealed_by UUID REFERENCES auth.users(id),
    sealed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
-- 2. Function to close and seal a period
CREATE OR REPLACE FUNCTION seal_bilan_period(
        p_start_date DATE,
        p_end_date DATE,
        p_data JSONB,
        p_signature TEXT
    ) RETURNS UUID AS $$
DECLARE v_report_id UUID;
v_snapshot_id UUID;
BEGIN -- 1. Create a report record if not exists or link to one
INSERT INTO reports (type, status, created_by)
VALUES ('bilan_consolidated', 'sealed', auth.uid())
RETURNING id INTO v_report_id;
-- 2. Create the snapshot
INSERT INTO report_snapshots (
        report_id,
        period_start,
        period_end,
        data,
        signature,
        sealed_by
    )
VALUES (
        v_report_id,
        p_start_date,
        p_end_date,
        p_data,
        p_signature,
        auth.uid()
    )
RETURNING id INTO v_snapshot_id;
-- 3. Lock transactions in this period (optional - prevents editing)
-- UPDATE transactions SET status = 'sealed' 
-- WHERE date BETWEEN p_start_date AND p_end_date AND status = 'validated';
-- 4. Audit
INSERT INTO audit_logs (
        table_name,
        record_id,
        action,
        changed_by,
        new_data
    )
VALUES (
        'reports',
        v_report_id,
        'SEAL',
        auth.uid(),
        jsonb_build_object('snapshot_id', v_snapshot_id)
    );
RETURN v_report_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;