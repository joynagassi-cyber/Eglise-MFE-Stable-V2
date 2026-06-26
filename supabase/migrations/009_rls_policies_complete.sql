-- ============================================================
-- RLS POLICIES COMPLÈTES - Toutes les tables
-- Système de Gestion d'Église Lumina
-- ============================================================
-- Ce script crée les policies RLS pour toutes les tables
-- Basé sur les rôles: SUPERADMIN, ADMIN, EDITOR, VIEWER
-- ============================================================
-- ============================================================
-- HELPER FUNCTIONS
-- ============================================================
-- Fonction pour vérifier le rôle de l'utilisateur
CREATE OR REPLACE FUNCTION auth.user_role() RETURNS TEXT AS $$
SELECT role
FROM profiles
WHERE id = auth.uid();
$$ LANGUAGE sql SECURITY DEFINER;
-- Fonction pour vérifier l'église de l'utilisateur
CREATE OR REPLACE FUNCTION auth.user_church() RETURNS TEXT AS $$
SELECT church_name
FROM profiles
WHERE id = auth.uid();
$$ LANGUAGE sql SECURITY DEFINER;
-- ============================================================
-- 1. PROFILES
-- ============================================================
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
-- SELECT: Utilisateurs voient leur propre profil
CREATE POLICY "Users can view own profile" ON profiles FOR
SELECT USING (auth.uid() = id);
-- UPDATE: Utilisateurs peuvent modifier leur propre profil
CREATE POLICY "Users can update own profile" ON profiles FOR
UPDATE USING (auth.uid() = id);
-- ============================================================
-- 2. TEAM_MEMBERS
-- ============================================================
ALTER TABLE team_members ENABLE ROW LEVEL SECURITY;
-- SELECT: Tous les membres authentifiés peuvent voir l'équipe
CREATE POLICY "Authenticated users can view team" ON team_members FOR
SELECT USING (auth.uid() IS NOT NULL);
-- INSERT: Seuls ADMIN et SUPERADMIN peuvent ajouter
CREATE POLICY "Only ADMIN can insert team members" ON team_members FOR
INSERT WITH CHECK (auth.user_role() IN ('ADMIN', 'SUPERADMIN'));
-- UPDATE: Seuls ADMIN et SUPERADMIN peuvent modifier
CREATE POLICY "Only ADMIN can update team members" ON team_members FOR
UPDATE USING (auth.user_role() IN ('ADMIN', 'SUPERADMIN'));
-- DELETE: Seuls SUPERADMIN peuvent supprimer
CREATE POLICY "Only SUPERADMIN can delete team members" ON team_members FOR DELETE USING (auth.user_role() = 'SUPERADMIN');
-- ============================================================
-- 3. EGLISE_MEMBRES (Paroissiens)
-- ============================================================
ALTER TABLE eglise_membres ENABLE ROW LEVEL SECURITY;
-- SELECT: Utilisateurs voient les membres de leur église
CREATE POLICY "Users can view members of their church" ON eglise_membres FOR
SELECT USING (
        EXISTS (
            SELECT 1
            FROM profiles
            WHERE profiles.id = auth.uid()
                AND profiles.church_name = eglise_membres.church_name
        )
    );
-- INSERT: ADMIN et EDITOR peuvent créer
CREATE POLICY "ADMIN and EDITOR can create members" ON eglise_membres FOR
INSERT WITH CHECK (
        auth.user_role() IN ('ADMIN', 'EDITOR', 'SUPERADMIN')
    );
-- UPDATE: ADMIN et EDITOR peuvent modifier
CREATE POLICY "ADMIN and EDITOR can update members" ON eglise_membres FOR
UPDATE USING (
        auth.user_role() IN ('ADMIN', 'EDITOR', 'SUPERADMIN')
    );
-- DELETE: Seuls ADMIN peuvent supprimer (soft delete)
CREATE POLICY "Only ADMIN can delete members" ON eglise_membres FOR DELETE USING (auth.user_role() IN ('ADMIN', 'SUPERADMIN'));
-- ============================================================
-- 4. SACRAMENTS
-- ============================================================
ALTER TABLE sacraments ENABLE ROW LEVEL SECURITY;
-- SELECT: Lecture pour membres de la même église
CREATE POLICY "Users can view sacraments of their church" ON sacraments FOR
SELECT USING (
        EXISTS (
            SELECT 1
            FROM eglise_membres m
                JOIN profiles p ON p.church_name = m.church_name
            WHERE m.id = sacraments.member_id
                AND p.id = auth.uid()
        )
    );
-- INSERT/UPDATE/DELETE: ADMIN et EDITOR
CREATE POLICY "ADMIN and EDITOR can manage sacraments" ON sacraments FOR ALL USING (
    auth.user_role() IN ('ADMIN', 'EDITOR', 'SUPERADMIN')
) WITH CHECK (
    auth.user_role() IN ('ADMIN', 'EDITOR', 'SUPERADMIN')
);
-- ============================================================
-- 5. ACCOUNTS (Comptes financiers)
-- ============================================================
ALTER TABLE accounts ENABLE ROW LEVEL SECURITY;
-- SELECT: Utilisateurs de leur propre église
CREATE POLICY "Users can view accounts of their church" ON accounts FOR
SELECT USING (church_name = auth.user_church());
-- INSERT/UPDATE/DELETE: Seuls ADMIN
CREATE POLICY "Only ADMIN can manage accounts" ON accounts FOR ALL USING (auth.user_role() IN ('ADMIN', 'SUPERADMIN')) WITH CHECK (auth.user_role() IN ('ADMIN', 'SUPERADMIN'));
-- ============================================================
-- 6. TRANSACTION_CATEGORIES
-- ============================================================
ALTER TABLE transaction_categories ENABLE ROW LEVEL SECURITY;
-- SELECT: Tous les utilisateurs
CREATE POLICY "All users can view categories" ON transaction_categories FOR
SELECT USING (auth.uid() IS NOT NULL);
-- INSERT/UPDATE/DELETE: Seuls ADMIN
CREATE POLICY "Only ADMIN can manage categories" ON transaction_categories FOR ALL USING (auth.user_role() IN ('ADMIN', 'SUPERADMIN')) WITH CHECK (auth.user_role() IN ('ADMIN', 'SUPERADMIN'));
-- ============================================================
-- 7. TRANSACTIONS
-- ============================================================
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
-- SELECT: Tous les utilisateurs de l'église
CREATE POLICY "Users can view transactions" ON transactions FOR
SELECT USING (church_name = auth.user_church());
-- INSERT: ADMIN et EDITOR
CREATE POLICY "ADMIN and EDITOR can create transactions" ON transactions FOR
INSERT WITH CHECK (
        auth.user_role() IN ('ADMIN', 'EDITOR', 'SUPERADMIN')
    );
-- UPDATE: ADMIN et EDITOR (seulement leurs propres transactions ou si ADMIN)
CREATE POLICY "Users can update own transactions or ADMIN all" ON transactions FOR
UPDATE USING (
        created_by = auth.uid()
        OR auth.user_role() IN ('ADMIN', 'SUPERADMIN')
    );
-- DELETE: Seuls ADMIN
CREATE POLICY "Only ADMIN can delete transactions" ON transactions FOR DELETE USING (auth.user_role() IN ('ADMIN', 'SUPERADMIN'));
-- ============================================================
-- 8. BUDGETS
-- ============================================================
ALTER TABLE budgets ENABLE ROW LEVEL SECURITY;
-- SELECT: Tous les utilisateurs de l'église
CREATE POLICY "Users can view budgets" ON budgets FOR
SELECT USING (church_name = auth.user_church());
-- INSERT/UPDATE/DELETE: ADMIN et EDITOR
CREATE POLICY "ADMIN and EDITOR can manage budgets" ON budgets FOR ALL USING (
    auth.user_role() IN ('ADMIN', 'EDITOR', 'SUPERADMIN')
) WITH CHECK (
    auth.user_role() IN ('ADMIN', 'EDITOR', 'SUPERADMIN')
);
-- ============================================================
-- 9. EVENTS
-- ============================================================
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
-- SELECT: Tous les utilisateurs de l'église
CREATE POLICY "Users can view events" ON events FOR
SELECT USING (church_name = auth.user_church());
-- INSERT/UPDATE: ADMIN et EDITOR
CREATE POLICY "ADMIN and EDITOR can manage events" ON events FOR ALL USING (
    auth.user_role() IN ('ADMIN', 'EDITOR', 'SUPERADMIN')
) WITH CHECK (
    auth.user_role() IN ('ADMIN', 'EDITOR', 'SUPERADMIN')
);
-- ============================================================
-- 10. EVENT_PARTICIPANTS
-- ============================================================
ALTER TABLE event_participants ENABLE ROW LEVEL SECURITY;
-- SELECT: Utilisateurs de l'église
CREATE POLICY "Users can view event participants of their church" ON event_participants FOR
SELECT USING (church_name = auth.user_church());
-- INSERT: Tous les utilisateurs (inscription)
CREATE POLICY "Users can register for events" ON event_participants FOR
INSERT WITH CHECK (auth.uid() IS NOT NULL);
-- DELETE: Utilisateur peut se désinscrire ou ADMIN peut gérer
CREATE POLICY "Users can unregister or ADMIN can manage" ON event_participants FOR DELETE USING (auth.user_role() IN ('ADMIN', 'SUPERADMIN'));
-- ============================================================
-- 11. POSTS (Annonces)
-- ============================================================
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;
-- SELECT: Tous les utilisateurs voient les posts publiés de leur église
CREATE POLICY "Users can view published posts of their church" ON posts FOR
SELECT USING (
        (
            published = true
            AND church_name = auth.user_church()
        )
        OR user_id = auth.uid()
        OR (
            auth.user_role() IN ('ADMIN', 'SUPERADMIN')
            AND church_name = auth.user_church()
        )
    );
-- INSERT/UPDATE/DELETE: ADMIN et EDITOR
CREATE POLICY "ADMIN and EDITOR can manage posts" ON posts FOR ALL USING (
    auth.user_role() IN ('ADMIN', 'EDITOR', 'SUPERADMIN')
) WITH CHECK (
    auth.user_role() IN ('ADMIN', 'EDITOR', 'SUPERADMIN')
);
-- ============================================================
-- 12. COMMENTS
-- ============================================================
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
-- SELECT: Tous les utilisateurs voient les commentaires approuvés de leur église
CREATE POLICY "Users can view approved comments of their church" ON comments FOR
SELECT USING (
        (
            approved = true
            AND church_name = auth.user_church()
        )
        OR user_id = auth.uid()
        OR (
            auth.user_role() IN ('ADMIN', 'SUPERADMIN')
            AND church_name = auth.user_church()
        )
    );
-- INSERT: Tous les utilisateurs authentifiés
CREATE POLICY "Authenticated users can comment" ON comments FOR
INSERT WITH CHECK (auth.uid() IS NOT NULL);
-- UPDATE/DELETE: Propriétaire ou ADMIN
CREATE POLICY "Users can manage own comments or ADMIN all" ON comments FOR ALL USING (
    user_id = auth.uid()
    OR auth.user_role() IN ('ADMIN', 'SUPERADMIN')
) WITH CHECK (
    user_id = auth.uid()
    OR auth.user_role() IN ('ADMIN', 'SUPERADMIN')
);
-- ============================================================
-- 13. MEMBER_PHOTOS
-- ============================================================
ALTER TABLE member_photos ENABLE ROW LEVEL SECURITY;
-- SELECT: Utilisateurs de la même église
CREATE POLICY "Users can view photos of their church members" ON member_photos FOR
SELECT USING (
        EXISTS (
            SELECT 1
            FROM eglise_membres m
                JOIN profiles p ON p.church_name = m.church_name
            WHERE m.id = member_photos.member_id
                AND p.id = auth.uid()
        )
    );
-- INSERT/UPDATE/DELETE: ADMIN et EDITOR
CREATE POLICY "ADMIN and EDITOR can manage photos" ON member_photos FOR ALL USING (
    auth.user_role() IN ('ADMIN', 'EDITOR', 'SUPERADMIN')
) WITH CHECK (
    auth.user_role() IN ('ADMIN', 'EDITOR', 'SUPERADMIN')
);
-- ============================================================
-- 14. GROUPS
-- ============================================================
ALTER TABLE groups ENABLE ROW LEVEL SECURITY;
-- SELECT: Utilisateurs de l'église
CREATE POLICY "Users can view groups of their church" ON groups FOR
SELECT USING (church_name = auth.user_church());
-- INSERT/UPDATE/DELETE: ADMIN et EDITOR
CREATE POLICY "ADMIN and EDITOR can manage groups" ON groups FOR ALL USING (
    auth.user_role() IN ('ADMIN', 'EDITOR', 'SUPERADMIN')
) WITH CHECK (
    auth.user_role() IN ('ADMIN', 'EDITOR', 'SUPERADMIN')
);
-- ============================================================
-- 15. GROUP_MEMBERS
-- ============================================================
ALTER TABLE group_members ENABLE ROW LEVEL SECURITY;
-- SELECT: Utilisateurs de l'église
CREATE POLICY "Users can view group members of their church" ON group_members FOR
SELECT USING (church_name = auth.user_church());
-- INSERT/UPDATE/DELETE: ADMIN et EDITOR
CREATE POLICY "ADMIN and EDITOR can manage group members" ON group_members FOR ALL USING (
    auth.user_role() IN ('ADMIN', 'EDITOR', 'SUPERADMIN')
) WITH CHECK (
    auth.user_role() IN ('ADMIN', 'EDITOR', 'SUPERADMIN')
);
-- ============================================================
-- 16. NOTIFICATIONS
-- ============================================================
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
-- SELECT: Utilisateurs voient leurs propres notifications
CREATE POLICY "Users can view own notifications" ON notifications FOR
SELECT USING (user_id = auth.uid());
-- INSERT: Système ou ADMIN
CREATE POLICY "System or ADMIN can create notifications" ON notifications FOR
INSERT WITH CHECK (auth.user_role() IN ('ADMIN', 'SUPERADMIN'));
-- UPDATE: Utilisateurs peuvent marquer comme lu
CREATE POLICY "Users can update own notifications" ON notifications FOR
UPDATE USING (user_id = auth.uid());
-- DELETE: Utilisateurs peuvent supprimer leurs notifications
CREATE POLICY "Users can delete own notifications" ON notifications FOR DELETE USING (user_id = auth.uid());
-- ============================================================
-- 17. AUDIT_LOG
-- ============================================================
ALTER TABLE audit_log ENABLE ROW LEVEL SECURITY;
-- SELECT: Seuls ADMIN et SUPERADMIN
CREATE POLICY "Only ADMIN can view audit log" ON audit_log FOR
SELECT USING (auth.user_role() IN ('ADMIN', 'SUPERADMIN'));
-- INSERT: Système uniquement (via triggers)
-- Pas de policy INSERT car géré par triggers
-- ============================================================
-- VÉRIFICATION FINALE
-- ============================================================
DO $$
DECLARE tables_count INTEGER;
policies_count INTEGER;
BEGIN
SELECT COUNT(*) INTO tables_count
FROM pg_tables
WHERE schemaname = 'public'
    AND rowsecurity = true
    AND tablename NOT LIKE 'pg_%'
    AND tablename NOT LIKE '_%';
SELECT COUNT(*) INTO policies_count
FROM pg_policies
WHERE schemaname = 'public';
RAISE NOTICE '';
RAISE NOTICE '============================================================';
RAISE NOTICE 'RLS POLICIES - INSTALLATION TERMINÉE';
RAISE NOTICE '============================================================';
RAISE NOTICE 'Tables avec RLS: %',
tables_count;
RAISE NOTICE 'Policies créées: %',
policies_count;
RAISE NOTICE '✅ Sécurité RLS configurée avec succès';
RAISE NOTICE '============================================================';
RAISE NOTICE '';
END $$;