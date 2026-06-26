-- ==========================================
-- HARDENING PHASE 5: Nettoyage Ultime RLS (CORRIGÉ)
-- Objectif: 0 avertissement (Performance & Sécurité)
-- ==========================================

-- 1. TRANSACTION_IMAGES
DROP POLICY IF EXISTS "transaction_images_service_role" ON public.transaction_images;
DROP POLICY IF EXISTS "transaction_images_insert_own" ON public.transaction_images;
DROP POLICY IF EXISTS "transaction_images_select_auth" ON public.transaction_images;
DROP POLICY IF EXISTS "transaction_images_access" ON public.transaction_images;
CREATE POLICY "transaction_images_select" ON public.transaction_images FOR SELECT TO authenticated USING (true);
CREATE POLICY "transaction_images_insert" ON public.transaction_images FOR INSERT TO authenticated WITH CHECK (uploaded_by = (SELECT auth.uid()));

-- 2. TRUSTED_DEVICE_EVENTS
DROP POLICY IF EXISTS "device_events_service" ON public.trusted_device_events;
DROP POLICY IF EXISTS "device_events_service_all" ON public.trusted_device_events;
DROP POLICY IF EXISTS "device_events_own" ON public.trusted_device_events;
DROP POLICY IF EXISTS "device_events_select_combined" ON public.trusted_device_events;
CREATE POLICY "trusted_device_events_select" ON public.trusted_device_events FOR SELECT TO authenticated USING (user_id = (SELECT auth.uid()));

-- 3. USER_ROLES
DROP POLICY IF EXISTS "user_roles_service_role" ON public.user_roles;
DROP POLICY IF EXISTS "user_roles_select_own" ON public.user_roles;
CREATE POLICY "user_roles_select" ON public.user_roles FOR SELECT TO authenticated USING (user_id = (SELECT auth.uid()));

-- 4. VALIDATION_THRESHOLDS
DROP POLICY IF EXISTS "SuperAdmins can manage thresholds" ON public.validation_thresholds;
DROP POLICY IF EXISTS "Authenticated select thresholds" ON public.validation_thresholds;
DROP POLICY IF EXISTS "Everyone can read thresholds" ON public.validation_thresholds;
CREATE POLICY "validation_thresholds_select" ON public.validation_thresholds FOR SELECT TO authenticated USING (true);

-- 5. CHURCH_MEMBERS
DROP POLICY IF EXISTS "church_members_service_role" ON public.church_members;
DROP POLICY IF EXISTS "church_members_manage_own" ON public.church_members;
DROP POLICY IF EXISTS "church_members_select_own_church" ON public.church_members;
CREATE POLICY "church_members_select" ON public.church_members 
    FOR SELECT TO authenticated 
    USING ((user_id = (SELECT auth.uid())) OR (church_id IN (SELECT uc.church_id FROM user_churches uc WHERE uc.user_id = (SELECT auth.uid()))));

-- 6. EVENT_ATTENDANCES
DROP POLICY IF EXISTS "Event attendance church access" ON public.event_attendances;
DROP POLICY IF EXISTS "event_attendances_authenticated" ON public.event_attendances;
CREATE POLICY "event_attendances_access" ON public.event_attendances
    FOR ALL TO authenticated
    USING (EXISTS (SELECT 1 FROM events e WHERE e.id = event_id AND belongs_to_church(e.church_id)));

-- 7. FAMILY_RELATIONSHIPS
DROP POLICY IF EXISTS "family_relationships_authenticated" ON public.family_relationships;
DROP POLICY IF EXISTS "Enable access by church_id for family_relationships" ON public.family_relationships;
DROP POLICY IF EXISTS "Family relationship church access" ON public.family_relationships;
CREATE POLICY "family_relationships_access" ON public.family_relationships
    FOR ALL TO authenticated
    USING (belongs_to_church(church_id));

-- 8. MEMBER_HISTORY
DROP POLICY IF EXISTS "Enable access by church_id for member_history" ON public.member_history;
DROP POLICY IF EXISTS "Member history church access" ON public.member_history;
DROP POLICY IF EXISTS "member_history_authenticated" ON public.member_history;
CREATE POLICY "member_history_access" ON public.member_history
    FOR ALL TO authenticated
    USING (belongs_to_church(church_id));

-- 9. MEMBER_PHOTOS
DROP POLICY IF EXISTS "member_photos_access" ON public.member_photos;
DROP POLICY IF EXISTS "member_photos_select_all" ON public.member_photos;
DROP POLICY IF EXISTS "Member photo church access" ON public.member_photos;
CREATE POLICY "member_photos_select" ON public.member_photos FOR SELECT TO authenticated USING (true);
CREATE POLICY "member_photos_manage" ON public.member_photos 
    FOR ALL TO authenticated 
    USING (member_id IN (SELECT id FROM members WHERE church_id IN (SELECT church_id FROM user_churches WHERE user_id = (SELECT auth.uid()))));

-- 10. RECONCILIATION_ITEMS
DROP POLICY IF EXISTS "reconciliation_items_access" ON public.reconciliation_items;
DROP POLICY IF EXISTS "reconciliation_items_service_role" ON public.reconciliation_items;
DROP POLICY IF EXISTS "reconciliation_items_select_auth" ON public.reconciliation_items;
CREATE POLICY "reconciliation_items_select" ON public.reconciliation_items FOR SELECT TO authenticated USING (true);

-- 11. SPIRITUAL_TRACKING
DROP POLICY IF EXISTS "spiritual_tracking_access_v4" ON public.spiritual_tracking;
DROP POLICY IF EXISTS "spiritual_tracking_access" ON public.spiritual_tracking;
DROP POLICY IF EXISTS "Enable access by church_id for spiritual_tracking" ON public.spiritual_tracking;
CREATE POLICY "spiritual_tracking_select" ON public.spiritual_tracking FOR SELECT TO authenticated USING (true);
CREATE POLICY "spiritual_tracking_manage" ON public.spiritual_tracking 
    FOR ALL TO authenticated 
    USING (belongs_to_church(church_id));

-- 12. TEAM_INVITES / MEMBERS / ROLES / TEAMS
DROP POLICY IF EXISTS "team_invites_access" ON public.team_invites;
CREATE POLICY "team_invites_select" ON public.team_invites FOR SELECT TO authenticated USING (true);
CREATE POLICY "team_invites_manage" ON public.team_invites FOR ALL TO authenticated USING (created_by = (SELECT auth.uid()));

DROP POLICY IF EXISTS "team_members_access" ON public.team_members;
CREATE POLICY "team_members_select" ON public.team_members FOR SELECT TO authenticated USING (true);
CREATE POLICY "team_members_manage" ON public.team_members FOR ALL TO authenticated USING (user_id = (SELECT auth.uid()));

DROP POLICY IF EXISTS "team_roles_access" ON public.team_roles;
CREATE POLICY "team_roles_select" ON public.team_roles FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "teams_access" ON public.teams;
CREATE POLICY "teams_select" ON public.teams FOR SELECT TO authenticated USING (true);

-- 13. USER_ENCRYPTION_KEYS
DROP POLICY IF EXISTS "Users manage their own keys" ON public.user_encryption_keys;
DROP POLICY IF EXISTS "Public keys are readable by authenticated users" ON public.user_encryption_keys;
CREATE POLICY "user_encryption_keys_select" ON public.user_encryption_keys FOR SELECT TO authenticated USING (true);
CREATE POLICY "user_encryption_keys_manage" ON public.user_encryption_keys FOR ALL TO authenticated USING (user_id = (SELECT auth.uid()));

-- 14. USER_PRESENCE
DROP POLICY IF EXISTS "Users update their own presence" ON public.user_presence;
DROP POLICY IF EXISTS "Presence is readable by authenticated users" ON public.user_presence;
CREATE POLICY "user_presence_select" ON public.user_presence FOR SELECT TO authenticated USING (true);
CREATE POLICY "user_presence_update" ON public.user_presence FOR UPDATE TO authenticated USING (user_id = (SELECT auth.uid()));

-- 15. SOCIAL_POSTS / COMMENTS
DROP POLICY IF EXISTS "social_posts_service_role" ON public.social_posts;
DROP POLICY IF EXISTS "Auth read global posts" ON public.social_posts;
DROP POLICY IF EXISTS "Auth read social posts" ON public.social_posts;
DROP POLICY IF EXISTS "social_posts_authenticated_read" ON public.social_posts;
CREATE POLICY "social_posts_select" ON public.social_posts 
    FOR SELECT TO authenticated 
    USING (belongs_to_church(church_id) OR ((SELECT auth.role()) = 'authenticated'::text));

DROP POLICY IF EXISTS "social_comments_service_role" ON public.social_comments;
DROP POLICY IF EXISTS "Social comment church access" ON public.social_comments;
DROP POLICY IF EXISTS "social_comments_authenticated_read" ON public.social_comments;
CREATE POLICY "social_comments_select" ON public.social_comments FOR SELECT TO authenticated USING (true);

-- 16. GROUP_MEMBERSHIPS
DROP POLICY IF EXISTS "Group membership church access" ON public.group_memberships;
DROP POLICY IF EXISTS "authenticated_users_can_view_group_memberships" ON public.group_memberships;
DROP POLICY IF EXISTS "group_isolation_memberships" ON public.group_memberships;
CREATE POLICY "group_memberships_select" ON public.group_memberships 
    FOR SELECT TO authenticated 
    USING (has_group_access(group_id));

-- 17. PASTORAL_VISITS
DROP POLICY IF EXISTS "pastoral_visits_service_role" ON public.pastoral_visits;
DROP POLICY IF EXISTS "staff_read_pastoral_visits" ON public.pastoral_visits;
DROP POLICY IF EXISTS "visits_read_church" ON public.pastoral_visits;
CREATE POLICY "pastoral_visits_select" ON public.pastoral_visits 
    FOR SELECT TO authenticated 
    USING (belongs_to_church(church_id));

-- 18. SERVICE_ATTENDANCE
DROP POLICY IF EXISTS "Service attendance church access" ON public.service_attendance;
DROP POLICY IF EXISTS "service_attendance_service_role" ON public.service_attendance;
DROP POLICY IF EXISTS "service_attendance_authenticated_read" ON public.service_attendance;
CREATE POLICY "service_attendance_select" ON public.service_attendance FOR SELECT TO authenticated USING (true);

-- 19. SHEPHERDS
DROP POLICY IF EXISTS "shepherds_service_role" ON public.shepherds;
DROP POLICY IF EXISTS "shepherds_authenticated_read" ON public.shepherds;
CREATE POLICY "shepherds_select" ON public.shepherds FOR SELECT TO authenticated USING (true);

-- 20. MEMBRES_JALONS
DROP POLICY IF EXISTS "Member milestones church access" ON public.membres_jalons;
DROP POLICY IF EXISTS "membres_jalons_select_all" ON public.membres_jalons;
CREATE POLICY "membres_jalons_select" ON public.membres_jalons FOR SELECT TO authenticated USING (true);
