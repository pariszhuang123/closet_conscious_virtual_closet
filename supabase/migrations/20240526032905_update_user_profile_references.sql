-- Step 1: Drop constraints on the `users` table
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_email_key;

-- Step 2: Rename the `users` table to `user_profiles`
ALTER TABLE users RENAME TO user_profiles;

-- Step 3: Re-add constraints to the `user_profiles` table
ALTER TABLE user_profiles
ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (user_id);

ALTER TABLE user_profiles
ADD CONSTRAINT user_profiles_email_key UNIQUE (email);

-- Step 4: Add foreign key constraint to reference `auth.users` table
ALTER TABLE user_profiles
ADD CONSTRAINT user_profiles_auth_users_fk FOREIGN KEY (user_id) REFERENCES auth.users (id) ON DELETE CASCADE;

-- Step 5: Update foreign key references in other tables to point to `user_profiles`
-- Items Table
ALTER TABLE items
DROP CONSTRAINT IF EXISTS items_user_id_fkey;
ALTER TABLE items
ADD CONSTRAINT items_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

-- Outfits Table
ALTER TABLE outfits
DROP CONSTRAINT IF EXISTS outfits_user_id_fkey;
ALTER TABLE outfits
ADD CONSTRAINT outfits_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

-- Outfit Items Table
ALTER TABLE outfit_items
DROP CONSTRAINT IF EXISTS outfit_items_user_id_fkey;
ALTER TABLE outfit_items
ADD CONSTRAINT outfit_items_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

-- Disliked Outfit Items Table
ALTER TABLE disliked_outfit_items
DROP CONSTRAINT IF EXISTS disliked_outfit_items_user_id_fkey;
ALTER TABLE disliked_outfit_items
ADD CONSTRAINT disliked_outfit_items_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

-- Swaps Table
ALTER TABLE swaps
DROP CONSTRAINT IF EXISTS swaps_user_id_fkey;
ALTER TABLE swaps
ADD CONSTRAINT swaps_user_id_fkey FOREIGN KEY (owner_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;
ALTER TABLE swaps
DROP CONSTRAINT IF EXISTS swaps_new_owner_id_fkey;
ALTER TABLE swaps
ADD CONSTRAINT swaps_new_owner_id_fkey FOREIGN KEY (new_owner_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

-- Premium Services Table
ALTER TABLE premium_services
DROP CONSTRAINT IF EXISTS premium_services_user_id_fkey;
ALTER TABLE premium_services
ADD CONSTRAINT premium_services_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

-- Challenges Table
ALTER TABLE challenges
DROP CONSTRAINT IF EXISTS challenges_user_id_fkey;
ALTER TABLE challenges
ADD CONSTRAINT challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

-- User Goals Table
ALTER TABLE user_goals
DROP CONSTRAINT IF EXISTS user_goals_user_id_fkey;
ALTER TABLE user_goals
ADD CONSTRAINT user_goals_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

-- User High Frequency Stats Table
ALTER TABLE user_high_freq_stats
DROP CONSTRAINT IF EXISTS user_high_freq_stats_user_id_fkey;
ALTER TABLE user_high_freq_stats
ADD CONSTRAINT user_high_freq_stats_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

-- User Low Frequency Stats Table
ALTER TABLE user_low_freq_stats
DROP CONSTRAINT IF EXISTS user_low_freq_stats_user_id_fkey;
ALTER TABLE user_low_freq_stats
ADD CONSTRAINT user_low_freq_stats_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;
