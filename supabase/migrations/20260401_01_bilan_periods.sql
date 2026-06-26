-- 20260401_bilan_periods.sql
-- Description: Creates the bilan_periods table, its RLS policies, and the seal_period RPC
-- Author: Antigravity

CREATE TABLE IF NOT EXISTS bilan_periods (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  church_id TEXT NOT NULL REFERENCES churches(id),
  year INT NOT NULL,
  month INT NOT NULL CHECK (month BETWEEN 1 AND 12),
  status TEXT NOT NULL DEFAULT 'open'
    CHECK (status IN ('open','pending_review','sealed','archived')),
  sealed_at TIMESTAMPTZ,
  sealed_by UUID REFERENCES auth.users(id),
  seal_hash TEXT,
  total_income NUMERIC(15,2) DEFAULT 0,
  total_expense NUMERIC(15,2) DEFAULT 0,
  net_balance NUMERIC(15,2) DEFAULT 0,
  category_breakdown JSONB DEFAULT '{}',
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(church_id, year, month)
);

ALTER TABLE bilan_periods ENABLE ROW LEVEL SECURITY;

-- Ensure pgcrypto is enabled for digest()
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- RLS: Lecture pour tous les membres de l'église
CREATE POLICY bilan_periods_read ON bilan_periods
  FOR SELECT USING (
    church_id IN (SELECT church_id FROM church_members WHERE user_id = auth.uid())
  );

-- RLS: Écriture pour admin/tresorier et superadmin
CREATE POLICY bilan_periods_write ON bilan_periods
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM church_members
      WHERE user_id = auth.uid()
        AND church_id = bilan_periods.church_id
        AND role IN ('admin', 'tresorier', 'superadmin')
    )
  );

-- RPC: seal_period
-- Computes the totals from finance_transactions and upserts into bilan_periods
CREATE OR REPLACE FUNCTION seal_period(
  p_church_id TEXT,
  p_year INT,
  p_month INT,
  p_sealed_by UUID
) RETURNS JSONB AS $$
DECLARE
  v_totals RECORD;
  v_hash TEXT;
  v_breakdown JSONB;
BEGIN
  -- Calculer les totaux du mois
  SELECT
    COALESCE(SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END), 0) as total_income,
    COALESCE(SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END), 0) as total_expense,
    COUNT(*) as tx_count
  INTO v_totals
  FROM finance_transactions
  WHERE church_id = p_church_id
    AND EXTRACT(YEAR FROM date) = p_year
    AND EXTRACT(MONTH FROM date) = p_month
    AND status != 'draft';

  -- Calculer le breakdown par catégorie
  SELECT jsonb_object_agg(category_name, cat_total) INTO v_breakdown
  FROM (
    SELECT category_name, SUM(amount) as cat_total
    FROM finance_transactions
    WHERE church_id = p_church_id
      AND EXTRACT(YEAR FROM date) = p_year
      AND EXTRACT(MONTH FROM date) = p_month
      AND status != 'draft'
    GROUP BY category_name
  ) sub;

  -- Générer le hash de scellage (SHA-256)
  v_hash := encode(
    digest(
      p_church_id::text || p_year::text || p_month::text
        || v_totals.total_income::text || v_totals.total_expense::text
        || now()::text,
      'sha256'
    ),
    'hex'
  );

  -- Upsert bilan_periods
  INSERT INTO bilan_periods (church_id, year, month, status, sealed_at, sealed_by, seal_hash, total_income, total_expense, net_balance, category_breakdown)
  VALUES (
    p_church_id, 
    p_year, 
    p_month, 
    'sealed', 
    now(), 
    p_sealed_by, 
    v_hash, 
    v_totals.total_income, 
    v_totals.total_expense, 
    v_totals.total_income - v_totals.total_expense, 
    COALESCE(v_breakdown, '{}'::jsonb)
  )
  ON CONFLICT (church_id, year, month)
  DO UPDATE SET
    status = 'sealed',
    sealed_at = now(),
    sealed_by = p_sealed_by,
    seal_hash = v_hash,
    total_income = v_totals.total_income,
    total_expense = v_totals.total_expense,
    net_balance = v_totals.total_income - v_totals.total_expense,
    category_breakdown = COALESCE(v_breakdown, '{}'::jsonb),
    updated_at = now();

  RETURN jsonb_build_object(
    'status', 'sealed',
    'hash', v_hash,
    'total_income', v_totals.total_income,
    'total_expense', v_totals.total_expense,
    'tx_count', v_totals.tx_count
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
