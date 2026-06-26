-- Migration: Automated Balance Updates
-- Description: Updates financial_accounts.balance based on finance_transactions activity.

-- 1. Create the function to handle balance updates
CREATE OR REPLACE FUNCTION public.fn_update_financial_account_balance()
RETURNS TRIGGER AS $$
DECLARE
    v_old_impact NUMERIC := 0;
    v_new_impact NUMERIC := 0;
BEGIN
    -- HELPER: Calculate impact of a transaction record
    -- Returns positive for addition to balance, negative for subtraction
    
    -- OLD Record Impact
    IF (TG_OP = 'UPDATE' OR TG_OP = 'DELETE') THEN
        IF (OLD.type = 'income' AND OLD.status IN ('PENDING_VALIDATION', 'VALIDATED', 'SEALED', 'ARCHIVED')) THEN
            v_old_impact := OLD.amount;
        ELSIF (OLD.type = 'expense' AND OLD.status IN ('VALIDATED', 'SEALED', 'ARCHIVED')) THEN
            v_old_impact := -OLD.amount;
        END IF;
    END IF;

    -- NEW Record Impact
    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
        IF (NEW.type = 'income' AND NEW.status IN ('PENDING_VALIDATION', 'VALIDATED', 'SEALED', 'ARCHIVED')) THEN
            v_new_impact := NEW.amount;
        ELSIF (NEW.type = 'expense' AND NEW.status IN ('VALIDATED', 'SEALED', 'ARCHIVED')) THEN
            v_new_impact := -NEW.amount;
        END IF;
    END IF;

    -- Apply changes to accounts
    IF (TG_OP = 'INSERT') THEN
        IF v_new_impact != 0 THEN
            UPDATE public.financial_accounts 
            SET balance = balance + v_new_impact,
                updated_at = NOW()
            WHERE id = NEW.account_id;
        END IF;

    ELSIF (TG_OP = 'DELETE') THEN
        IF v_old_impact != 0 THEN
            UPDATE public.financial_accounts 
            SET balance = balance - v_old_impact,
                updated_at = NOW()
            WHERE id = OLD.account_id;
        END IF;

    ELSIF (TG_OP = 'UPDATE') THEN
        -- If account changed, handle both
        IF OLD.account_id != NEW.account_id THEN
            -- Remove old impact from old account
            IF v_old_impact != 0 THEN
                UPDATE public.financial_accounts 
                SET balance = balance - v_old_impact,
                    updated_at = NOW()
                WHERE id = OLD.account_id;
            END IF;
            -- Add new impact to new account
            IF v_new_impact != 0 THEN
                UPDATE public.financial_accounts 
                SET balance = balance + v_new_impact,
                    updated_at = NOW()
                WHERE id = NEW.account_id;
            END IF;
        ELSE
            -- Same account, apply delta
            IF (v_new_impact - v_old_impact) != 0 THEN
                UPDATE public.financial_accounts 
                SET balance = balance + (v_new_impact - v_old_impact),
                    updated_at = NOW()
                WHERE id = NEW.account_id;
            END IF;
        END IF;
    END IF;

    RETURN NULL; -- result is ignored since this is an AFTER trigger
END;
$$ LANGUAGE plpgsql;

-- 2. Create the trigger
DROP TRIGGER IF EXISTS tr_finance_transactions_balance_update ON public.finance_transactions;
CREATE TRIGGER tr_finance_transactions_balance_update
AFTER INSERT OR UPDATE OR DELETE ON public.finance_transactions
FOR EACH ROW EXECUTE FUNCTION public.fn_update_financial_account_balance();

-- 3. Fix existing RPC function to use correct enum values
CREATE OR REPLACE FUNCTION public.fn_quarterly_transfer_funds(
    p_from_account_id TEXT,
    p_to_account_id TEXT,
    p_amount NUMERIC,
    p_notes TEXT DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
    v_transaction_id UUID;
BEGIN
    IF (SELECT balance FROM financial_accounts WHERE id = p_from_account_id) < p_amount THEN
        RAISE EXCEPTION 'Solde insuffisant dans la caisse de groupe.';
    END IF;

    -- Expense from Group (Status VALIDATED instead of 'approved')
    INSERT INTO finance_transactions (
        type, 
        amount, 
        account_id, 
        description, 
        date, 
        status, 
        notes
    ) VALUES (
        'expense',
        p_amount,
        p_from_account_id,
        'Transfert vers Caisse Générale',
        CURRENT_DATE,
        'VALIDATED'::transaction_status,
        p_notes
    ) RETURNING (id::uuid) INTO v_transaction_id;

    -- Income to Main (Status VALIDATED instead of 'approved')
    INSERT INTO finance_transactions (
        type, 
        amount, 
        account_id, 
        description, 
        date, 
        status, 
        notes
    ) VALUES (
        'income',
        p_amount,
        p_to_account_id,
        'Transfert depuis Caisse de Groupe',
        CURRENT_DATE,
        'VALIDATED'::transaction_status,
        p_notes
    );

    RETURN v_transaction_id;
END;
$$ LANGUAGE plpgsql;
