-- Migration: Group Finance & Audit Evolution
-- Description: Adds group accounts support, quarterly transfer logic, and enhanced audit logging.
-- 1. Evolve financial_accounts to support Groups
ALTER TABLE IF EXISTS financial_accounts
ADD COLUMN IF NOT EXISTS group_id TEXT REFERENCES groups(id);
-- Add index for performance on group filtering
CREATE INDEX IF NOT EXISTS idx_financial_accounts_group_id ON financial_accounts(group_id);
-- 2. Quarterly Transfer Function (Bilan Trimestriel)
-- Allows transferring funds from group petty cash to main church accounts
CREATE OR REPLACE FUNCTION fn_quarterly_transfer_funds(
        p_from_account_id TEXT,
        p_to_account_id TEXT,
        p_amount DECIMAL(15, 2),
        p_notes TEXT DEFAULT 'Bilan Trimestriel - Transfert vers Caisse Générale'
    ) RETURNS UUID AS $$
DECLARE v_last_transfer TIMESTAMPTZ;
v_transaction_id UUID;
BEGIN -- Security check: Ensure we are in a new quarter (Optional or based on status)
-- For now, we allow the admin to decide, but we log it as a special type.
-- 1. Verify source account has enough funds
IF (
    SELECT balance
    FROM financial_accounts
    WHERE id = p_from_account_id
) < p_amount THEN RAISE EXCEPTION 'Solde insuffisant dans la caisse de groupe.';
END IF;
-- 2. Create the Expense transaction in Group Account
INSERT INTO finance_transactions (
        type,
        amount,
        account_id,
        description,
        date,
        status,
        is_internal_transfer,
        notes
    )
VALUES (
        'expense',
        p_amount,
        p_from_account_id,
        p_notes,
        CURRENT_DATE,
        'approved',
        TRUE,
        'Transfert sortant vers' || p_to_account_id
    )
RETURNING id::uuid INTO v_transaction_id;
-- 3. Create the Income transaction in Target Account (Main Church)
INSERT INTO finance_transactions (
        type,
        amount,
        account_id,
        description,
        date,
        status,
        is_internal_transfer,
        notes
    )
VALUES (
        'income',
        p_amount,
        p_to_account_id,
        p_notes,
        CURRENT_DATE,
        'approved',
        TRUE,
        'Transfert entrant depuis' || p_from_account_id
    );
-- The trigger (fn_update_bank_account_balance) will handle the balance updates automatically
RETURN v_transaction_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- 3. Action History View (Optional, as audit_logs table exists)
-- This view simplifies the "Action History" for the UI
CREATE OR REPLACE VIEW public.vw_action_history AS
SELECT al.id,
    al.occurred_at as date,
    p.name as actor_name,
    al.role_used as actor_role,
    al.action,
    al.entity_type,
    al.metadata->>'church_id' as church_id,
    al.metadata->>'dashboard_source' as dashboard_source,
    al.new_data as details
FROM audit_logs al
    LEFT JOIN profiles p ON al.actor_id = p.id;
-- 4. RLS Policies for Group Isolation
-- Ensure leaders only see their group account
ALTER TABLE financial_accounts ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Group Leaders can see their group accounts" ON financial_accounts;
CREATE POLICY "Group Leaders can see their group accounts" ON financial_accounts FOR ALL USING (
    group_id IN (
        SELECT active_group_id
        FROM user_sessions
        WHERE user_id = auth.uid()
    )
    OR (
        SELECT is_super
        FROM roles r
            JOIN user_roles ur ON r.id = ur.role_id
        WHERE ur.user_id = auth.uid()
        LIMIT 1
    ) = TRUE
);