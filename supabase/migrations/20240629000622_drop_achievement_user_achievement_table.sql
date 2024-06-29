-- Drop RLS policies
DROP POLICY IF EXISTS user_achievements_select_own ON user_achievements;
DROP POLICY IF EXISTS user_achievements_insert_own ON user_achievements;
DROP POLICY IF EXISTS user_achievements_update_own ON user_achievements;
DROP POLICY IF EXISTS user_achievements_delete_own ON user_achievements;
DROP POLICY IF EXISTS supabase_admin_full_access ON achievements;

-- Drop tables
DROP TABLE IF EXISTS user_achievements;
DROP TABLE IF EXISTS achievements;
