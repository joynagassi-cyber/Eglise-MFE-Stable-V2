-- Performance Optimization: Add missing indexes for foreign keys
-- Generated based on identifying unindexed foreign keys in Supabase Performance Advisor
-- admin_activations
CREATE INDEX IF NOT EXISTS idx_admin_activations_code_id ON public.admin_activations (code_id);
CREATE INDEX IF NOT EXISTS idx_admin_activations_user_id ON public.admin_activations (user_id);
-- admin_codes
CREATE INDEX IF NOT EXISTS idx_admin_codes_created_by ON public.admin_codes (created_by);
-- app_themes
CREATE INDEX IF NOT EXISTS idx_app_themes_created_by ON public.app_themes (created_by);
-- approval_decisions
CREATE INDEX IF NOT EXISTS idx_approval_decisions_decided_by ON public.approval_decisions (decided_by);
CREATE INDEX IF NOT EXISTS idx_approval_decisions_delegated_to ON public.approval_decisions (delegated_to);
CREATE INDEX IF NOT EXISTS idx_approval_decisions_request_id ON public.approval_decisions (request_id);
CREATE INDEX IF NOT EXISTS idx_approval_decisions_step_id ON public.approval_decisions (step_id);
-- approval_matrix_steps
CREATE INDEX IF NOT EXISTS idx_approval_matrix_steps_approver_user_id ON public.approval_matrix_steps (approver_user_id);
CREATE INDEX IF NOT EXISTS idx_approval_matrix_steps_matrix_id ON public.approval_matrix_steps (matrix_id);
-- approval_notifications
CREATE INDEX IF NOT EXISTS idx_approval_notifications_request_id ON public.approval_notifications (request_id);
-- approval_requests
CREATE INDEX IF NOT EXISTS idx_approval_requests_matrix_id ON public.approval_requests (matrix_id);
-- approval_signatures
CREATE INDEX IF NOT EXISTS idx_approval_signatures_signed_by ON public.approval_signatures (signed_by);
-- bank_reconciliations
CREATE INDEX IF NOT EXISTS idx_bank_reconciliations_bank_account_id ON public.bank_reconciliations (bank_account_id);
CREATE INDEX IF NOT EXISTS idx_bank_reconciliations_reconciled_by ON public.bank_reconciliations (reconciled_by);
-- compliance_results
CREATE INDEX IF NOT EXISTS idx_compliance_results_rule_id ON public.compliance_results (rule_id);
-- event_attendances
CREATE INDEX IF NOT EXISTS idx_event_attendances_event_id ON public.event_attendances (event_id);
CREATE INDEX IF NOT EXISTS idx_event_attendances_member_id ON public.event_attendances (member_id);
-- family_relationships
CREATE INDEX IF NOT EXISTS idx_family_relationships_related_member_id ON public.family_relationships (related_member_id);
-- finance_transactions
CREATE INDEX IF NOT EXISTS idx_finance_transactions_approved_by ON public.finance_transactions (approved_by);
-- journal_entries
CREATE INDEX IF NOT EXISTS idx_journal_entries_created_by ON public.journal_entries (created_by);
CREATE INDEX IF NOT EXISTS idx_journal_entries_posting_user ON public.journal_entries (posting_user);
-- member_history
CREATE INDEX IF NOT EXISTS idx_member_history_member_id ON public.member_history (member_id);
CREATE INDEX IF NOT EXISTS idx_member_history_performed_by ON public.member_history (performed_by);
-- members
CREATE INDEX IF NOT EXISTS idx_members_shepherd_id ON public.members (shepherd_id);
-- proof_images
CREATE INDEX IF NOT EXISTS idx_proof_images_uploaded_by ON public.proof_images (uploaded_by);
-- reconciliation_items
CREATE INDEX IF NOT EXISTS idx_reconciliation_items_reconciliation_id ON public.reconciliation_items (reconciliation_id);
CREATE INDEX IF NOT EXISTS idx_reconciliation_items_transaction_id ON public.reconciliation_items (transaction_id);
-- report_snapshots
CREATE INDEX IF NOT EXISTS idx_report_snapshots_sealed_by ON public.report_snapshots (sealed_by);
-- reports
CREATE INDEX IF NOT EXISTS idx_reports_approved_by ON public.reports (approved_by);
CREATE INDEX IF NOT EXISTS idx_reports_generated_by ON public.reports (generated_by);
-- role_permissions
CREATE INDEX IF NOT EXISTS idx_role_permissions_permission_id ON public.role_permissions (permission_id);
-- spiritual_tracking
CREATE INDEX IF NOT EXISTS idx_spiritual_tracking_member_id ON public.spiritual_tracking (member_id);
CREATE INDEX IF NOT EXISTS idx_spiritual_tracking_shepherd_id ON public.spiritual_tracking (shepherd_id);
-- system_settings
CREATE INDEX IF NOT EXISTS idx_system_settings_created_by ON public.system_settings (created_by);
-- transaction_images
CREATE INDEX IF NOT EXISTS idx_transaction_images_uploaded_by ON public.transaction_images (uploaded_by);
-- transaction_seals
CREATE INDEX IF NOT EXISTS idx_transaction_seals_signed_by ON public.transaction_seals (signed_by);
-- transactions
CREATE INDEX IF NOT EXISTS idx_transactions_created_by ON public.transactions (created_by);
CREATE INDEX IF NOT EXISTS idx_transactions_journal_entry_id ON public.transactions (journal_entry_id);
CREATE INDEX IF NOT EXISTS idx_transactions_validated_by ON public.transactions (validated_by);
-- user_roles
CREATE INDEX IF NOT EXISTS idx_user_roles_role_id ON public.user_roles (role_id);
-- user_sessions
CREATE INDEX IF NOT EXISTS idx_user_sessions_active_group_id ON public.user_sessions (active_group_id);
CREATE INDEX IF NOT EXISTS idx_user_sessions_active_role_id ON public.user_sessions (active_role_id);