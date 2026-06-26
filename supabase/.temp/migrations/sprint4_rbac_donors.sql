-- Migration: Sprint 4 RBAC & Donors
-- Date: 2026-02-10
-- Description: Tables for Role-Based Access Control and Donor Management.
-- ==========================================
-- 1. RBAC Tables
-- ==========================================
-- 1.1 Permissions
CREATE TABLE IF NOT EXISTS permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT NOT NULL UNIQUE,
    -- e.g. 'finance.view'
    label TEXT NOT NULL,
    description TEXT,
    module TEXT NOT NULL,
    -- 'finance', 'admin', 'donors'
    category TEXT NOT NULL CHECK (
        category IN (
            'read',
            'write',
            'delete',
            'admin',
            'export',
            'approve'
        )
    ),
    is_sensitive BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
-- 1.2 Role Permissions
CREATE TABLE IF NOT EXISTS role_permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_id UUID NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    permission_id UUID NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
    granted_by UUID REFERENCES auth.users(id),
    granted_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    UNIQUE(role_id, permission_id)
);
-- ==========================================
-- 2. Donors Tables
-- ==========================================
-- 2.1 Donors
CREATE TABLE IF NOT EXISTS donors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    church_id UUID NOT NULL,
    -- For multi-tenant, though currently mostly single
    type TEXT NOT NULL CHECK (
        type IN ('individual', 'organization', 'anonymous')
    ),
    first_name TEXT,
    last_name TEXT,
    organization_name TEXT,
    display_name TEXT GENERATED ALWAYS AS (
        CASE
            WHEN type = 'organization' THEN organization_name
            WHEN type = 'anonymous' THEN 'Anonyme'
            ELSE TRIM(
                COALESCE(first_name, '') || ' ' || COALESCE(last_name, '')
            )
        END
    ) STORED,
    email TEXT,
    phone TEXT,
    address TEXT,
    member_id UUID,
    -- Link to members table if exists
    tax_id TEXT,
    wants_receipt BOOLEAN DEFAULT true,
    receipt_delivery TEXT CHECK (receipt_delivery IN ('email', 'paper', 'none')) DEFAULT 'email',
    donor_category TEXT CHECK (
        donor_category IN (
            'first_time',
            'occasional',
            'regular',
            'faithful',
            'major',
            'vip'
        )
    ) DEFAULT 'first_time',
    first_donation_date TIMESTAMP WITH TIME ZONE,
    last_donation_date TIMESTAMP WITH TIME ZONE,
    total_donated NUMERIC DEFAULT 0,
    donation_count INT DEFAULT 0,
    avg_donation NUMERIC DEFAULT 0,
    tags TEXT [],
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
-- 2.2 Donation Campaigns
CREATE TABLE IF NOT EXISTS donation_campaigns (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    church_id UUID NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    goal_amount NUMERIC,
    current_amount NUMERIC DEFAULT 0,
    donor_count INT DEFAULT 0,
    start_date TIMESTAMP WITH TIME ZONE,
    end_date TIMESTAMP WITH TIME ZONE,
    status TEXT CHECK (
        status IN (
            'draft',
            'active',
            'paused',
            'completed',
            'cancelled'
        )
    ) DEFAULT 'draft',
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
-- 2.3 Donations
CREATE TABLE IF NOT EXISTS donations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    church_id UUID NOT NULL,
    donor_id UUID NOT NULL REFERENCES donors(id),
    amount NUMERIC NOT NULL CHECK (amount > 0),
    currency TEXT DEFAULT 'XAF',
    donation_type TEXT NOT NULL CHECK (
        donation_type IN (
            'tithe',
            'offering',
            'special_offering',
            'project',
            'building',
            'mission',
            'charity',
            'thanksgiving',
            'other'
        )
    ),
    campaign_id UUID REFERENCES donation_campaigns(id),
    payment_method TEXT,
    payment_reference TEXT,
    is_recurring BOOLEAN DEFAULT false,
    recurrence_id UUID,
    -- Future: link to recurring definition
    transaction_id UUID REFERENCES finance_transactions(id),
    -- Link to finance
    receipt_number TEXT,
    receipt_generated BOOLEAN DEFAULT false,
    receipt_sent BOOLEAN DEFAULT false,
    donation_date TIMESTAMP WITH TIME ZONE DEFAULT now(),
    fiscal_year INT,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
-- 2.4 Donation Receipts
CREATE TABLE IF NOT EXISTS donation_receipts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    church_id UUID NOT NULL,
    donor_id UUID NOT NULL REFERENCES donors(id),
    receipt_number TEXT NOT NULL,
    receipt_type TEXT CHECK (receipt_type IN ('single', 'annual')) DEFAULT 'single',
    period_start TIMESTAMP WITH TIME ZONE,
    period_end TIMESTAMP WITH TIME ZONE,
    fiscal_year INT,
    total_amount NUMERIC NOT NULL,
    donation_count INT,
    donations_detail JSONB,
    -- List of donation IDs or snapshots
    church_name TEXT,
    church_address TEXT,
    donor_display_name TEXT,
    donor_address TEXT,
    pdf_storage_path TEXT,
    sent_via TEXT,
    sent_at TIMESTAMP WITH TIME ZONE,
    content_hash TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
-- 2.5 Donor Pledges
CREATE TABLE IF NOT EXISTS donor_pledges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    church_id UUID NOT NULL,
    donor_id UUID NOT NULL REFERENCES donors(id),
    campaign_id UUID REFERENCES donation_campaigns(id),
    pledged_amount NUMERIC NOT NULL,
    fulfilled_amount NUMERIC DEFAULT 0,
    remaining_amount NUMERIC GENERATED ALWAYS AS (pledged_amount - fulfilled_amount) STORED,
    frequency TEXT,
    -- monthly, one_time
    installment_amount NUMERIC,
    start_date TIMESTAMP WITH TIME ZONE,
    end_date TIMESTAMP WITH TIME ZONE,
    status TEXT CHECK (
        status IN ('active', 'fulfilled', 'cancelled', 'overdue')
    ) DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
-- ==========================================
-- 3. Indexes & RLS
-- ==========================================
-- Indexes
CREATE INDEX IF NOT EXISTS idx_permissions_code ON permissions(code);
CREATE INDEX IF NOT EXISTS idx_donors_search ON donors(last_name, first_name, email);
CREATE INDEX IF NOT EXISTS idx_donations_donor_id ON donations(donor_id);
CREATE INDEX IF NOT EXISTS idx_donations_date ON donations(donation_date);
CREATE INDEX IF NOT EXISTS idx_donations_campaign ON donations(campaign_id);
-- RLS
ALTER TABLE permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE role_permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE donors ENABLE ROW LEVEL SECURITY;
ALTER TABLE donations ENABLE ROW LEVEL SECURITY;
ALTER TABLE donation_campaigns ENABLE ROW LEVEL SECURITY;
ALTER TABLE donation_receipts ENABLE ROW LEVEL SECURITY;
ALTER TABLE donor_pledges ENABLE ROW LEVEL SECURITY;
-- Policies (Simplified for prototype, refine later with permissions)
-- Read: Authenticated
CREATE POLICY "Read permissions" ON permissions FOR
SELECT TO authenticated USING (true);
CREATE POLICY "Read role_permissions" ON role_permissions FOR
SELECT TO authenticated USING (true);
CREATE POLICY "Read donors" ON donors FOR
SELECT TO authenticated USING (true);
CREATE POLICY "Read donations" ON donations FOR
SELECT TO authenticated USING (true);
CREATE POLICY "Read campaigns" ON donation_campaigns FOR
SELECT TO authenticated USING (true);
CREATE POLICY "Read receipts" ON donation_receipts FOR
SELECT TO authenticated USING (true);
CREATE POLICY "Read pledges" ON donor_pledges FOR
SELECT TO authenticated USING (true);
-- Write: Authenticated (Ideally restricted by role, e.g. finance_write)
CREATE POLICY "Write donors" ON donors FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Write donations" ON donations FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Write campaigns" ON donation_campaigns FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Write receipts" ON donation_receipts FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Write pledges" ON donor_pledges FOR ALL TO authenticated USING (true) WITH CHECK (true);
-- Only Admin can write Permissions/Roles
-- (Assuming we have is_super or dedicated admin role check, for now allow authenticated to seed)
CREATE POLICY "Write permissions" ON permissions FOR ALL TO authenticated USING (true);
CREATE POLICY "Write role_permissions" ON role_permissions FOR ALL TO authenticated USING (true);
-- ==========================================
-- 4. Seed Data
-- ==========================================
-- 4.1 Seed Permissions (Idempotent)
INSERT INTO permissions (
        code,
        label,
        description,
        module,
        category,
        is_sensitive
    )
VALUES (
        'finance.view',
        'Voir Finance',
        'Accès en lecture aux transactions et comptes',
        'finance',
        'read',
        false
    ),
    (
        'finance.create',
        'Créer Transaction',
        'Saisir des recettes et dépenses',
        'finance',
        'write',
        false
    ),
    (
        'finance.edit',
        'Modifier Transaction',
        'Modifier transactions non validées',
        'finance',
        'write',
        true
    ),
    (
        'finance.delete',
        'Supprimer Transaction',
        'Supprimer transactions',
        'finance',
        'delete',
        true
    ),
    (
        'finance.validate',
        'Valider Transaction',
        'Valider les transactions',
        'finance',
        'approve',
        true
    ),
    (
        'finance.seal',
        'Sceller Période',
        'Clôture comptable',
        'finance',
        'admin',
        true
    ),
    (
        'admin.roles',
        'Gérer Rôles',
        'Attribuer rôles et permissions',
        'admin',
        'admin',
        true
    ),
    (
        'admin.users',
        'Gérer Utilisateurs',
        'Créer/Modifier utilisateurs',
        'admin',
        'admin',
        true
    ),
    (
        'donors.view',
        'Voir Donateurs',
        'Accès fichier donateurs',
        'donors',
        'read',
        true
    ),
    (
        'donors.create',
        'Gérer Donateurs',
        'Créer/Modifier donateurs',
        'donors',
        'write',
        false
    ),
    (
        'donors.receipts',
        'Gérer Reçus',
        'Générer reçus fiscaux',
        'donors',
        'export',
        true
    ),
    (
        'donors.analytics',
        'Voir Stats Donateurs',
        'Accès dashboard donateurs',
        'donors',
        'read',
        false
    ) ON CONFLICT (code) DO NOTHING;
-- 4.2 Seed Role Permissions
-- Helper function to grant permission
CREATE OR REPLACE FUNCTION grant_permission(p_role_code TEXT, p_perm_code TEXT) RETURNS VOID AS $$ BEGIN
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id,
    p.id
FROM roles r,
    permissions p
WHERE r.code = p_role_code
    AND p.code = p_perm_code ON CONFLICT DO NOTHING;
END;
$$ LANGUAGE plpgsql;
-- Grant to Super Admin (All) - actually specialized logic in app often skips check for super_admin
-- But explicitly granting is safer for generic guards.
-- Granting to Tresorier
SELECT grant_permission('tresorier', 'finance.view');
SELECT grant_permission('tresorier', 'finance.create');
SELECT grant_permission('tresorier', 'finance.edit');
SELECT grant_permission('tresorier', 'finance.validate');
SELECT grant_permission('tresorier', 'donors.view');
SELECT grant_permission('tresorier', 'donors.create');
-- Grant to President
SELECT grant_permission('president', 'finance.view');
SELECT grant_permission('president', 'finance.validate');
SELECT grant_permission('president', 'finance.seal');
SELECT grant_permission('president', 'admin.roles');
SELECT grant_permission('president', 'donors.view');
SELECT grant_permission('president', 'donors.analytics');
-- Grant to Comptable
SELECT grant_permission('comptable', 'finance.view');
SELECT grant_permission('comptable', 'finance.create');
SELECT grant_permission('comptable', 'finance.edit');
-- Clean up helper
DROP FUNCTION grant_permission(TEXT, TEXT);
-- ==========================================
-- 5. RPCs
-- ==========================================
-- 5.1 Get User Permissions
CREATE OR REPLACE FUNCTION get_user_permissions(p_user_id UUID) RETURNS TABLE (code TEXT) LANGUAGE plpgsql SECURITY DEFINER AS $$ BEGIN RETURN QUERY
SELECT DISTINCT p.code
FROM permissions p
    JOIN role_permissions rp ON rp.permission_id = p.id
    JOIN user_roles ur ON ur.role_id = rp.role_id
WHERE ur.user_id = p_user_id;
END;
$$;
-- 5.2 Check Permission
CREATE OR REPLACE FUNCTION check_permission(p_user_id UUID, p_perm_code TEXT) RETURNS BOOLEAN LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_has BOOLEAN;
BEGIN -- Check if super admin
IF EXISTS (
    SELECT 1
    FROM user_roles ur
        JOIN roles r ON ur.role_id = r.id
    WHERE ur.user_id = p_user_id
        AND r.is_super = true
) THEN RETURN TRUE;
END IF;
SELECT EXISTS (
        SELECT 1
        FROM permissions p
            JOIN role_permissions rp ON rp.permission_id = p.id
            JOIN user_roles ur ON ur.role_id = rp.role_id
        WHERE ur.user_id = p_user_id
            AND p.code = p_perm_code
    ) INTO v_has;
RETURN v_has;
END;
$$;
-- 5.3 Get Donor Stats (Stub for dashboard)
CREATE OR REPLACE FUNCTION get_donor_dashboard_stats() RETURNS TABLE (
        total_donors INT,
        total_donated NUMERIC,
        avg_donation NUMERIC,
        retention_rate NUMERIC
    ) LANGUAGE plpgsql SECURITY DEFINER AS $$ BEGIN RETURN QUERY
SELECT (
        SELECT COUNT(*)::INT
        FROM donors
        WHERE is_active = true
    ),
    (
        SELECT COALESCE(SUM(total_donated), 0)
        FROM donors
    ),
    (
        SELECT COALESCE(AVG(avg_donation), 0)
        FROM donors
        WHERE donation_count > 0
    ),
    78.5;
-- Placeholder for complex retention calc
END;
$$;