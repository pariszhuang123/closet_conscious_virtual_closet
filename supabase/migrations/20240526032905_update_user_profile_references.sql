-- Step 1: Rename the existing `users` table to `user_profiles`
ALTER TABLE users RENAME TO user_profiles;

-- Ensure user_id is primary key and reference auth.users table
ALTER TABLE user_profiles
DROP CONSTRAINT user_profiles_pkey;

ALTER TABLE user_profiles
ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (user_id);

ALTER TABLE user_profiles
ADD CONSTRAINT user_profiles_auth_users_fk FOREIGN KEY (user_id) REFERENCES auth.users (id) ON DELETE CASCADE;

-- Step 2: Create the function to sync `auth.users` with `user_profiles`
CREATE OR REPLACE FUNCTION sync_user_profile()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO user_profiles (user_id, name, email, role, created_at, updated_at)
    VALUES (NEW.id, NEW.raw_user_meta_data->>'full_name', NEW.email, 'authenticated', now(), now());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Step 3: Create the trigger to call the function
CREATE TRIGGER create_user_profile
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE FUNCTION sync_user_profile();

-- Step 4: Update references in other tables

-- Items Table
ALTER TABLE items
DROP CONSTRAINT items_user_id_fkey;
ALTER TABLE items
ADD CONSTRAINT items_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

-- Outfits Table
ALTER TABLE outfits
DROP CONSTRAINT outfits_user_id_fkey;
ALTER TABLE outfits
ADD CONSTRAINT outfits_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

-- Outfit Items Table
ALTER TABLE outfit_items
DROP CONSTRAINT outfit_items_user_id_fkey;
ALTER TABLE outfit_items
ADD CONSTRAINT outfit_items_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

-- Disliked Outfit Items Table
ALTER TABLE disliked_outfit_items
DROP CONSTRAINT disliked_outfit_items_user_id_fkey;
ALTER TABLE disliked_outfit_items
ADD CONSTRAINT disliked_outfit_items_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

-- Swaps Table
ALTER TABLE swaps
DROP CONSTRAINT swaps_user_id_fkey;
ALTER TABLE swaps
ADD CONSTRAINT swaps_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

-- Premium Services Table
ALTER TABLE premium_services
DROP CONSTRAINT premium_services_user_id_fkey;
ALTER TABLE premium_services
ADD CONSTRAINT premium_services_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

-- Challenges Table
ALTER TABLE challenges
DROP CONSTRAINT challenges_user_id_fkey;
ALTER TABLE challenges
ADD CONSTRAINT challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

-- User Goals Table
ALTER TABLE user_goals
DROP CONSTRAINT user_goals_user_id_fkey;
ALTER TABLE user_goals
ADD CONSTRAINT user_goals_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

-- User High Frequency Stats Table
ALTER TABLE user_high_freq_stats
DROP CONSTRAINT user_high_freq_stats_user_id_fkey;
ALTER TABLE user_high_freq_stats
ADD CONSTRAINT user_high_freq_stats_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

-- User Low Frequency Stats Table
ALTER TABLE user_low_freq_stats
DROP CONSTRAINT user_low_freq_stats_user_id_fkey;
ALTER TABLE user_low_freq_stats
ADD CONSTRAINT user_low_freq_stats_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;
