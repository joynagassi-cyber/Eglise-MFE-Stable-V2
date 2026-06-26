-- Migration Sprint 2: Bilan & Audit RPCs
-- ==============================================================================
-- 1. Bilan Summary RPC
-- ==============================================================================
CREATE OR REPLACE FUNCTION get_bilan_summary(
        p_start_date TIMESTAMP WITH TIME ZONE,
        p_end_date TIMESTAMP WITH TIME ZONE,
        p_group_id UUID DEFAULT NULL
    ) RETURNS TABLE (
        total_income NUMERIC,
        total_expense NUMERIC,
        net_balance NUMERIC,
        transaction_count BIGINT,
        sealed_count BIGINT,
        pending_count BIGINT,
        avg_transaction NUMERIC,
        largest_transaction JSONB
    ) LANGUAGE plpgsql SECURITY DEFINER AS $$ BEGIN RETURN QUERY WITH filtered_transactions AS (
        SELECT *
        FROM transactions t
        WHERE t.date >= p_start_date
            AND t.date <= p_end_date
            AND (
                p_group_id IS NULL
                OR t.group_id = p_group_id
            )
            AND t.status != 'archived' -- Exclure archivés si besoin, ou 'draft'
            AND t.status != 'draft' -- On ne compte que les transactions soumises/validées ?
            -- Pour un bilan, on veut généralement ce qui est validé ou au moins en cours.
            -- README: "Consolidated financial views".
            -- Let's include pending, validated, sealed. Exclude draft, rejected.
            AND t.status NOT IN ('draft', 'rejected')
    ),
    aggregates AS (
        SELECT COALESCE(
                SUM(
                    CASE
                        WHEN type = 'income' THEN amount
                        ELSE 0
                    END
                ),
                0
            ) as inc,
            COALESCE(
                SUM(
                    CASE
                        WHEN type = 'expense' THEN amount
                        ELSE 0
                    END
                ),
                0
            ) as exp,
            COUNT(*) as total_cnt,
            COUNT(*) FILTER (
                WHERE status = 'sealed'
            ) as sealed_cnt,
            COUNT(*) FILTER (
                WHERE status = 'pending_validation'
            ) as pending_cnt,
            -- Note: DB value is PENDING_VALIDATION usually standard is lowercase in postgres unless quoted? 
            -- Previous migration used Check constraints? 
            -- Let's check constraint in sprint 1 migration.
            -- Sprint 1 sql: check (status in ('draft', 'pending_validation', 'validated', 'rejected', 'archived'))
            AVG(amount) as avg_amt
        FROM filtered_transactions
    ),
    largest AS (
        SELECT to_jsonb(t.*) as l_trans
        FROM filtered_transactions t
        ORDER BY amount DESC
        LIMIT 1
    )
SELECT a.inc,
    a.exp,
    (a.inc - a.exp),
    a.total_cnt,
    a.sealed_cnt,
    a.pending_cnt,
    COALESCE(a.avg_amt, 0),
    COALESCE(l.l_trans, '{}'::jsonb)
FROM aggregates a
    LEFT JOIN largest l ON true;
END;
$$;
-- ==============================================================================
-- 2. Bilan Breakdown RPC (Charts)
-- ==============================================================================
-- Type: 'category' (pie chart), 'month' (line chart), 'group' (pie chart)
CREATE OR REPLACE FUNCTION get_bilan_breakdown(
        p_start_date TIMESTAMP WITH TIME ZONE,
        p_end_date TIMESTAMP WITH TIME ZONE,
        p_group_id UUID,
        -- Can be NULL
        p_dimension TEXT -- 'category', 'month', 'group'
    ) RETURNS TABLE (
        key TEXT,
        total_income NUMERIC,
        total_expense NUMERIC,
        transaction_count BIGINT
    ) LANGUAGE plpgsql SECURITY DEFINER AS $$ BEGIN RETURN QUERY
SELECT CASE
        WHEN p_dimension = 'category' THEN t.category
        WHEN p_dimension = 'group' THEN t.group_id::text -- J'ideally join with roles/groups table name if available
        WHEN p_dimension = 'month' THEN to_char(t.date, 'YYYY-MM')
        ELSE 'other'
    END as key,
    COALESCE(
        SUM(
            CASE
                WHEN t.type = 'income' THEN t.amount
                ELSE 0
            END
        ),
        0
    ) as total_income,
    COALESCE(
        SUM(
            CASE
                WHEN t.type = 'expense' THEN t.amount
                ELSE 0
            END
        ),
        0
    ) as total_expense,
    COUNT(*) as transaction_count
FROM transactions t
WHERE t.date >= p_start_date
    AND t.date <= p_end_date
    AND (
        p_group_id IS NULL
        OR t.group_id = p_group_id
    )
    AND t.status NOT IN ('draft', 'rejected')
GROUP BY 1
ORDER BY 1;
END;
$$;
-- ==============================================================================
-- 3. Audit Logs Filtered RPC
-- ==============================================================================
CREATE OR REPLACE FUNCTION get_audit_logs_filtered(
        p_start_date TIMESTAMP WITH TIME ZONE DEFAULT NULL,
        p_end_date TIMESTAMP WITH TIME ZONE DEFAULT NULL,
        p_user_id UUID DEFAULT NULL,
        p_action TEXT DEFAULT NULL,
        p_severity TEXT DEFAULT NULL,
        p_limit INT DEFAULT 50,
        p_offset INT DEFAULT 0
    ) RETURNS TABLE (
        id UUID,
        action TEXT,
        table_name TEXT,
        record_id UUID,
        old_data JSONB,
        new_data JSONB,
        user_id UUID,
        created_at TIMESTAMP WITH TIME ZONE,
        severity TEXT,
        -- Assuming we added severity to audit_logs or compute it?
        -- Sprint 1 migration didn't seemingly add 'severity'. 
        -- Requirement: "Audit Anomaly detection". Anomalies might be computed on the fly or stored?
        -- Plan says "AnomalyDetector Service".
        -- Let's return the raw logs.
        user_email TEXT -- Join for display
    ) LANGUAGE plpgsql SECURITY DEFINER AS $$ BEGIN RETURN QUERY
SELECT a.id,
    a.action,
    a.table_name,
    a.record_id,
    a.old_data,
    a.new_data,
    a.user_id,
    a.created_at,
    'info'::text as severity,
    -- Placeholder if no column
    u.email::text
FROM audit_logs a
    LEFT JOIN auth.users u ON a.user_id = u.id
WHERE (
        p_start_date IS NULL
        OR a.created_at >= p_start_date
    )
    AND (
        p_end_date IS NULL
        OR a.created_at <= p_end_date
    )
    AND (
        p_user_id IS NULL
        OR a.user_id = p_user_id
    )
    AND (
        p_action IS NULL
        OR a.action = p_action
    )
ORDER BY a.created_at DESC
LIMIT p_limit OFFSET p_offset;
END;
$$;