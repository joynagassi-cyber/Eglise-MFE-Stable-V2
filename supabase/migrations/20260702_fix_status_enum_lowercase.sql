-- Migration: Fix Status Enum Lowercase
-- Description: Corrige le mapping de statut dans les fonctions trigger/RPC
-- pour utiliser les valeurs lowercase attendues par _$TransactionStatusEnumMap (freezed Dart)
--
-- Contexte: L'enum Dart TransactionStatus est sérialisé par freezed en lowercase
-- ('pending', 'validated', 'sealed', 'archived'), mais les fonctions utilisaient
-- des valeurs uppercase ('PENDING_VALIDATION', 'VALIDATED', 'SEALED', 'ARCHIVED').
-- Résultat: le trigger de mise à jour automatique du solde ne matchait jamais.

-- 1. Trigger function: fn_update_financial_account_balance
CREATE OR REPLACE FUNCTION public.fn_update_financial_account_balance()
RETURNS TRIGGER AS $$
DECLARE
    v_old_impact NUMERIC := 0;
    v_new_impact NUMERIC := 0;
BEGIN
    -- OLD Record Impact
    IF (TG_OP = 'UPDATE' OR TG_OP = 'DELETE') THEN
        IF (OLD.type = 'income' AND OLD.status IN ('pending', 'validated', 'sealed', 'archived')) THEN
            v_old_impact := OLD.amount;
        ELSIF (OLD.type = 'expense' AND OLD.status IN ('validated', 'sealed', 'archived')) THEN
            v_old_impact := -OLD.amount;
        END IF;
    END IF;

    -- NEW Record Impact
    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
        IF (NEW.type = 'income' AND NEW.status IN ('pending', 'validated', 'sealed', 'archived')) THEN
            v_new_impact := NEW.amount;
        ELSIF (NEW.type = 'expense' AND NEW.status IN ('validated', 'sealed', 'archived')) THEN
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
        IF OLD.account_id != NEW.account_id THEN
            IF v_old_impact != 0 THEN
                UPDATE public.financial_accounts 
                SET balance = balance - v_old_impact,
                    updated_at = NOW()
                WHERE id = OLD.account_id;
            END IF;
            IF v_new_impact != 0 THEN
                UPDATE public.financial_accounts 
                SET balance = balance + v_new_impact,
                    updated_at = NOW()
                WHERE id = NEW.account_id;
            END IF;
        ELSE
            IF (v_new_impact - v_old_impact) != 0 THEN
                UPDATE public.financial_accounts 
                SET balance = balance + (v_new_impact - v_old_impact),
                    updated_at = NOW()
                WHERE id = NEW.account_id;
            END IF;
        END IF;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


-- 2. RPC function: fn_quarterly_transfer_funds
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

    INSERT INTO finance_transactions (
        type, amount, account_id, description, date, status, notes
    ) VALUES (
        'expense',
        p_amount,
        p_from_account_id,
        'Transfert vers Caisse Générale',
        CURRENT_DATE,
        'validated'::transaction_status,
        p_notes
    ) RETURNING (id::uuid) INTO v_transaction_id;

    INSERT INTO finance_transactions (
        type, amount, account_id, description, date, status, notes
    ) VALUES (
        'income',
        p_amount,
        p_to_account_id,
        'Transfert depuis Caisse de Groupe',
        CURRENT_DATE,
        'validated'::transaction_status,
        p_notes
    );

    RETURN v_transaction_id;
END;
$$ LANGUAGE plpgsql;


-- 3. Dashboard RPC: get_finance_evolution_12m
CREATE OR REPLACE FUNCTION public.get_finance_evolution_12m(p_church_id UUID DEFAULT NULL)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    result json;
BEGIN
    WITH months AS (
        SELECT date_trunc('month', CURRENT_DATE - interval '1 month' * s.a) AS month_date
        FROM generate_series(0, 11) AS s(a)
    ),
    monthly_finance AS (
        SELECT 
            date_trunc('month', ft.date) AS month_date,
            SUM(CASE WHEN ft.type = 'income' THEN ft.amount ELSE 0 END) AS revenue,
            SUM(CASE WHEN ft.type = 'expense' THEN ft.amount ELSE 0 END) AS expense
        FROM public.finance_transactions ft
        WHERE ft.status IN ('validated', 'sealed', 'archived')
        AND ft.date >= date_trunc('month', CURRENT_DATE - interval '11 months')
        GROUP BY 1
    )
    SELECT json_agg(
        json_build_object(
            'month', to_char(m.month_date, 'YYYY-MM-DD"T"HH24:MI:SS"Z"'),
            'revenue', COALESCE(mf.revenue, 0),
            'expense', COALESCE(mf.expense, 0)
        )
    ) INTO result
    FROM months m
    LEFT JOIN monthly_finance mf ON m.month_date = mf.month_date;

    RETURN COALESCE(result, '[]'::json);
END;
$$;
