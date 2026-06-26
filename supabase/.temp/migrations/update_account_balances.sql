-- Migration: Automatic Account Balance Update
-- Description: Updates the 'balance' of a bank account whenever a transaction is inserted, updated, or deleted.
-- 1. Function to calculate and update the balance
CREATE OR REPLACE FUNCTION fn_update_bank_account_balance() RETURNS TRIGGER AS $$
DECLARE v_account_id UUID;
v_total_balance DECIMAL(15, 2);
v_initial_balance DECIMAL(15, 2);
BEGIN -- Determine which account to update
IF (TG_OP = 'DELETE') THEN v_account_id := OLD.account_id;
ELSE v_account_id := NEW.account_id;
END IF;
IF v_account_id IS NULL THEN RETURN NULL;
END IF;
-- Get initial balance
SELECT initial_balance INTO v_initial_balance
FROM bank_accounts
WHERE id = v_account_id;
-- Calculate total from transactions
SELECT COALESCE(
        SUM(
            CASE
                WHEN type = 'income' THEN amount
                WHEN type = 'tithe' THEN amount
                WHEN type = 'offering' THEN amount
                WHEN type = 'expense' THEN - amount
                ELSE 0
            END
        ),
        0
    ) INTO v_total_balance
FROM finance_transactions -- Note: using the correct table name from Flutter implementation
WHERE account_id = v_account_id;
-- Update the account balance
UPDATE bank_accounts
SET balance = v_initial_balance + v_total_balance,
    updated_at = NOW()
WHERE id = v_account_id;
-- If it's an UPDATE and the account_id changed, update the OLD account too
IF (
    TG_OP = 'UPDATE'
    AND OLD.account_id IS DISTINCT
    FROM NEW.account_id
) THEN -- Recalculate for OLD account
SELECT initial_balance INTO v_initial_balance
FROM bank_accounts
WHERE id = OLD.account_id;
SELECT COALESCE(
        SUM(
            CASE
                WHEN type IN ('income', 'tithe', 'offering') THEN amount
                ELSE - amount
            END
        ),
        0
    ) INTO v_total_balance
FROM finance_transactions
WHERE account_id = OLD.account_id;
UPDATE bank_accounts
SET balance = v_initial_balance + v_total_balance,
    updated_at = NOW()
WHERE id = OLD.account_id;
END IF;
RETURN NULL;
-- result is ignored since this is an AFTER trigger
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- 2. Create the Trigger
DROP TRIGGER IF EXISTS trg_update_bank_balance ON finance_transactions;
CREATE TRIGGER trg_update_bank_balance
AFTER
INSERT
    OR
UPDATE
    OR DELETE ON finance_transactions FOR EACH ROW EXECUTE FUNCTION fn_update_bank_account_balance();
-- 3. Initial Sync (Optional: recalculate all existing balances)
-- UPDATE bank_accounts ba
-- SET balance = initial_balance + (
--     SELECT COALESCE(SUM(CASE WHEN type IN ('income', 'tithe', 'offering') THEN amount ELSE -amount END), 0)
--     FROM finance_transactions
--     WHERE account_id = ba.id
-- );