-- migrations/007_observability_views.sql
-- ============================================================================
-- OBSERVABILITY VIEWS & FUNCTIONS
-- SQL views for Grafana/Supabase Analytics dashboards
-- ============================================================================
-- ============================================================================
-- VIEW: activity_summary_hourly
-- Aggregates activity_log by hour for trend analysis
-- ============================================================================
CREATE OR REPLACE VIEW activity_summary_hourly AS
SELECT date_trunc('hour', created_at) as hour,
    action,
    target_type,
    COUNT(*) as event_count,
    COUNT(DISTINCT actor_user_id) as unique_users
FROM activity_log
WHERE created_at > NOW() - INTERVAL '7 days'
GROUP BY 1,
    2,
    3
ORDER BY 1 DESC;
COMMENT ON VIEW activity_summary_hourly IS 'Hourly aggregation of activity for dashboard widgets';
-- ============================================================================
-- VIEW: user_activity_stats
-- Per-user activity statistics for engagement analysis
-- ============================================================================
CREATE OR REPLACE VIEW user_activity_stats AS
SELECT actor_user_id as user_id,
    COUNT(*) as total_actions,
    COUNT(DISTINCT action) as unique_action_types,
    COUNT(DISTINCT DATE(created_at)) as active_days,
    MIN(created_at) as first_activity,
    MAX(created_at) as last_activity,
    COUNT(*) FILTER (
        WHERE action LIKE 'auth.%'
    ) as auth_events,
    COUNT(*) FILTER (
        WHERE action LIKE 'member.%'
    ) as member_events,
    COUNT(*) FILTER (
        WHERE action LIKE 'finance.%'
    ) as finance_events,
    COUNT(*) FILTER (
        WHERE action LIKE 'error.%'
    ) as error_events
FROM activity_log
WHERE created_at > NOW() - INTERVAL '30 days'
    AND actor_user_id IS NOT NULL
GROUP BY 1;
COMMENT ON VIEW user_activity_stats IS 'Per-user activity metrics for engagement dashboards';
-- ============================================================================
-- VIEW: error_summary
-- Error aggregation for alerting and debugging
-- ============================================================================
CREATE OR REPLACE VIEW error_summary AS
SELECT date_trunc('hour', created_at) as hour,
    action,
    metadata->>'error_type' as error_type,
    metadata->>'context' as context,
    COUNT(*) as error_count,
    COUNT(DISTINCT actor_user_id) as affected_users
FROM activity_log
WHERE (
        action LIKE '%.error'
        OR action LIKE 'error.%'
    )
    AND created_at > NOW() - INTERVAL '24 hours'
GROUP BY 1,
    2,
    3,
    4
ORDER BY error_count DESC;
COMMENT ON VIEW error_summary IS 'Error aggregation for monitoring and alerting';
-- ============================================================================
-- VIEW: feature_usage_stats
-- Feature adoption and usage metrics
-- ============================================================================
CREATE OR REPLACE VIEW feature_usage_stats AS
SELECT SPLIT_PART(action, '.', 1) as feature_area,
    action,
    COUNT(*) as usage_count,
    COUNT(DISTINCT actor_user_id) as unique_users,
    AVG((metadata->>'duration_ms')::int) FILTER (
        WHERE metadata->>'duration_ms' IS NOT NULL
    ) as avg_duration_ms
FROM activity_log
WHERE created_at > NOW() - INTERVAL '30 days'
    AND action NOT LIKE '%.error'
    AND action NOT LIKE 'error.%'
GROUP BY 1,
    2
ORDER BY usage_count DESC;
COMMENT ON VIEW feature_usage_stats IS 'Feature usage metrics for product analytics';
-- ============================================================================
-- VIEW: auth_funnel
-- Authentication funnel analysis
-- ============================================================================
CREATE OR REPLACE VIEW auth_funnel AS WITH daily_metrics AS (
        SELECT DATE(created_at) as day,
            COUNT(*) FILTER (
                WHERE action = 'auth.login.started'
            ) as login_attempts,
            COUNT(*) FILTER (
                WHERE action = 'auth.login.success'
            ) as login_success,
            COUNT(*) FILTER (
                WHERE action = 'auth.register.started'
            ) as register_attempts,
            COUNT(*) FILTER (
                WHERE action = 'auth.register.success'
            ) as register_success,
            COUNT(*) FILTER (
                WHERE action = 'auth.otp.requested'
            ) as otp_requested,
            COUNT(*) FILTER (
                WHERE action = 'auth.otp.verified'
            ) as otp_verified,
            COUNT(*) FILTER (
                WHERE action = 'auth.otp.failed'
            ) as otp_failed
        FROM activity_log
        WHERE created_at > NOW() - INTERVAL '30 days'
            AND action LIKE 'auth.%'
        GROUP BY 1
    )
SELECT day,
    login_attempts,
    login_success,
    CASE
        WHEN login_attempts > 0 THEN ROUND(100.0 * login_success / login_attempts, 2)
        ELSE 0
    END as login_success_rate,
    register_attempts,
    register_success,
    CASE
        WHEN register_attempts > 0 THEN ROUND(100.0 * register_success / register_attempts, 2)
        ELSE 0
    END as register_success_rate,
    otp_requested,
    otp_verified,
    CASE
        WHEN otp_requested > 0 THEN ROUND(100.0 * otp_verified / otp_requested, 2)
        ELSE 0
    END as otp_success_rate
FROM daily_metrics
ORDER BY day DESC;
COMMENT ON VIEW auth_funnel IS 'Daily authentication funnel metrics';
-- ============================================================================
-- VIEW: finance_activity
-- Finance-specific activity for business dashboards
-- ============================================================================
CREATE OR REPLACE VIEW finance_activity AS
SELECT DATE(created_at) as day,
    COUNT(*) FILTER (
        WHERE action = 'finance.transaction.created'
    ) as transactions_created,
    COUNT(*) FILTER (
        WHERE action = 'finance.budget.created'
    ) as budgets_created,
    COUNT(*) FILTER (
        WHERE action = 'finance.budget.approved'
    ) as budgets_approved,
    COUNT(*) FILTER (
        WHERE action = 'finance.report.generated'
    ) as reports_generated,
    COUNT(*) FILTER (
        WHERE action LIKE 'finance.reconciliation.%'
    ) as reconciliation_events,
    COUNT(DISTINCT actor_user_id) as active_finance_users
FROM activity_log
WHERE created_at > NOW() - INTERVAL '30 days'
    AND action LIKE 'finance.%'
GROUP BY 1
ORDER BY day DESC;
COMMENT ON VIEW finance_activity IS 'Daily finance module activity';
-- ============================================================================
-- VIEW: member_activity
-- Member management activity
-- ============================================================================
CREATE OR REPLACE VIEW member_activity AS
SELECT DATE(created_at) as day,
    COUNT(*) FILTER (
        WHERE action = 'member.created'
    ) as members_created,
    COUNT(*) FILTER (
        WHERE action = 'member.updated'
    ) as members_updated,
    COUNT(*) FILTER (
        WHERE action = 'member.deleted'
    ) as members_deleted,
    COUNT(*) FILTER (
        WHERE action = 'member.viewed'
    ) as members_viewed,
    COUNT(*) FILTER (
        WHERE action = 'member.exported'
    ) as exports_done,
    COUNT(DISTINCT actor_user_id) as active_member_mgmt_users
FROM activity_log
WHERE created_at > NOW() - INTERVAL '30 days'
    AND action LIKE 'member.%'
GROUP BY 1
ORDER BY day DESC;
COMMENT ON VIEW member_activity IS 'Daily member management activity';
-- ============================================================================
-- FUNCTION: get_activity_metrics
-- Aggregated metrics for dashboard widgets
-- ============================================================================
CREATE OR REPLACE FUNCTION get_activity_metrics(p_hours_back INT DEFAULT 24) RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_result JSONB;
BEGIN
SELECT jsonb_build_object(
        'total_events',
        COUNT(*),
        'unique_users',
        COUNT(DISTINCT actor_user_id),
        'error_count',
        COUNT(*) FILTER (
            WHERE action LIKE '%.error'
                OR action LIKE 'error.%'
        ),
        'auth_events',
        COUNT(*) FILTER (
            WHERE action LIKE 'auth.%'
        ),
        'finance_events',
        COUNT(*) FILTER (
            WHERE action LIKE 'finance.%'
        ),
        'member_events',
        COUNT(*) FILTER (
            WHERE action LIKE 'member.%'
        ),
        'screen_views',
        COUNT(*) FILTER (
            WHERE action = 'nav.screen.view'
        ),
        'top_actions',
        (
            SELECT jsonb_agg(row_to_json(t))
            FROM (
                    SELECT action,
                        COUNT(*) as count
                    FROM activity_log
                    WHERE created_at > NOW() - (p_hours_back || ' hours')::INTERVAL
                    GROUP BY action
                    ORDER BY count DESC
                    LIMIT 10
                ) t
        ), 'hourly_trend', (
            SELECT jsonb_agg(row_to_json(t))
            FROM (
                    SELECT date_trunc('hour', created_at) as hour,
                        COUNT(*) as count
                    FROM activity_log
                    WHERE created_at > NOW() - (p_hours_back || ' hours')::INTERVAL
                    GROUP BY 1
                    ORDER BY 1
                ) t
        )
    ) INTO v_result
FROM activity_log
WHERE created_at > NOW() - (p_hours_back || ' hours')::INTERVAL;
RETURN v_result;
END;
$$;
COMMENT ON FUNCTION get_activity_metrics IS 'Returns aggregated activity metrics for dashboard widgets';
-- ============================================================================
-- FUNCTION: get_sli_metrics
-- SLI (Service Level Indicator) metrics for SLO monitoring
-- ============================================================================
CREATE OR REPLACE FUNCTION get_sli_metrics(p_days_back INT DEFAULT 30) RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_result JSONB;
BEGIN WITH otp_metrics AS (
    SELECT COUNT(*) FILTER (
            WHERE action = 'auth.otp.requested'
        ) as requested,
        COUNT(*) FILTER (
            WHERE action = 'auth.otp.verified'
        ) as verified,
        COUNT(*) FILTER (
            WHERE action = 'auth.otp.failed'
        ) as failed
    FROM activity_log
    WHERE created_at > NOW() - (p_days_back || ' days')::INTERVAL
),
auth_metrics AS (
    SELECT COUNT(*) FILTER (
            WHERE action = 'auth.login.started'
        ) as login_attempts,
        COUNT(*) FILTER (
            WHERE action = 'auth.login.success'
        ) as login_success
    FROM activity_log
    WHERE created_at > NOW() - (p_days_back || ' days')::INTERVAL
),
perf_metrics AS (
    SELECT AVG((metadata->>'duration_ms')::int) as avg_duration,
        PERCENTILE_CONT(0.95) WITHIN GROUP (
            ORDER BY (metadata->>'duration_ms')::int
        ) as p95_duration
    FROM activity_log
    WHERE metadata->>'duration_ms' IS NOT NULL
        AND created_at > NOW() - (p_days_back || ' days')::INTERVAL
)
SELECT jsonb_build_object(
        'otp_delivery_success_rate',
        CASE
            WHEN o.requested > 0 THEN ROUND(100.0 * o.verified / o.requested, 2)
            ELSE 0
        END,
        'otp_total_requested',
        o.requested,
        'otp_total_verified',
        o.verified,
        'otp_total_failed',
        o.failed,
        'login_success_rate',
        CASE
            WHEN a.login_attempts > 0 THEN ROUND(100.0 * a.login_success / a.login_attempts, 2)
            ELSE 0
        END,
        'avg_operation_duration_ms',
        ROUND(p.avg_duration::numeric, 2),
        'p95_operation_duration_ms',
        ROUND(p.p95_duration::numeric, 2),
        'measurement_period_days',
        p_days_back
    ) INTO v_result
FROM otp_metrics o,
    auth_metrics a,
    perf_metrics p;
RETURN v_result;
END;
$$;
COMMENT ON FUNCTION get_sli_metrics IS 'Returns SLI metrics for SLO monitoring dashboards';
-- ============================================================================
-- Grant access to views for authenticated users to query their own data
-- ============================================================================
-- Note: These views aggregate data, so direct RLS doesn't apply.
-- Access should be controlled via API/Edge Functions.