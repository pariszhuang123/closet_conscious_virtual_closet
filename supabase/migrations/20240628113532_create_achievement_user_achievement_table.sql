-- Create achievements table
CREATE TABLE achievements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT UNIQUE NOT NULL,
    description TEXT NOT NULL,
    type TEXT CHECK (type IN ('one-time', 'repeatable')) NOT NULL,
    badge_url TEXT NOT NULL
);

-- Add comments to achievements table
COMMENT ON TABLE achievements IS 'Stores information about the various achievements that users can earn.';
COMMENT ON COLUMN achievements.id IS 'Unique identifier for each achievement, generated automatically.';
COMMENT ON COLUMN achievements.name IS 'Name of the achievement, must be unique.';
COMMENT ON COLUMN achievements.description IS 'Description of the achievement.';
COMMENT ON COLUMN achievements.type IS 'Type of achievement, either one-time or repeatable.';
COMMENT ON COLUMN achievements.badge_url IS 'URL of the badge image associated with the achievement.';

-- Enable RLS for achievements table
ALTER TABLE achievements ENABLE ROW LEVEL SECURITY;

-- Allow supabase_admin full access to achievements table
CREATE POLICY "supabase_admin_full_access"
ON achievements
FOR ALL
USING (auth.role() = 'supabase_admin');

-- Create user_achievements table
CREATE TABLE user_achievements (
    user_id UUID REFERENCES user_profiles(id) ON DELETE CASCADE,
    achievement_id UUID REFERENCES achievements(id),
    achieved_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, achievement_id)
);

-- Add comments to user_achievements table
COMMENT ON TABLE user_achievements IS 'Tracks which users have earned which achievements and when.';
COMMENT ON COLUMN user_achievements.user_id IS 'Unique identifier of the user who earned the achievement, references users(user_id) with cascade delete.';
COMMENT ON COLUMN user_achievements.achievement_id IS 'Unique identifier of the earned achievement, references achievements(id).';
COMMENT ON COLUMN user_achievements.achieved_at IS 'Timestamp when the achievement was earned by the user, defaults to current timestamp.';

-- Enable RLS for user_achievements table
ALTER TABLE user_achievements ENABLE ROW LEVEL SECURITY;

-- Allow users to select their own user_achievements records
CREATE POLICY "user_achievements_select_own"
ON user_ach-- Create the achievements table
           CREATE TABLE achievements (
               achievement_name VARCHAR(255) PRIMARY KEY,
               badge_url VARCHAR(255) NOT NULL,
               description TEXT NOT NULL,
               type TEXT CHECK (type IN ('one-time', 'repeatable')) NOT NULL
           );

           -- Create the user_achievements table
           CREATE TABLE user_achievements (
               user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
               achievement_name VARCHAR(255) NOT NULL,
               awarded_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),  -- Combining 'awarded_date' and 'achieved_at' into a single column
               FOREIGN KEY (achievement_name) REFERENCES achievements(achievement_name) ON DELETE RESTRICT,
               PRIMARY KEY (user_id, achievement_name)
           );
ievements
FOR SELECT
USING (user_id = auth.uid());

-- Allow users to insert their own user_achievements records
CREATE POLICY "user_achievements_insert_own"
ON user_achievements
FOR INSERT
WITH CHECK (user_id = auth.uid());

-- Allow users to update their own user_achievements records
CREATE POLICY "user_achievements_update_own"
ON user_achievements
FOR UPDATE
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- Allow users to delete their own user_achievements records
CREATE POLICY "user_achievements_delete_own"
ON user_achievements
FOR DELETE
USING (user_id = auth.uid());
