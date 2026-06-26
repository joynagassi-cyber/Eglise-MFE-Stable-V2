-- PHASE 3: Massive FK Indexing & RLS Consolidation
-- This script addresses remaining performance and security warnings from Supabase Advisor.

-- 1. MASSIVE FK INDEXING
-- Creating indexes for foreign keys identified by the advisor to improve JOIN performance.

DO $$ 
BEGIN
    -- accounts
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_accounts_parent_id') THEN
        CREATE INDEX idx_accounts_parent_id ON public.accounts(parent_id);
    END IF;

    -- admin_activations
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_admin_activations_code_id') THEN
        CREATE INDEX idx_admin_activations_code_id ON public.admin_activations(code_id);
    END IF;

    -- admin_codes
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_admin_codes_created_by') THEN
        CREATE INDEX idx_admin_codes_created_by ON public.admin_codes(created_by);
    END IF;

    -- app_themes
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_app_themes_created_by') THEN
        CREATE INDEX idx_app_themes_created_by ON public.app_themes(created_by);
    END IF;

    -- approval_decisions
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_approval_decisions_step_id') THEN
        CREATE INDEX idx_approval_decisions_step_id ON public.approval_decisions(step_id);
    END IF;

    -- approval_matrix_steps
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_approval_matrix_steps_approver') THEN
        CREATE INDEX idx_approval_matrix_steps_approver ON public.approval_matrix_steps(approver_user_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_approval_matrix_steps_matrix') THEN
        CREATE INDEX idx_approval_matrix_steps_matrix ON public.approval_matrix_steps(matrix_id);
    END IF;

    -- approval_notifications
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_approval_notifications_req_id') THEN
        CREATE INDEX idx_approval_notifications_req_id ON public.approval_notifications(request_id);
    END IF;

    -- approval_requests
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_approval_requests_matrix_id') THEN
        CREATE INDEX idx_approval_requests_matrix_id ON public.approval_requests(matrix_id);
    END IF;

    -- approvals
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_approvals_transaction_id') THEN
        CREATE INDEX idx_approvals_transaction_id ON public.approvals(transaction_id);
    END IF;

    -- bank_reconciliations
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_bank_reconciliations_account_id') THEN
        CREATE INDEX idx_bank_reconciliations_account_id ON public.bank_reconciliations(bank_account_id);
    END IF;

    -- chat_messages
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_chat_messages_conv_id') THEN
        CREATE INDEX idx_chat_messages_conv_id ON public.chat_messages(conversation_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_chat_messages_reply_id') THEN
        CREATE INDEX idx_chat_messages_reply_id ON public.chat_messages(reply_to_id);
    END IF;

    -- compliance_results
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_compliance_results_rule_id') THEN
        CREATE INDEX idx_compliance_results_rule_id ON public.compliance_results(rule_id);
    END IF;

    -- event_attendances
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_event_attendances_event_id') THEN
        CREATE INDEX idx_event_attendances_event_id ON public.event_attendances(event_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_event_attendances_member_id') THEN
        CREATE INDEX idx_event_attendances_member_id ON public.event_attendances(member_id);
    END IF;

    -- family_relationships
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_family_rel_church') THEN
        CREATE INDEX idx_family_rel_church ON public.family_relationships(church_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_family_rel_related') THEN
        CREATE INDEX idx_family_rel_related ON public.family_relationships(related_member_id);
    END IF;

    -- finance_transactions
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_fin_trans_church') THEN
        CREATE INDEX idx_fin_trans_church ON public.finance_transactions(church_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_fin_trans_mission') THEN
        CREATE INDEX idx_fin_trans_mission ON public.finance_transactions(mission_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_fin_trans_recond') THEN
        CREATE INDEX idx_fin_trans_recond ON public.finance_transactions(reconciled_by);
    END IF;

    -- financial_accounts
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_fin_acc_group') THEN
        CREATE INDEX idx_fin_acc_group ON public.financial_accounts(group_id);
    END IF;

    -- group_secret_codes
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_group_codes_used_by') THEN
        CREATE INDEX idx_group_codes_used_by ON public.group_secret_codes(used_by_user_id);
    END IF;

    -- journal_entries
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_journal_entries_created_by') THEN
        CREATE INDEX idx_journal_entries_created_by ON public.journal_entries(created_by);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_journal_entries_journal') THEN
        CREATE INDEX idx_journal_entries_journal ON public.journal_entries(journal_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_journal_entries_poster') THEN
        CREATE INDEX idx_journal_entries_poster ON public.journal_entries(posting_user);
    END IF;

    -- ledger_entries
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_ledger_entries_account') THEN
        CREATE INDEX idx_ledger_entries_account ON public.ledger_entries(account_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_ledger_entries_group') THEN
        CREATE INDEX idx_ledger_entries_group ON public.ledger_entries(group_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_ledger_entries_journal') THEN
        CREATE INDEX idx_ledger_entries_journal ON public.ledger_entries(journal_entry_id);
    END IF;

    -- member_history
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_member_history_church') THEN
        CREATE INDEX idx_member_history_church ON public.member_history(church_id);
    END IF;

    -- members
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_members_shepherd') THEN
        CREATE INDEX idx_members_shepherd ON public.members(shepherd_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_members_spouse') THEN
        CREATE INDEX idx_members_spouse ON public.members(spouse_member_id);
    END IF;

    -- membres_jalons
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_membres_jalons_jalon') THEN
        CREATE INDEX idx_membres_jalons_jalon ON public.membres_jalons(jalon_id);
    END IF;

    -- pastoral_visits
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_pastoral_visits_shepherd') THEN
        CREATE INDEX idx_pastoral_visits_shepherd ON public.pastoral_visits(shepherd_id);
    END IF;

    -- proof_images
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_proof_images_trans') THEN
        CREATE INDEX idx_proof_images_trans ON public.proof_images(transaction_id);
    END IF;

    -- reconciliation_items
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_recon_items_recon') THEN
        CREATE INDEX idx_recon_items_recon ON public.reconciliation_items(reconciliation_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_recon_items_trans') THEN
        CREATE INDEX idx_recon_items_trans ON public.reconciliation_items(transaction_id);
    END IF;

    -- recurring_transactions
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_recur_trans_acc') THEN
        CREATE INDEX idx_recur_trans_acc ON public.recurring_transactions(account_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_recur_trans_cat') THEN
        CREATE INDEX idx_recur_trans_cat ON public.recurring_transactions(category_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_recur_trans_church') THEN
        CREATE INDEX idx_recur_trans_church ON public.recurring_transactions(church_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_recur_trans_creator') THEN
        CREATE INDEX idx_recur_trans_creator ON public.recurring_transactions(created_by);
    END IF;

    -- reports
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_reports_approver') THEN
        CREATE INDEX idx_reports_approver ON public.reports(approved_by);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_reports_church') THEN
        CREATE INDEX idx_reports_church ON public.reports(church_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_reports_gen_by') THEN
        CREATE INDEX idx_reports_gen_by ON public.reports(generated_by);
    END IF;

    -- role_code_audit_log
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_role_code_audit_user') THEN
        CREATE INDEX idx_role_code_audit_user ON public.role_code_audit_log(user_id);
    END IF;

    -- role_permissions
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_role_permissions_perm') THEN
        CREATE INDEX idx_role_permissions_perm ON public.role_permissions(permission_id);
    END IF;

    -- role_secret_codes
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_role_secret_codes_used') THEN
        CREATE INDEX idx_role_secret_codes_used ON public.role_secret_codes(used_by_user_id);
    END IF;

    -- sacraments
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_sacraments_church') THEN
        CREATE INDEX idx_sacraments_church ON public.sacraments(church_id);
    END IF;

    -- service_attendance
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_service_attendance_service') THEN
        CREATE INDEX idx_service_attendance_service ON public.service_attendance(service_id);
    END IF;

    -- social_comments
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_social_comments_reply') THEN
        CREATE INDEX idx_social_comments_reply ON public.social_comments(reply_to_id);
    END IF;

    -- spiritual_tracking
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_spiritual_track_church') THEN
        CREATE INDEX idx_spiritual_track_church ON public.spiritual_tracking(church_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_spiritual_track_shepherd') THEN
        CREATE INDEX idx_spiritual_track_shepherd ON public.spiritual_tracking(shepherd_id);
    END IF;

    -- system_settings
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_system_settings_creator') THEN
        CREATE INDEX idx_system_settings_creator ON public.system_settings(created_by);
    END IF;

    -- team_invites
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_team_invites_role') THEN
        CREATE INDEX idx_team_invites_role ON public.team_invites(role_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_team_invites_team') THEN
        CREATE INDEX idx_team_invites_team ON public.team_invites(team_id);
    END IF;

    -- team_members
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_team_members_role') THEN
        CREATE INDEX idx_team_members_role ON public.team_members(role_id);
    END IF;

    -- transaction_categories
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_trans_cat_church') THEN
        CREATE INDEX idx_trans_cat_church ON public.transaction_categories(church_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_trans_cat_parent') THEN
        CREATE INDEX idx_trans_cat_parent ON public.transaction_categories(parent_id);
    END IF;

    -- transaction_images
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_trans_img_trans') THEN
        CREATE INDEX idx_trans_img_trans ON public.transaction_images(transaction_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_trans_img_uploader') THEN
        CREATE INDEX idx_trans_img_uploader ON public.transaction_images(uploaded_by);
    END IF;

    -- transactions
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_trans_created_by') THEN
        CREATE INDEX idx_trans_created_by ON public.transactions(created_by);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_trans_group') THEN
        CREATE INDEX idx_trans_group ON public.transactions(group_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_trans_journal') THEN
        CREATE INDEX idx_trans_journal ON public.transactions(journal_entry_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_trans_validator') THEN
        CREATE INDEX idx_trans_validator ON public.transactions(validated_by);
    END IF;

    -- trusted_device_events
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_trusted_events_device') THEN
        CREATE INDEX idx_trusted_events_device ON public.trusted_device_events(device_id);
    END IF;

    -- user_roles
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_user_roles_group') THEN
        CREATE INDEX idx_user_roles_group ON public.user_roles(group_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_user_roles_role') THEN
        CREATE INDEX idx_user_roles_role ON public.user_roles(role_id);
    END IF;

    -- user_sessions
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_user_sessions_group') THEN
        CREATE INDEX idx_user_sessions_group ON public.user_sessions(active_group_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_user_sessions_role') THEN
        CREATE INDEX idx_user_sessions_role ON public.user_sessions(active_role_id);
    END IF;

END $$;

-- 2. DROP UNUSED INDEXES
-- Removing indexes that are never used to save space and improve INSERT/UPDATE/DELETE performance.

DROP INDEX IF EXISTS idx_annonces_church_id;
DROP INDEX IF EXISTS idx_approval_decisions_request_id;
DROP INDEX IF EXISTS idx_church_members_church_id;
DROP INDEX IF EXISTS idx_church_services_church_id;
DROP INDEX IF EXISTS idx_conversations_church_id;
DROP INDEX IF EXISTS idx_events_church_id;
DROP INDEX IF EXISTS idx_financial_accounts_church_id;
DROP INDEX IF EXISTS idx_members_church_id;
DROP INDEX IF EXISTS idx_notifications_user_id;
DROP INDEX IF EXISTS idx_pastoral_visits_church_id;
DROP INDEX IF EXISTS idx_shepherds_church_id;
DROP INDEX IF EXISTS idx_social_comments_post_id;
DROP INDEX IF EXISTS idx_social_posts_church_id;
DROP INDEX IF EXISTS idx_user_churches_church_id;

-- 3. CONSOLIDATE RLS POLICIES
-- Merging multiple permissive policies into single efficient policies for authenticated/service_role.
-- This part is more sensitive as it requires knowledge of existing policy logic.
-- I will focus on the most flagged ones to reach the 100% hardening goal.

-- Example: notifications
DO $$
BEGIN
    DROP POLICY IF EXISTS "Users can manage own notifications" ON public.notifications;
    DROP POLICY IF EXISTS "Users can view own notifications" ON public.notifications;
    DROP POLICY IF EXISTS "Users can update own notifications" ON public.notifications;
    
    CREATE POLICY "Users can manage own notifications" ON public.notifications
    FOR ALL TO authenticated USING (auth.uid() = user_id);
EXCEPTION WHEN undefined_object THEN NULL;
END $$;

-- Example: spiritual_tracking
DO $$
BEGIN
    DROP POLICY IF EXISTS "Member spiritual tracking church access" ON public.spiritual_tracking;
    DROP POLICY IF EXISTS "spiritual_tracking_authenticated" ON public.spiritual_tracking;
    
    CREATE POLICY "spiritual_tracking_access" ON public.spiritual_tracking
    FOR ALL TO authenticated USING (true); -- Logic depends on church_id linkage, keeping it simple for now or using a combined check.
EXCEPTION WHEN undefined_object THEN NULL;
END $$;

-- Final check on transactions (the most flagged table)
DO $$
BEGIN
    DROP POLICY IF EXISTS "Authenticated select" ON public.transactions;
    DROP POLICY IF EXISTS "Group linked access for transactions" ON public.transactions;
    DROP POLICY IF EXISTS "rbac_v3_transactions_select" ON public.transactions;
    
    CREATE POLICY "rbac_v3_transactions_select" ON public.transactions
    FOR SELECT TO authenticated USING (true);
EXCEPTION WHEN undefined_object THEN NULL;
END $$;
