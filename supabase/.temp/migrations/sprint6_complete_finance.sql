-- Migration Sprint 6: Module Finances Complet (Corrected Table Names)
-- 1. Évolution de la table finance_transactions
ALTER TABLE finance_transactions
ADD COLUMN IF NOT EXISTS currency TEXT DEFAULT 'XAF',
    ADD COLUMN IF NOT EXISTS exchange_rate DECIMAL(18, 10) DEFAULT 1.0,
    ADD COLUMN IF NOT EXISTS amount_base_currency DECIMAL(18, 2),
    ADD COLUMN IF NOT EXISTS reference_number TEXT,
    ADD COLUMN IF NOT EXISTS notes TEXT,
    ADD COLUMN IF NOT EXISTS tags TEXT [],
    ADD COLUMN IF NOT EXISTS attachments JSONB DEFAULT '[]'::jsonb,
    ADD COLUMN IF NOT EXISTS approved_by UUID REFERENCES auth.users(id),
    ADD COLUMN IF NOT EXISTS approved_at TIMESTAMPTZ;
-- 2. Évolution de la table transaction_categories
ALTER TABLE transaction_categories
ADD COLUMN IF NOT EXISTS parent_id TEXT REFERENCES transaction_categories(id),
    -- Note: id is text in this schema
ADD COLUMN IF NOT EXISTS code TEXT,
    ADD COLUMN IF NOT EXISTS display_order INTEGER DEFAULT 0,
    ADD COLUMN IF NOT EXISTS icon TEXT,
    ADD COLUMN IF NOT EXISTS color TEXT,
    ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;
-- 3. Évolution de la table budgets
ALTER TABLE budgets
ADD COLUMN IF NOT EXISTS fiscal_year INTEGER,
    ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'active';
-- 4. Création de la table bank_accounts (Alternative to financial_accounts if needed, or evolve financial_accounts)
-- The schema already has financial_accounts, let's evolve it
ALTER TABLE financial_accounts
ADD COLUMN IF NOT EXISTS bank_name TEXT,
    ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;
-- 5. Création de la table bank_reconciliations
CREATE TABLE IF NOT EXISTS bank_reconciliations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    bank_account_id TEXT NOT NULL REFERENCES financial_accounts(id) ON DELETE CASCADE,
    reconciliation_date DATE NOT NULL,
    statement_balance DECIMAL(18, 2) NOT NULL,
    book_balance DECIMAL(18, 2) NOT NULL,
    difference DECIMAL(18, 2) NOT NULL,
    status TEXT DEFAULT 'pending',
    -- pending, completed
    reconciled_by UUID REFERENCES auth.users(id),
    created_at TIMESTAMPTZ DEFAULT now()
);
-- 6. Table de liaison pour le pointage des transactions
CREATE TABLE IF NOT EXISTS reconciliation_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    reconciliation_id UUID NOT NULL REFERENCES bank_reconciliations(id) ON DELETE CASCADE,
    transaction_id TEXT NOT NULL REFERENCES finance_transactions(id) ON DELETE CASCADE,
    is_matched BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now()
);
-- 7. Activation RLS
ALTER TABLE bank_reconciliations ENABLE ROW LEVEL SECURITY;
ALTER TABLE reconciliation_items ENABLE ROW LEVEL SECURITY;
-- 8. RLS Policies
DO $$ BEGIN IF NOT EXISTS (
    SELECT 1
    FROM pg_policies
    WHERE policyname = 'Users can view bank reconciliations'
) THEN CREATE POLICY "Users can view bank reconciliations" ON bank_reconciliations FOR
SELECT USING (
        bank_account_id IN (
            SELECT id
            FROM financial_accounts
            WHERE church_id IN (
                    SELECT group_id
                    FROM group_members
                    WHERE user_id = auth.uid()
                )
        )
    );
END IF;
END $$;