-- migrations/audit_and_reporting_rpcs.sql
-- 1. Optimized Filtered Audit Logs
CREATE OR REPLACE FUNCTION get_audit_logs_filtered(
        p_church_id TEXT,
        p_actor_id UUID DEFAULT NULL,
        p_entity_type TEXT DEFAULT NULL,
        p_action audit_action DEFAULT NULL,
        p_start_date TIMESTAMPTZ DEFAULT NULL,
        p_end_date TIMESTAMPTZ DEFAULT NULL,
        p_limit INTEGER DEFAULT 50,
        p_offset INTEGER DEFAULT 0
    ) RETURNS TABLE (
        id UUID,
        actor_id UUID,
        action audit_action,
        entity_type TEXT,
        entity_id UUID,
        old_value JSONB,
        new_value JSONB,
        metadata JSONB,
        occurred_at TIMESTAMPTZ
    ) AS $$ BEGIN RETURN QUERY
SELECT al.id,
    al.actor_id,
    al.action,
    al.entity_type,
    al.entity_id,
    al.old_value,
    al.new_value,
    al.metadata,
    al.occurred_at
FROM audit_logs al
WHERE (
        p_church_id IS NULL
        OR (al.metadata->>'church_id' = p_church_id)
    )
    AND (
        p_actor_id IS NULL
        OR al.actor_id = p_actor_id
    )
    AND (
        p_entity_type IS NULL
        OR al.entity_type = p_entity_type
    )
    AND (
        p_action IS NULL
        OR al.action = p_action
    )
    AND (
        p_start_date IS NULL
        OR al.occurred_at >= p_start_date
    )
    AND (
        p_end_date IS NULL
        OR al.occurred_at <= p_end_date
    )
ORDER BY al.occurred_at DESC
LIMIT p_limit OFFSET p_offset;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- 2. Enhanced Financial Bilan Summary
CREATE OR REPLACE FUNCTION get_financial_bilan(
        p_church_id TEXT,
        p_start_date DATE,
        p_end_date DATE
    ) RETURNS JSONB AS $$
DECLARE v_total_income NUMERIC;
v_total_expense NUMERIC;
v_sealed_count INTEGER;
v_pending_count INTEGER;
v_total_count INTEGER;
BEGIN
SELECT COALESCE(SUM(amount), 0) INTO v_total_income
FROM finance_transactions
WHERE church_id = p_church_id
    AND type = 'income'
    AND date BETWEEN p_start_date AND p_end_date;
SELECT COALESCE(SUM(amount), 0) INTO v_total_expense
FROM finance_transactions
WHERE church_id = p_church_id
    AND type = 'expense'
    AND date BETWEEN p_start_date AND p_end_date;
SELECT COUNT(*) INTO v_total_count
FROM finance_transactions
WHERE church_id = p_church_id
    AND date BETWEEN p_start_date AND p_end_date;
SELECT COUNT(*) INTO v_sealed_count
FROM finance_transactions
WHERE church_id = p_church_id
    AND status = 'sealed'
    AND date BETWEEN p_start_date AND p_end_date;
SELECT COUNT(*) INTO v_pending_count
FROM finance_transactions
WHERE church_id = p_church_id
    AND status = 'pending'
    AND date BETWEEN p_start_date AND p_end_date;
RETURN jsonb_build_object(
    'total_income',
    v_total_income,
    'total_expense',
    v_total_expense,
    'net_balance',
    v_total_income - v_total_expense,
    'transaction_count',
    v_total_count,
    'sealed_count',
    v_sealed_count,
    'pending_count',
    v_pending_count,
    'avg_transaction',
    CASE
        WHEN v_total_count > 0 THEN (v_total_income + v_total_expense) / v_total_count
        ELSE 0
    END
);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- 4. Financial Breakdown RPC
CREATE OR REPLACE FUNCTION get_bilan_breakdown(
        p_church_id TEXT,
        p_start_date DATE,
        p_end_date DATE,
        p_dimension TEXT -- 'category', 'month', 'group'
    ) RETURNS TABLE (
        breakdown_key TEXT,
        total_income NUMERIC,
        total_expense NUMERIC,
        transaction_count BIGINT
    ) AS $$ BEGIN IF p_dimension = 'category' THEN RETURN QUERY
SELECT category as breakdown_key,
    SUM(amount) FILTER (
        WHERE type = 'income'
    ) as total_income,
    SUM(amount) FILTER (
        WHERE type = 'expense'
    ) as total_expense,
    COUNT(*) as transaction_count
FROM finance_transactions
WHERE church_id = p_church_id
    AND date BETWEEN p_start_date AND p_end_date
GROUP BY category;
ELSIF p_dimension = 'month' THEN RETURN QUERY
SELECT to_char(date, 'YYYY-MM') as breakdown_key,
    SUM(amount) FILTER (
        WHERE type = 'income'
    ) as total_income,
    SUM(amount) FILTER (
        WHERE type = 'expense'
    ) as total_expense,
    COUNT(*) as transaction_count
FROM finance_transactions
WHERE church_id = p_church_id
    AND date BETWEEN p_start_date AND p_end_date
GROUP BY 1
ORDER BY 1;
ELSIF p_dimension = 'group' THEN RETURN QUERY
SELECT group_id::text as breakdown_key,
    SUM(amount) FILTER (
        WHERE type = 'income'
    ) as total_income,
    SUM(amount) FILTER (
        WHERE type = 'expense'
    ) as total_expense,
    COUNT(*) as transaction_count
FROM finance_transactions
WHERE church_id = p_church_id
    AND date BETWEEN p_start_date AND p_end_date
GROUP BY group_id;
END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- 3. Member Analytics
CREATE OR REPLACE FUNCTION get_member_growth_stats(p_church_id TEXT) RETURNS JSONB AS $$ BEGIN RETURN (
        SELECT jsonb_build_object(
                'total_members',
                COUNT(*),
                'active_members',
                COUNT(*) FILTER (
                    WHERE status = 'active'
                ),
                'baptized_members',
                COUNT(*) FILTER (
                    WHERE baptism_date IS NOT NULL
                ),
                'new_this_month',
                COUNT(*) FILTER (
                    WHERE membership_date >= date_trunc('month', now())
                )
            )
        FROM members
        WHERE church_id = p_church_id
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;