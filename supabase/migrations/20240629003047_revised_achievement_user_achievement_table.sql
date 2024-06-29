-- Create the achievements table
CREATE TABLE achievements (
    achievement_name VARCHAR(255) PRIMARY KEY,
    badge_url VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    type TEXT CHECK (type IN ('one-time', 'repeatable')) NOT NULL
);
-- Add comments to achievements table
COMMENT ON TABLE achievements IS 'Stores information about the various achievements that users can earn.';
COMMENT ON COLUMN achievements.achievement_name IS 'Name of the achievement, must be unique.';
COMMENT ON COLUMN achievements.description IS 'Description of the achievement.';
COMMENT ON COLUMN achievements.type IS 'Type of achievement, either one-time or repeatable.';
COMMENT ON COLUMN achievements.badge_url IS 'URL of the badge image associated with the achievement.';

-- Enable RLS for achievements table
ALTER TABLE achievements ENABLE ROW LEVEL SECURITY;

-- Allow read access to all authenticated users
create policy "achievements_read_access"
on achievements for select
to anon         -- the Postgres Role (recommended)
using ( true ); -- the actual Policy

-- Create the user_achievements table
CREATE TABLE user_achievements (
    user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    achievement_name VARCHAR(255) NOT NULL,
    awarded_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    FOREIGN KEY (achievement_name) REFERENCES achievements(achievement_name) ON DELETE RESTRICT,
    PRIMARY KEY (user_id, achievement_name)
);

-- Add comments to user_achievements table
COMMENT ON TABLE user_achievements IS 'Tracks which users have earned which achievements and when.';
COMMENT ON COLUMN user_achievements.user_id IS 'Unique identifier of the user who earned the achievement, references user_profiles(id) with cascade delete.'; COMMENT ON COLUMN user_achievements.achievement_name IS 'Name of the achievement, must be unique, references achievements(achievement_name).'; COMMENT ON COLUMN user_achievements.awarded_at IS 'Timestamp when the achievement was earned by the user, defaults to current timestamp.';

-- Policy for users to select their own achievements
CREATE OR REPLACE POLICY "user_achievements_select_own" ON public.user_achievements
FOR SELECT
USING ((SELECT auth.uid()) = user_id);

-- Policy for users to insert their own achievements
CREATE OR REPLACE POLICY "user_achievements_insert_own" ON public.user_achievements
FOR INSERT
WITH CHECK ((SELECT auth.uid()) = user_id);

-- Policy for users to update their own achievements
CREATE OR REPLACE POLICY "user_achievements_update_own" ON public.user_achievements
FOR UPDATE
USING ((SELECT auth.uid()) = user_id)
WITH CHECK ((SELECT auth.uid()) = user_id);

-- Policy for users to delete their own achievements
CREATE OR REPLACE POLICY "user_achievements_delete_own" ON public.user_achievements
FOR DELETE
USING ((SELECT auth.uid()) = user_id);
