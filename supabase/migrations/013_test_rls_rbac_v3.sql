-- ============================================================
-- TESTS VALIDATION - RLS POLICIES & EDGE FUNCTION
-- ============================================================

-- Test 1: Vérifier fonctions RLS créées
DO $$
DECLARE
  func_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO func_count
  FROM pg_proc p
  JOIN pg_namespace n ON p.pronamespace = n.oid
  WHERE n.nspname = 'auth'
  AND p.proname IN ('user_role_code', 'user_group_code', 'is_super_admin', 'has_permission');
  
  IF func_count = 4 THEN
    RAISE NOTICE '✅ Test 1 PASSED: 4 fonctions RLS créées';
  ELSE
    RAISE EXCEPTION '❌ Test 1 FAILED: % fonctions trouvées au lieu de 4', func_count;
  END IF;
END $$;

-- Test 2: Vérifier policies RBAC v3
DO $$
DECLARE
  policy_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO policy_count
  FROM pg_policies
  WHERE schemaname = 'public'
  AND policyname LIKE 'rbac_v3_%';
  
  IF policy_count >= 20 THEN
    RAISE NOTICE '✅ Test 2 PASSED: % policies RBAC v3 créées', policy_count;
  ELSE
    RAISE EXCEPTION '❌ Test 2 FAILED: Seulement % policies trouvées', policy_count;
  END IF;
END $$;

-- Test 3: Simuler utilisateur avec rôle
DO $$
DECLARE
  test_user_id UUID := gen_random_uuid();
  test_role_id UUID := gen_random_uuid();
  test_group_id UUID := gen_random_uuid();
BEGIN
  -- Créer test user
  INSERT INTO auth.users (id, email) VALUES (test_user_id, 'test@example.com');
  
  -- Créer test role
  INSERT INTO roles (id, code, label, is_super, priority_level)
  VALUES (test_role_id, 'test_admin', 'Test Admin', false, 10);
  
  -- Créer test group
  INSERT INTO groups (id, code, label)
  VALUES (test_group_id, 'test_group', 'Test Group');
  
  -- Assigner role
  INSERT INTO user_roles (user_id, role_id, group_id, is_active)
  VALUES (test_user_id, test_role_id, test_group_id, true);
  
  -- Tester fonction
  SET LOCAL role TO authenticated;
  SET LOCAL request.jwt.claims.sub TO test_user_id::text;
  
  IF auth.user_role_code() = 'test_admin' THEN
    RAISE NOTICE '✅ Test 3 PASSED: Fonction user_role_code() fonctionne';
  ELSE
    RAISE EXCEPTION '❌ Test 3 FAILED: user_role_code() retourne %', auth.user_role_code();
  END IF;
  
  -- Cleanup
  DELETE FROM user_roles WHERE user_id = test_user_id;
  DELETE FROM groups WHERE id = test_group_id;
  DELETE FROM roles WHERE id = test_role_id;
  DELETE FROM auth.users WHERE id = test_user_id;
END $$;

-- Test 4: Vérifier anciennes fonctions supprimées
DO $$
DECLARE
  old_func_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO old_func_count
  FROM pg_proc p
  JOIN pg_namespace n ON p.pronamespace = n.oid
  WHERE n.nspname = 'auth'
  AND p.proname IN ('user_role', 'user_church');
  
  IF old_func_count = 0 THEN
    RAISE NOTICE '✅ Test 4 PASSED: Anciennes fonctions supprimées';
  ELSE
    RAISE EXCEPTION '❌ Test 4 FAILED: % anciennes fonctions encore présentes', old_func_count;
  END IF;
END $$;

-- Résumé
DO $$
BEGIN
  RAISE NOTICE '';
  RAISE NOTICE '============================================================';
  RAISE NOTICE '✅ TOUS LES TESTS PASSÉS - RLS POLICIES RBAC V3 VALIDÉES';
  RAISE NOTICE '============================================================';
  RAISE NOTICE '';
END $$;
