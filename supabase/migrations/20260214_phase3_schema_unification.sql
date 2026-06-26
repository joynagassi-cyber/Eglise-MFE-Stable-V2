-- ═══════════════════════════════════════════════════════════════════════════════
-- Phase 3 Schema Unification & Feature Hardening
-- Date: 2026-02-14
-- Purpose: Unify table names, create missing tables for 100% feature coverage
-- ═══════════════════════════════════════════════════════════════════════════════
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ 1. SOCIAL POSTS & COMMENTS                                                 │
-- └─────────────────────────────────────────────────────────────────────────────┘
CREATE TABLE IF NOT EXISTS social_posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    author_id UUID NOT NULL,
    author_name TEXT,
    author_avatar_url TEXT,
    content TEXT NOT NULL,
    image_urls TEXT [] DEFAULT '{}',
    likes_count INTEGER DEFAULT 0,
    comments_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS social_comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    post_id UUID NOT NULL REFERENCES social_posts(id) ON DELETE CASCADE,
    author_id UUID NOT NULL,
    author_name TEXT,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_social_posts_created ON social_posts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_social_comments_post ON social_comments(post_id, created_at DESC);
-- RLS
ALTER TABLE social_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE social_comments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "social_posts_select" ON social_posts FOR
SELECT TO authenticated USING (true);
CREATE POLICY "social_posts_insert" ON social_posts FOR
INSERT TO authenticated WITH CHECK (author_id = auth.uid());
CREATE POLICY "social_posts_update" ON social_posts FOR
UPDATE TO authenticated USING (author_id = auth.uid());
CREATE POLICY "social_posts_delete" ON social_posts FOR DELETE TO authenticated USING (author_id = auth.uid());
CREATE POLICY "social_comments_select" ON social_comments FOR
SELECT TO authenticated USING (true);
CREATE POLICY "social_comments_insert" ON social_comments FOR
INSERT TO authenticated WITH CHECK (author_id = auth.uid());
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ 2. CIRCLES (Advanced Community Groups)                                     │
-- └─────────────────────────────────────────────────────────────────────────────┘
CREATE TABLE IF NOT EXISTS circles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    church_id TEXT NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    icon_name TEXT DEFAULT 'group',
    color_hex VARCHAR(7) DEFAULT '#7C4DFF',
    member_count INTEGER DEFAULT 0,
    is_private BOOLEAN DEFAULT false,
    created_by UUID,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS circle_members (
    circle_id UUID REFERENCES circles(id) ON DELETE CASCADE,
    member_id TEXT NOT NULL,
    role TEXT DEFAULT 'member',
    joined_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (circle_id, member_id)
);
CREATE INDEX IF NOT EXISTS idx_circles_church ON circles(church_id);
CREATE INDEX IF NOT EXISTS idx_circle_members_member ON circle_members(member_id);
-- RLS
ALTER TABLE circles ENABLE ROW LEVEL SECURITY;
ALTER TABLE circle_members ENABLE ROW LEVEL SECURITY;
CREATE POLICY "circles_select" ON circles FOR
SELECT TO authenticated USING (true);
CREATE POLICY "circles_manage" ON circles FOR ALL TO authenticated USING (
    EXISTS (
        SELECT 1
        FROM user_roles ur
            JOIN roles r ON ur.role_id = r.id
        WHERE ur.user_id = auth.uid()
            AND r.name IN ('admin', 'pasteur', 'berger')
            AND ur.is_active = true
    )
);
CREATE POLICY "circle_members_select" ON circle_members FOR
SELECT TO authenticated USING (true);
CREATE POLICY "circle_members_manage" ON circle_members FOR ALL TO authenticated USING (
    EXISTS (
        SELECT 1
        FROM user_roles ur
            JOIN roles r ON ur.role_id = r.id
        WHERE ur.user_id = auth.uid()
            AND r.name IN ('admin', 'pasteur', 'berger')
            AND ur.is_active = true
    )
);
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ 3. NOTIFICATIONS HISTORY                                                   │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- Note: 'notifications' table may already exist from init.sql.
-- This is idempotent (IF NOT EXISTS).
CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    type TEXT NOT NULL,
    link_url TEXT,
    payload JSONB DEFAULT '{}',
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMPTZ,
    priority TEXT DEFAULT 'NORMAL',
    created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(user_id, is_read, created_at DESC);
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
CREATE POLICY "notifications_select_own" ON notifications FOR
SELECT TO authenticated USING (user_id = auth.uid());
CREATE POLICY "notifications_update_own" ON notifications FOR
UPDATE TO authenticated USING (user_id = auth.uid());
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ 4. SHEPHERDS TABLE (if missing)                                            │
-- └─────────────────────────────────────────────────────────────────────────────┘
CREATE TABLE IF NOT EXISTS shepherds (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    church_id TEXT NOT NULL,
    member_id TEXT NOT NULL,
    first_name TEXT,
    last_name TEXT,
    photo_url TEXT,
    level VARCHAR(20) DEFAULT 'DEBUTANT',
    specialties TEXT [] DEFAULT '{}',
    supervised_group_ids TEXT [] DEFAULT '{}',
    bio TEXT,
    ordained_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_shepherds_church ON shepherds(church_id);
ALTER TABLE shepherds ENABLE ROW LEVEL SECURITY;
CREATE POLICY "shepherds_select" ON shepherds FOR
SELECT TO authenticated USING (true);
CREATE POLICY "shepherds_manage" ON shepherds FOR ALL TO authenticated USING (
    EXISTS (
        SELECT 1
        FROM user_roles ur
            JOIN roles r ON ur.role_id = r.id
        WHERE ur.user_id = auth.uid()
            AND r.name IN ('admin', 'pasteur')
            AND ur.is_active = true
    )
);
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ 5. PASTORAL VISITS (if missing - Flutter repo uses 'pastoral_visits')      │
-- └─────────────────────────────────────────────────────────────────────────────┘
CREATE TABLE IF NOT EXISTS pastoral_visits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id TEXT NOT NULL,
    shepherd_id TEXT NOT NULL,
    visit_date TIMESTAMPTZ NOT NULL,
    address TEXT DEFAULT '',
    reason TEXT NOT NULL DEFAULT '',
    notes TEXT DEFAULT '',
    status VARCHAR(20) DEFAULT 'planifiee',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_pastoral_visits_shepherd ON pastoral_visits(shepherd_id, status);
CREATE INDEX IF NOT EXISTS idx_pastoral_visits_member ON pastoral_visits(member_id);
ALTER TABLE pastoral_visits ENABLE ROW LEVEL SECURITY;
CREATE POLICY "pastoral_visits_select" ON pastoral_visits FOR
SELECT TO authenticated USING (true);
CREATE POLICY "pastoral_visits_manage" ON pastoral_visits FOR ALL TO authenticated USING (
    EXISTS (
        SELECT 1
        FROM user_roles ur
            JOIN roles r ON ur.role_id = r.id
        WHERE ur.user_id = auth.uid()
            AND r.name IN ('admin', 'pasteur', 'berger')
            AND ur.is_active = true
    )
);
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ 6. ANNONCES TABLE (if missing - Flutter repo uses 'annonces')              │
-- └─────────────────────────────────────────────────────────────────────────────┘
CREATE TABLE IF NOT EXISTS annonces (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    church_id TEXT NOT NULL,
    type TEXT DEFAULT 'GENERAL',
    title TEXT NOT NULL,
    content TEXT,
    summary TEXT,
    image_url TEXT,
    author_id TEXT,
    author_name TEXT,
    date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    published_at TIMESTAMPTZ,
    is_published BOOLEAN DEFAULT false,
    is_pinned BOOLEAN DEFAULT false,
    views_count INTEGER DEFAULT 0,
    likes_count INTEGER DEFAULT 0,
    tags TEXT,
    category TEXT,
    status TEXT DEFAULT 'BROUILLON',
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    created_by TEXT,
    updated_by TEXT
);
CREATE INDEX IF NOT EXISTS idx_annonces_church ON annonces(church_id, is_published, date DESC);
ALTER TABLE annonces ENABLE ROW LEVEL SECURITY;
CREATE POLICY "annonces_select" ON annonces FOR
SELECT TO authenticated USING (true);
CREATE POLICY "annonces_manage" ON annonces FOR ALL TO authenticated USING (
    EXISTS (
        SELECT 1
        FROM user_roles ur
            JOIN roles r ON ur.role_id = r.id
        WHERE ur.user_id = auth.uid()
            AND r.name IN ('admin', 'pasteur')
            AND ur.is_active = true
    )
);
-- ═══════════════════════════════════════════════════════════════════════════════
-- FIN MIGRATION PHASE 3
-- ═══════════════════════════════════════════════════════════════════════════════