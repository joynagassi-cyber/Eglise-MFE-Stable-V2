-- Migration: Fonction check_email_exists
-- À exécuter dans: Supabase Dashboard → SQL Editor

-- Fonction pour vérifier si un email existe déjà
CREATE OR REPLACE FUNCTION check_email_exists(email_to_check TEXT)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM auth.users 
    WHERE email = email_to_check
  );
END;
$$;

-- Permissions
GRANT EXECUTE ON FUNCTION check_email_exists(TEXT) TO anon, authenticated;

COMMENT ON FUNCTION check_email_exists IS 
'Vérifie si un email existe déjà dans auth.users (pour UX inscription)';
