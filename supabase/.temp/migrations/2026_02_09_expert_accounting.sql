-- Migration: Expert Accounting & BILAN Dashboard
-- Date: 2026-02-09
-- 1. Function to get BILAN summary per group
CREATE OR REPLACE FUNCTION bilan_per_group(
        p_start_date DATE,
        p_end_date DATE,
        p_include_drafts BOOLEAN DEFAULT FALSE,
        p_exclude_internal BOOLEAN DEFAULT TRUE
    ) RETURNS TABLE (
        group_id UUID,
        group_name TEXT,
        income BIGINT,
        expense BIGINT,
        net BIGINT,
        tx_count INT
    ) AS $$ BEGIN RETURN QUERY
SELECT g.id as group_id,
    g.name as group_name,
    COALESCE(
        SUM(
            CASE
                WHEN t.type = 'income' THEN t.amount_bigint
                ELSE 0
            END
        ),
        0
    ) as income,
    COALESCE(
        SUM(
            CASE
                WHEN t.type = 'expense' THEN t.amount_bigint
                ELSE 0
            END
        ),
        0
    ) as expense,
    COALESCE(
        SUM(
            CASE
                WHEN t.type = 'income' THEN t.amount_bigint
                ELSE - t.amount_bigint
            END
        ),
        0
    ) as net,
    COUNT(t.id)::INT as tx_count
FROM groups g
    LEFT JOIN transactions t ON t.group_id = g.id
    AND t.date BETWEEN p_start_date AND p_end_date
    AND (
        p_include_drafts
        OR t.status = 'validated'
    )
    AND (
        NOT p_exclude_internal
        OR NOT t.is_internal_transfer
    )
GROUP BY g.id,
    g.name;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- 2. Function for consolidated BILAN (eliminating internal transfers)
CREATE OR REPLACE FUNCTION consolidated_bilan(
        p_start_date DATE,
        p_end_date DATE,
        p_group_ids UUID [] DEFAULT NULL
    ) RETURNS TABLE (
        total_income BIGINT,
        total_expense BIGINT,
        net_balance BIGINT,
        internal_eliminated BIGINT,
        tx_count INT
    ) AS $$
DECLARE v_internal_sum BIGINT;
BEGIN -- Sum of internal transfers (eliminated to avoid double counting)
SELECT COALESCE(SUM(amount_bigint), 0) INTO v_internal_sum
FROM transactions
WHERE date BETWEEN p_start_date AND p_end_date
    AND is_internal_transfer = TRUE
    AND status = 'validated'
    AND (
        p_group_ids IS NULL
        OR group_id = ANY(p_group_ids)
    );
RETURN QUERY
SELECT COALESCE(
        SUM(
            CASE
                WHEN type = 'income' THEN amount_bigint
                ELSE 0
            END
        ),
        0
    ) - v_internal_sum as total_income,
    COALESCE(
        SUM(
            CASE
                WHEN type = 'expense' THEN amount_bigint
                ELSE 0
            END
        ),
        0
    ) - v_internal_sum as total_expense,
    COALESCE(
        SUM(
            CASE
                WHEN type = 'income' THEN amount_bigint
                ELSE - amount_bigint
            END
        ),
        0
    ) as net_balance,
    v_internal_sum as internal_eliminated,
    COUNT(id)::INT as tx_count
FROM transactions
WHERE date BETWEEN p_start_date AND p_end_date
    AND status = 'validated'
    AND (
        p_group_ids IS NULL
        OR group_id = ANY(p_group_ids)
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- 3. Function for FEC Export (Fichier des Écritures Comptables)
CREATE OR REPLACE FUNCTION generate_fec_lines(p_start_date DATE, p_end_date DATE) RETURNS TABLE (
        "journalCode" TEXT,
        "journalLib" TEXT,
        "ecritureNum" TEXT,
        "ecritureDate" TIMESTAMP,
        "compteNum" TEXT,
        "compteLib" TEXT,
        "compauxNum" TEXT,
        "compauxLib" TEXT,
        "pieceRef" TEXT,
        "pieceDate" TIMESTAMP,
        "ecritureLib" TEXT,
        "debit" NUMERIC,
        "credit" NUMERIC,
        "valideDate" TIMESTAMP,
        "montantDevise" NUMERIC,
        "iDevise" TEXT
    ) AS $$ BEGIN RETURN QUERY
SELECT 'GEN'::TEXT as "journalCode",
    'Journal Général'::TEXT as "journalLib",
    t.id::TEXT as "ecritureNum",
    t.date::TIMESTAMP as "ecritureDate",
    COALESCE(t.category, '701') as "compteNum",
    t.category as "compteLib",
    ''::TEXT as "compauxNum",
    ''::TEXT as "compauxLib",
    t.id::TEXT as "pieceRef",
    t.date::TIMESTAMP as "pieceDate",
    t.label as "ecritureLib",
    CASE
        WHEN t.type = 'expense' THEN (t.amount_bigint::NUMERIC / 100)
        ELSE 0
    END as "debit",
    CASE
        WHEN t.type = 'income' THEN (t.amount_bigint::NUMERIC / 100)
        ELSE 0
    END as "credit",
    t.updated_at as "valideDate",
    (t.amount_bigint::NUMERIC / 100) as "montantDevise",
    'XOF'::TEXT as "iDevise"
FROM transactions t
WHERE t.date BETWEEN p_start_date AND p_end_date
    AND t.status = 'validated';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- 4. Function for Heatmap (Activity intensity)
CREATE OR REPLACE FUNCTION get_transaction_heatmap(
        p_start_date DATE,
        p_end_date DATE,
        p_group_id UUID DEFAULT NULL
    ) RETURNS TABLE (
        day_of_week INT,
        hour_of_day INT,
        tx_count INT
    ) AS $$ BEGIN RETURN QUERY
SELECT EXTRACT(
        DOW
        FROM date
    )::INT as day_of_week,
    EXTRACT(
        HOUR
        FROM date
    )::INT as hour_of_day,
    COUNT(*)::INT as tx_count
FROM transactions
WHERE date BETWEEN p_start_date AND p_end_date
    AND (
        p_group_id IS NULL
        OR group_id = p_group_id
    )
    AND status = 'validated'
GROUP BY 1,
    2
ORDER BY 1,
    2;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- 5. Anomaly detection (Standard Deviation)
CREATE OR REPLACE FUNCTION detect_anomalies(
        p_group_id UUID DEFAULT NULL,
        p_months INT DEFAULT 12
    ) RETURNS TABLE (
        transaction_id UUID,
        amount BIGINT,
        group_avg NUMERIC,
        group_stddev NUMERIC,
        deviation_factor NUMERIC,
        reason TEXT
    ) AS $$ BEGIN RETURN QUERY WITH stats AS (
        SELECT group_id,
            AVG(amount_bigint) as avg_amount,
            STDDEV(amount_bigint) as std_amount
        FROM transactions
        WHERE date > NOW() - (p_months || ' months')::INTERVAL
            AND status = 'validated'
            AND (
                p_group_id IS NULL
                OR group_id = p_group_id
            )
        GROUP BY group_id
    )
SELECT t.id as transaction_id,
    t.amount_bigint as amount,
    s.avg_amount as group_avg,
    s.std_amount as group_stddev,
    ABS(t.amount_bigint - s.avg_amount) / NULLIF(s.std_amount, 0) as deviation_factor,
    CASE
        WHEN ABS(t.amount_bigint - s.avg_amount) > 2 * s.std_amount THEN 'Écart significatif (> 2σ)'
        ELSE 'Normal'
    END as reason
FROM transactions t
    JOIN stats s ON t.group_id = s.group_id
WHERE t.date > NOW() - (p_months || ' months')::INTERVAL
    AND t.status = 'validated'
    AND (
        p_group_id IS NULL
        OR t.group_id = p_group_id
    )
    AND ABS(t.amount_bigint - s.avg_amount) > 2 * s.std_amount;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;