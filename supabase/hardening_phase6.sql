-- ==========================================
-- HARDENING PHASE 6: Élimination des conflits RLS restant
-- Objectif: Résoudre "Multiple Permissive Policies"
-- ==========================================

-- 1. MEMBER_PHOTOS
DROP POLICY IF EXISTS "member_photos_manage" ON public.member_photos;
CREATE POLICY "member_photos_write" ON public.member_photos 
    FOR INSERT WITH CHECK (member_id IN (SELECT id FROM members WHERE church_id IN (SELECT church_id FROM user_churches WHERE user_id = (SELECT auth.uid()))));
CREATE POLICY "member_photos_modify" ON public.member_photos 
    FOR UPDATE USING (member_id IN (SELECT id FROM members WHERE church_id IN (SELECT church_id FROM user_churches WHERE user_id = (SELECT auth.uid()))));
CREATE POLICY "member_photos_delete" ON public.member_photos 
    FOR DELETE USING (member_id IN (SELECT id FROM members WHERE church_id IN (SELECT church_id FROM user_churches WHERE user_id = (SELECT auth.uid()))));

-- 2. SPIRITUAL_TRACKING
DROP POLICY IF EXISTS "spiritual_tracking_manage" ON public.spiritual_tracking;
CREATE POLICY "spiritual_tracking_write" ON public.spiritual_tracking 
    FOR INSERT WITH CHECK (belongs_to_church(church_id));
CREATE POLICY "spiritual_tracking_modify" ON public.spiritual_tracking 
    FOR UPDATE USING (belongs_to_church(church_id));
CREATE POLICY "spiritual_tracking_delete" ON public.spiritual_tracking 
    FOR DELETE USING (belongs_to_church(church_id));

-- 3. TEAM_INVITES
DROP POLICY IF EXISTS "team_invites_manage" ON public.team_invites;
CREATE POLICY "team_invites_write" ON public.team_invites 
    FOR INSERT WITH CHECK (created_by = (SELECT auth.uid()));
CREATE POLICY "team_invites_modify" ON public.team_invites 
    FOR UPDATE USING (created_by = (SELECT auth.uid()));
CREATE POLICY "team_invites_delete" ON public.team_invites 
    FOR DELETE USING (created_by = (SELECT auth.uid()));

-- 4. TEAM_MEMBERS
DROP POLICY IF EXISTS "team_members_manage" ON public.team_members;
CREATE POLICY "team_members_write" ON public.team_members 
    FOR INSERT WITH CHECK (user_id = (SELECT auth.uid()));
CREATE POLICY "team_members_modify" ON public.team_members 
    FOR UPDATE USING (user_id = (SELECT auth.uid()));
CREATE POLICY "team_members_delete" ON public.team_members 
    FOR DELETE USING (user_id = (SELECT auth.uid()));

-- 5. USER_ENCRYPTION_KEYS
DROP POLICY IF EXISTS "user_encryption_keys_manage" ON public.user_encryption_keys;
CREATE POLICY "user_encryption_keys_write" ON public.user_encryption_keys 
    FOR INSERT WITH CHECK (user_id = (SELECT auth.uid()));
CREATE POLICY "user_encryption_keys_modify" ON public.user_encryption_keys 
    FOR UPDATE USING (user_id = (SELECT auth.uid()));
CREATE POLICY "user_encryption_keys_delete" ON public.user_encryption_keys 
    FOR DELETE USING (user_id = (SELECT auth.uid()));
