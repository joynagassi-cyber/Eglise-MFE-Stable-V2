-- ################################################################################
-- # SCRIPT DE DURCISSEMENT FINAL - PHASE 2 (PERFORMANCE & SÉCURITÉ)
-- # Objectif : Indexation des FK, Suppression des index inutilisés restants, 
-- #            et Résolution des "Multiple Permissive Policies".
-- ################################################################################

-- ================================================================================
-- 1. INDEXATION DES CLÉS ÉTRANGÈRES MANQUANTES (PERFORMANCE)
-- ================================================================================

CREATE INDEX IF NOT EXISTS idx_annonces_church_id ON public.annonces(church_id);
CREATE INDEX IF NOT EXISTS idx_approval_decisions_request_id ON public.approval_decisions(request_id);
CREATE INDEX IF NOT EXISTS idx_church_members_church_id ON public.church_members(church_id);
CREATE INDEX IF NOT EXISTS idx_church_services_church_id ON public.church_services(church_id);
CREATE INDEX IF NOT EXISTS idx_conversations_church_id ON public.conversations(church_id);
CREATE INDEX IF NOT EXISTS idx_events_church_id ON public.events(church_id);
CREATE INDEX IF NOT EXISTS idx_financial_accounts_church_id ON public.financial_accounts(church_id);
CREATE INDEX IF NOT EXISTS idx_members_church_id ON public.members(church_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_pastoral_visits_church_id ON public.pastoral_visits(church_id);
CREATE INDEX IF NOT EXISTS idx_shepherds_church_id ON public.shepherds(church_id);
CREATE INDEX IF NOT EXISTS idx_social_comments_post_id ON public.social_comments(post_id);
CREATE INDEX IF NOT EXISTS idx_social_posts_church_id ON public.social_posts(church_id);
CREATE INDEX IF NOT EXISTS idx_user_churches_church_id ON public.user_churches(church_id);


-- ================================================================================
-- 2. SUPPRESSION DES INDEX INUTILISÉS (OPTIMISATION)
-- ================================================================================

DROP INDEX IF EXISTS public.idx_visites_membre_date;
DROP INDEX IF EXISTS public.idx_visites_statut_date;
DROP INDEX IF EXISTS public.idx_visites_date_range;
DROP INDEX IF EXISTS public.profiles_email_idx;
DROP INDEX IF EXISTS public.idx_group_memberships_group_id;
DROP INDEX IF EXISTS public.idx_team_members_role_id;
DROP INDEX IF EXISTS public.idx_team_invites_role_id;
DROP INDEX IF EXISTS public.idx_finance_transactions_category_id;
DROP INDEX IF EXISTS public.idx_finance_transactions_member_id;
DROP INDEX IF EXISTS public.idx_ft_mission;
DROP INDEX IF EXISTS public.idx_compliance_results_transaction;
DROP INDEX IF EXISTS public.idx_reports_church_date;
DROP INDEX IF EXISTS public.idx_reports_type;
DROP INDEX IF EXISTS public.idx_shepherds_member_id;
DROP INDEX IF EXISTS public.idx_pastoral_visits_shepherd_id;
DROP INDEX IF EXISTS public.idx_pastoral_visits_member_id;
DROP INDEX IF EXISTS public.idx_service_attendance_service_id;
DROP INDEX IF EXISTS public.idx_service_attendance_member_id;
DROP INDEX IF EXISTS public.idx_chat_messages_sender_id;
DROP INDEX IF EXISTS public.idx_chat_messages_reply_to_id;
DROP INDEX IF EXISTS public.idx_social_posts_author_id;
DROP INDEX IF EXISTS public.idx_social_comments_author_id;
DROP INDEX IF EXISTS public.idx_social_comments_reply_to_id;
DROP INDEX IF EXISTS public.idx_sacraments_church_id;
DROP INDEX IF EXISTS public.idx_trusted_devices_user;
DROP INDEX IF EXISTS public.idx_trusted_devices_expires;
DROP INDEX IF EXISTS public.idx_device_events_device;
DROP INDEX IF EXISTS public.idx_device_events_user;
DROP INDEX IF EXISTS public.idx_teams_slug;
DROP INDEX IF EXISTS public.idx_team_roles_team;
DROP INDEX IF EXISTS public.idx_team_members_team;
DROP INDEX IF EXISTS public.idx_team_invites_team;
DROP INDEX IF EXISTS public.idx_team_invites_email;
DROP INDEX IF EXISTS public.idx_audit_logs_actor;
DROP INDEX IF EXISTS public.idx_audit_logs_action;
DROP INDEX IF EXISTS public.idx_audit_logs_entity;
DROP INDEX IF EXISTS public.idx_audit_logs_occurred;
DROP INDEX IF EXISTS public.idx_membres_jalons_membre;
DROP INDEX IF EXISTS public.idx_membres_jalons_jalon;
DROP INDEX IF EXISTS public.idx_membres_jalons_date;
DROP INDEX IF EXISTS public.idx_member_photos_active;
DROP INDEX IF EXISTS public.idx_member_photos_uploaded_at;
DROP INDEX IF EXISTS public.idx_member_photo_logs_member_id;
DROP INDEX IF EXISTS public.idx_member_photo_logs_triggered_at;
DROP INDEX IF EXISTS public.idx_member_photo_logs_action;
DROP INDEX IF EXISTS public.idx_approvals_transaction;
DROP INDEX IF EXISTS public.idx_circles_church;
DROP INDEX IF EXISTS public.idx_circle_members_circle;
DROP INDEX IF EXISTS public.idx_user_roles_user;
DROP INDEX IF EXISTS public.idx_user_roles_group;
DROP INDEX IF EXISTS public.idx_reconciliation_items_reconciliation_id;
DROP INDEX IF EXISTS public.idx_members_shepherd_id;
DROP INDEX IF EXISTS public.idx_accounts_parent;
DROP INDEX IF EXISTS public.idx_reports_status;
DROP INDEX IF EXISTS public.idx_reconciliation_items_transaction_id;
DROP INDEX IF EXISTS public.idx_reports_approved_by;
DROP INDEX IF EXISTS public.idx_reports_generated_by;
DROP INDEX IF EXISTS public.idx_journal_entries_date;
DROP INDEX IF EXISTS public.idx_journal_entries_journal;
DROP INDEX IF EXISTS public.idx_circle_members_member;
DROP INDEX IF EXISTS public.idx_ledger_account;
DROP INDEX IF EXISTS public.idx_ledger_group;
DROP INDEX IF EXISTS public.idx_ledger_journal_entry;
DROP INDEX IF EXISTS public.idx_transaction_images_tx;
DROP INDEX IF EXISTS public.idx_transactions_group_status;
DROP INDEX IF EXISTS public.idx_transactions_type;
DROP INDEX IF EXISTS public.idx_transactions_internal;
DROP INDEX IF EXISTS public.idx_reports_report_type;
DROP INDEX IF EXISTS public.idx_transactions_status_created_at;
DROP INDEX IF EXISTS public.idx_transactions_group_id_status;
DROP INDEX IF EXISTS public.idx_proof_images_transaction_id;
DROP INDEX IF EXISTS public.idx_proof_images_sha256_client;
DROP INDEX IF EXISTS public.idx_drive_files_checksum;
DROP INDEX IF EXISTS public.idx_members_status;
DROP INDEX IF EXISTS public.idx_drive_files_r2_key;
DROP INDEX IF EXISTS public.idx_church_members_user_id;
DROP INDEX IF EXISTS public.idx_drive_files_status;
DROP INDEX IF EXISTS public.idx_member_photos_r2_key;
DROP INDEX IF EXISTS public.idx_sacraments_member_names;
DROP INDEX IF EXISTS public.idx_sacraments_godparents;
DROP INDEX IF EXISTS public.idx_sacraments_cert_number;
DROP INDEX IF EXISTS public.idx_approval_requests_status;
DROP INDEX IF EXISTS public.idx_donors_church;
DROP INDEX IF EXISTS public.idx_donors_member;
DROP INDEX IF EXISTS public.idx_donations_donor;
DROP INDEX IF EXISTS public.idx_donations_church;
DROP INDEX IF EXISTS public.idx_donations_date;
DROP INDEX IF EXISTS public.idx_financial_accounts_group_id;
DROP INDEX IF EXISTS public.idx_admin_activations_code_id;
DROP INDEX IF EXISTS public.idx_approval_decisions_step_id;
DROP INDEX IF EXISTS public.idx_approval_notifications_request_id;
DROP INDEX IF EXISTS public.idx_approval_requests_matrix_id;
DROP INDEX IF EXISTS public.idx_bank_reconciliations_bank_account_id;
DROP INDEX IF EXISTS public.idx_compliance_results_rule_id;
DROP INDEX IF EXISTS public.idx_event_attendances_event_id;
DROP INDEX IF EXISTS public.idx_event_attendances_member_id;
DROP INDEX IF EXISTS public.idx_family_relationships_related_member_id;
DROP INDEX IF EXISTS public.idx_journal_entries_created_by;
DROP INDEX IF EXISTS public.idx_journal_entries_posting_user;
DROP INDEX IF EXISTS public.idx_role_permissions_permission_id;
DROP INDEX IF EXISTS public.idx_transaction_images_uploaded_by;
DROP INDEX IF EXISTS public.idx_transactions_created_by;
DROP INDEX IF EXISTS public.idx_transactions_journal_entry_id;
DROP INDEX IF EXISTS public.idx_transactions_validated_by;
DROP INDEX IF EXISTS public.idx_chat_messages_conversation_created;
DROP INDEX IF EXISTS public.idx_user_presence_status;
DROP INDEX IF EXISTS public.idx_app_themes_created_by;
DROP INDEX IF EXISTS public.idx_system_settings_created_by;
DROP INDEX IF EXISTS public.idx_spiritual_tracking_church_id;
DROP INDEX IF EXISTS public.idx_spiritual_tracking_shepherd_id;
DROP INDEX IF EXISTS public.idx_service_attendance_checked_in_by;
DROP INDEX IF EXISTS public.idx_sacraments_created_by;
DROP INDEX IF EXISTS public.idx_sacraments_updated_by;
DROP INDEX IF EXISTS public.idx_user_sessions_role_group;
DROP INDEX IF EXISTS public.idx_user_encryption_keys_user_id;
DROP INDEX IF EXISTS public.idx_approval_notifications_recipient_id;
DROP INDEX IF EXISTS public.idx_audit_logs_actor_id;
DROP INDEX IF EXISTS public.idx_role_code_audit_log_user_id;
DROP INDEX IF EXISTS public.idx_transaction_categories_church_id;
DROP INDEX IF EXISTS public.idx_transaction_categories_parent_id;
DROP INDEX IF EXISTS public.idx_transactions_group_id;
DROP INDEX IF EXISTS public.idx_finance_transactions_fund_reconciled;
DROP INDEX IF EXISTS public.idx_approvals_transaction_id;
DROP INDEX IF EXISTS public.idx_approvals_approver_id;
DROP INDEX IF EXISTS public.idx_approval_signatures_request_id;
DROP INDEX IF EXISTS public.idx_approval_requests_church_id;
DROP INDEX IF EXISTS public.idx_report_snapshots_report_id;
DROP INDEX IF EXISTS public.idx_transaction_seals_transaction_id;
DROP INDEX IF EXISTS public.idx_family_relationships_related_id;
DROP INDEX IF EXISTS public.idx_donations_transaction_id;
DROP INDEX IF EXISTS public.idx_role_codes_used;
DROP INDEX IF EXISTS public.idx_finance_transactions_group;
DROP INDEX IF EXISTS public.idx_rec_tx_next;
DROP INDEX IF EXISTS public.idx_rec_tx_church;
DROP INDEX IF EXISTS public.idx_group_memberships_group;
DROP INDEX IF EXISTS public.idx_admin_codes_created_by;
DROP INDEX IF EXISTS public.idx_group_codes_used;
DROP INDEX IF EXISTS public.idx_finance_transactions_church;
DROP INDEX IF EXISTS public.idx_finance_transactions_category;
DROP INDEX IF EXISTS public.idx_finance_transactions_member;
DROP INDEX IF EXISTS public.idx_finance_transactions_account;
DROP INDEX IF EXISTS public.idx_finance_transactions_budget;
DROP INDEX IF EXISTS public.idx_finance_transactions_mission;
DROP INDEX IF EXISTS public.idx_group_memberships_member;
DROP INDEX IF EXISTS public.idx_recurring_transactions_church;
DROP INDEX IF EXISTS public.idx_recurring_transactions_account;
DROP INDEX IF EXISTS public.idx_recurring_transactions_category;
DROP INDEX IF EXISTS public.idx_recurring_transactions_created_by;
DROP INDEX IF EXISTS public.idx_family_relationships_church_id;
DROP INDEX IF EXISTS public.idx_member_history_church_id;
DROP INDEX IF EXISTS public.idx_members_spouse_member_id;
DROP INDEX IF EXISTS public.idx_finance_transactions_reconciled_by;
DROP INDEX IF EXISTS public.idx_role_secret_codes_used_by;
DROP INDEX IF EXISTS public.idx_user_roles_role;
DROP INDEX IF EXISTS public.idx_audit_user_id;
DROP INDEX IF EXISTS public.idx_audit_created_at;
DROP INDEX IF EXISTS public.idx_audit_success;
DROP INDEX IF EXISTS public.idx_group_secret_codes_used_by;
DROP INDEX IF EXISTS public.idx_user_roles_church;
DROP INDEX IF EXISTS public.idx_approval_matrix_steps_matrix;
DROP INDEX IF EXISTS public.idx_approval_matrix_steps_user;
DROP INDEX IF EXISTS public.idx_user_sessions_active_group;


-- ================================================================================
-- 3. RÉSOLUTION DES "MULTIPLE PERMISSIVE POLICIES" (SÉCURITÉ)
--    Note : On migre les politiques vers 'authenticated' pour éviter les conflits
--    avec les politiques 'anon' par défaut ou redondantes.
-- ================================================================================

-- Table: annonces
DO $$ BEGIN 
    ALTER POLICY "Auth read global ads" ON public.annonces TO authenticated; 
    ALTER POLICY "church_read_annonces" ON public.annonces TO authenticated;
EXCEPTION WHEN undefined_object THEN NULL; END $$;

-- Table: app_settings
DO $$ BEGIN 
    ALTER POLICY "Everyone can read app settings" ON public.app_settings TO authenticated; 
    ALTER POLICY "SuperAdmins can manage app settings" ON public.app_settings TO authenticated;
EXCEPTION WHEN undefined_object THEN NULL; END $$;

-- Table: app_themes
DO $$ BEGIN 
    ALTER POLICY "app_themes_manage_own" ON public.app_themes TO authenticated;
    ALTER POLICY "app_themes_select_auth" ON public.app_themes TO authenticated;
    ALTER POLICY "app_themes_service_role" ON public.app_themes TO service_role;
EXCEPTION WHEN undefined_object THEN NULL; END $$;

-- Table: chat_messages
DO $$ BEGIN 
    ALTER POLICY "Auth read chat messages" ON public.chat_messages TO authenticated;
    ALTER POLICY "Chat message church access" ON public.chat_messages TO authenticated;
    ALTER POLICY "Participants can read messages" ON public.chat_messages TO authenticated;
    ALTER POLICY "Sender is participant" ON public.chat_messages TO authenticated;
EXCEPTION WHEN undefined_object THEN NULL; END $$;

-- Table: church_members
DO $$ BEGIN 
    ALTER POLICY "church_members_manage_own" ON public.church_members TO authenticated;
    ALTER POLICY "church_members_select_own_church" ON public.church_members TO authenticated;
    ALTER POLICY "church_members_service_role" ON public.church_members TO service_role;
EXCEPTION WHEN undefined_object THEN NULL; END $$;

-- Table: event_attendances, family_relationships, member_history
DO $$ BEGIN 
    ALTER POLICY "Event attendance church access" ON public.event_attendances TO authenticated;
    ALTER POLICY "event_attendances_authenticated" ON public.event_attendances TO authenticated;
    ALTER POLICY "Family relationship church access" ON public.family_relationships TO authenticated;
    ALTER POLICY "family_relationships_authenticated" ON public.family_relationships TO authenticated;
    ALTER POLICY "Member history church access" ON public.member_history TO authenticated;
    ALTER POLICY "member_history_authenticated" ON public.member_history TO authenticated;
EXCEPTION WHEN undefined_object THEN NULL; END $$;

-- Table: missions
DO $$ BEGIN 
    ALTER POLICY "Group linked access for missions" ON public.missions TO authenticated;
    ALTER POLICY "missions_manage_own" ON public.missions TO authenticated;
EXCEPTION WHEN undefined_object THEN NULL; END $$;

-- ################################################################################
-- FIN DU SCRIPT
-- ################################################################################
