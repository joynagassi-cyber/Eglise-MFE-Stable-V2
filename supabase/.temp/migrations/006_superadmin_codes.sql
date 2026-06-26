-- ============================================================================
-- MIGRATION 006: Superadmin Activation System (Reusable Codes)
-- ============================================================================
-- 1. Table for Admin Codes (Hashed)
CREATE TABLE IF NOT EXISTS admin_codes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code_hash TEXT NOT NULL UNIQUE,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    -- Reusable codes designated by active status
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
-- Securely insert the 3 pre-configured code hashes
INSERT INTO admin_codes (code_hash, description)
VALUES (
        '777349a663629beda1314ecd2b5114ece4389afe71fab77740b323c6a640414d',
        'Code Alpha - X9v...'
    ),
    (
        'e00f84b2d2156cc0854f7b376bad973a0ddf763156d48753c6d765d5fcb70614',
        'Code Beta - T8r...'
    ),
    (
        '191b95a607046a087654613736a93755c173c4729e02b1fd6231c9cbf0d86f31',
        'Code Gamma - Q6k...'
    );
-- 2. Table for Activation Logs (Security Audit)
CREATE TABLE IF NOT EXISTS admin_activations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE
    SET NULL,
        code_id UUID REFERENCES admin_codes(id),
        ip_address INET,
        user_agent TEXT,
        activated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
-- 3. RLS Policies
ALTER TABLE admin_codes ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_activations ENABLE ROW LEVEL SECURITY;
-- Only Service Role can access these tables (Edge Functions)
CREATE POLICY "Service Role Only Admin Codes" ON admin_codes FOR ALL USING (auth.role() = 'service_role');
CREATE POLICY "Service Role Only Admin Activations" ON admin_activations FOR ALL USING (auth.role() = 'service_role');
-- 4. Function to Validate and Log Activation
-- This function will be called by the Edge Function with Service Role privileges
CREATE OR REPLACE FUNCTION verify_admin_code(
        p_code_hash TEXT,
        p_user_id UUID,
        p_ip_address INET DEFAULT NULL,
        p_user_agent TEXT DEFAULT NULL
    ) RETURNS BOOLEAN AS $$
DECLARE v_code_id UUID;
BEGIN -- Check if code exists and is active
SELECT id INTO v_code_id
FROM admin_codes
WHERE code_hash = p_code_hash
    AND is_active = TRUE;
IF v_code_id IS NULL THEN -- Log failed attempt (optional, generic activity log covers this)
PERFORM log_activity(
    'admin.activation_failed',
    p_user_id,
    'user',
    'system',
    NULL,
    jsonb_build_object('reason', 'invalid_code')
);
RETURN FALSE;
END IF;
-- Log successful activation
INSERT INTO admin_activations (user_id, code_id, ip_address, user_agent)
VALUES (p_user_id, v_code_id, p_ip_address, p_user_agent);
-- Log to general activity log
PERFORM log_activity(
    'admin.activated',
    p_user_id,
    'user',
    'system',
    v_code_id,
    jsonb_build_object('method', 'secret_code')
);
RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;