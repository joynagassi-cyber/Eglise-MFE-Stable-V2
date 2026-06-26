-- Database Hardening Migration (Fixed Casting)
-- Generated on: 2026-03-18
-- Target: Supabase Project vvcdmqpbwfyhkzalwdli

BEGIN;

--------------------------------------------------------------------------------
-- 1. SECURITY: Search Path Hardening for Functions
--------------------------------------------------------------------------------
ALTER FUNCTION public.verify_group_secret_code SET search_path = public;
ALTER FUNCTION public.mark_role_code_as_used SET search_path = public;
ALTER FUNCTION public.log_role_code_attempt SET search_path = public;
ALTER FUNCTION public.verify_universal_code SET search_path = public;
ALTER FUNCTION public.fn_transfer_funds SET search_path = public;
ALTER FUNCTION public.fn_quarterly_transfer_funds SET search_path = public;
ALTER FUNCTION public.mark_group_code_used SET search_path = public;
ALTER FUNCTION public.verify_role_secret_code SET search_path = public;
ALTER FUNCTION public.handle_new_user SET search_path = public;
ALTER FUNCTION public.is_super_admin SET search_path = public;

--------------------------------------------------------------------------------
-- 2. PERFORMANCE: Foreign Key Indexing
--------------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_finance_transactions_reconciled_by ON public.finance_transactions(reconciled_by);
CREATE INDEX IF NOT EXISTS idx_role_secret_codes_used_by ON public.role_secret_codes(used_by_user_id);
CREATE INDEX IF NOT EXISTS idx_group_secret_codes_used_by ON public.group_secret_codes(used_by_user_id);
CREATE INDEX IF NOT EXISTS idx_user_sessions_active_group ON public.user_sessions(active_group_id);

--------------------------------------------------------------------------------
-- 3. SECURITY: Fix permissive RLS on recurring_transactions
--------------------------------------------------------------------------------
DROP POLICY IF EXISTS "Enable access for authenticated users" ON public.recurring_transactions;
CREATE POLICY "recurring_transactions_isolation_policy" ON public.recurring_transactions
FOR ALL TO authenticated
USING (church_id::uuid IN (SELECT get_auth_user_churches()))
WITH CHECK (church_id::uuid IN (SELECT get_auth_user_churches()));

--------------------------------------------------------------------------------
-- 4. PERFORMANCE: RLS Policy Optimization (InitPlan / (SELECT auth.uid()))
--------------------------------------------------------------------------------
-- Wrapping auth.uid(), auth.role(), and auth.jwt() in subqueries to force 
-- single evaluation per query (Postgres InitPlan optimization). 
-- Explicit casting ::uuid applied where columns and auth results differ.

-- approval_decisions (decided_by is uuid)
ALTER POLICY "Insert decisions" ON public.approval_decisions WITH CHECK ((SELECT auth.uid()) = decided_by);
ALTER POLICY "Read decisions" ON public.approval_decisions USING ((SELECT auth.role()) = 'authenticated');

-- approval_notifications (recipient_id is uuid)
ALTER POLICY "Read own notifications" ON public.approval_notifications USING ((SELECT auth.uid()) = recipient_id);

-- approval_requests (requested_by is uuid)
ALTER POLICY "Insert requests" ON public.approval_requests WITH CHECK ((SELECT auth.uid()) = requested_by);
ALTER POLICY "Read requests" ON public.approval_requests USING ((SELECT auth.role()) = 'authenticated');

-- approval_signatures (signed_by is uuid)
ALTER POLICY "Users can sign" ON public.approval_signatures WITH CHECK ((SELECT auth.uid()) = signed_by);

-- approvals (approver_id is uuid)
ALTER POLICY "approval_create" ON public.approvals WITH CHECK (approver_id = (SELECT auth.uid()));

-- audit_logs (actor_id is uuid)
ALTER POLICY "SuperAdmins can view all audit logs" ON public.audit_logs USING (((SELECT auth.jwt()) ->> 'role'::text) = 'super_admin'::text);

-- conversations
ALTER POLICY "conversations_authenticated_read" ON public.conversations USING ((SELECT auth.role()) = 'authenticated');

-- donations
ALTER POLICY "donations_manage" ON public.donations USING (EXISTS ( SELECT 1 FROM user_roles ur JOIN roles r ON ur.role_id = r.id WHERE ur.user_id = (SELECT auth.uid()) AND r.code = ANY (ARRAY['admin'::text, 'pasteur'::text, 'tresorier'::text]) ));

-- events
ALTER POLICY "events_service_role" ON public.events USING ((SELECT auth.role()) = 'service_role');

-- finance_transactions
ALTER POLICY "finance_transactions_service_role" ON public.finance_transactions USING ((SELECT auth.role()) = 'service_role');

-- financial_accounts
ALTER POLICY "financial_accounts_authenticated_read" ON public.financial_accounts USING ((SELECT auth.role()) = 'authenticated');
ALTER POLICY "financial_accounts_service_role" ON public.financial_accounts USING ((SELECT auth.role()) = 'service_role');

-- group_secret_codes
ALTER POLICY "Superadmins manage group codes" ON public.group_secret_codes USING (EXISTS ( SELECT 1 FROM user_roles ur JOIN roles r ON ur.role_id = r.id WHERE ur.user_id = (SELECT auth.uid()) AND r.is_super = true ));

-- groups
ALTER POLICY "groups_isolation_policy" ON public.groups USING ((church_id::uuid IN ( SELECT uc.church_id::uuid FROM user_churches uc WHERE (uc.user_id = (SELECT auth.uid())) )) OR (SELECT is_super_admin()));
ALTER POLICY "groups_service_role" ON public.groups USING ((SELECT auth.role()) = 'service_role');

-- proof_images
ALTER POLICY "Insert proof images" ON public.proof_images WITH CHECK ((SELECT auth.role()) = 'authenticated');
ALTER POLICY "Read proof images" ON public.proof_images USING ((SELECT auth.role()) = 'authenticated');

-- report_snapshots
ALTER POLICY "Authenticated select snapshots" ON public.report_snapshots USING ((SELECT auth.role()) = 'authenticated');

-- role_code_audit_log
ALTER POLICY "Only superadmins can view audit logs" ON public.role_code_audit_log USING (EXISTS ( SELECT 1 FROM user_roles ur JOIN roles r ON r.id = ur.role_id WHERE ur.user_id = (SELECT auth.uid()) AND r.is_super = true ));

-- role_secret_codes
ALTER POLICY "Superadmins can manage codes" ON public.role_secret_codes USING (EXISTS ( SELECT 1 FROM user_roles ur JOIN roles r ON ur.role_id = r.id WHERE ur.user_id = (SELECT auth.uid()) AND r.is_super = true ));

-- service_attendance
ALTER POLICY "service_attendance_authenticated_read" ON public.service_attendance USING ((SELECT auth.role()) = 'authenticated');

-- shepherds
ALTER POLICY "shepherds_authenticated_read" ON public.shepherds USING ((SELECT auth.role()) = 'authenticated');
ALTER POLICY "shepherds_service_role" ON public.shepherds USING ((SELECT auth.role()) = 'service_role');

-- social_comments
ALTER POLICY "social_comments_authenticated_read" ON public.social_comments USING ((SELECT auth.role()) = 'authenticated');
ALTER POLICY "social_comments_service_role" ON public.social_comments USING ((SELECT auth.role()) = 'service_role');

-- social_posts
ALTER POLICY "Auth read global posts" ON public.social_posts USING ((SELECT auth.role()) = 'authenticated');
ALTER POLICY "social_posts_authenticated_read" ON public.social_posts USING ((SELECT auth.role()) = 'authenticated');

-- transaction_seals
ALTER POLICY "Read seals" ON public.transaction_seals USING ((SELECT auth.role()) = 'authenticated');

-- transactions
ALTER POLICY "Authenticated select" ON public.transactions USING ((SELECT auth.role()) = 'authenticated');

-- validation_thresholds
ALTER POLICY "Authenticated select thresholds" ON public.validation_thresholds USING ((SELECT auth.role()) = 'authenticated');
ALTER POLICY "SuperAdmins can manage thresholds" ON public.validation_thresholds USING (((SELECT auth.jwt()) ->> 'role'::text) = 'super_admin'::text);

--------------------------------------------------------------------------------
-- 5. PERFORMANCE: Cleanup Unused Indexes (Conservative)
--------------------------------------------------------------------------------
DROP INDEX IF EXISTS public.idx_sync_dlq_church_id;
DROP INDEX IF EXISTS public.idx_sync_dlq_status;

COMMIT;
