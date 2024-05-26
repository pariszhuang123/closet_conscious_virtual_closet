-- Step 1: Drop foreign key constraints in dependent tables
ALTER TABLE items DROP CONSTRAINT IF EXISTS items_user_id_fkey;
ALTER TABLE outfits DROP CONSTRAINT IF EXISTS outfits_user_id_fkey;
ALTER TABLE outfit_items DROP CONSTRAINT IF EXISTS outfit_items_user_id_fkey;
ALTER TABLE disliked_outfit_items DROP CONSTRAINT IF EXISTS disliked_outfit_items_user_id_fkey;
ALTER TABLE swaps DROP CONSTRAINT IF EXISTS swaps_owner_id_fkey;
ALTER TABLE swaps DROP CONSTRAINT IF EXISTS swaps_new_owner_id_fkey;
ALTER TABLE premium_services DROP CONSTRAINT IF EXISTS premium_services_user_id_fkey;
ALTER TABLE challenges DROP CONSTRAINT IF EXISTS challenges_user_id_fkey;
ALTER TABLE user_goals DROP CONSTRAINT IF EXISTS user_goals_user_id_fkey;
ALTER TABLE user_high_freq_stats DROP CONSTRAINT IF EXISTS user_high_freq_stats_user_id_fkey;
ALTER TABLE user_low_freq_stats DROP CONSTRAINT IF EXISTS user_low_freq_stats_user_id_fkey;

-- Step 2: Drop primary key constraint from `users` table
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_pkey;

-- Step 3: Rename the `users` table to `user_profiles`
ALTER TABLE users RENAME TO user_profiles;

-- Step 4: Re-add primary key constraint to `user_profiles` table
ALTER TABLE user_profiles
ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (user_id);

-- Step 5: Add foreign key constraint to reference `auth.users` table
ALTER TABLE user_profiles
ADD CONSTRAINT user_profiles_auth_users_fk FOREIGN KEY (user_id) REFERENCES auth.users (id) ON DELETE CASCADE;

-- Step 6: Re-add foreign key constraints to dependent tables
ALTER TABLE items
ADD CONSTRAINT items_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

ALTER TABLE outfits
ADD CONSTRAINT outfits_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

ALTER TABLE outfit_items
ADD CONSTRAINT outfit_items_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

ALTER TABLE disliked_outfit_items
ADD CONSTRAINT disliked_outfit_items_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

-- Corrected constraint names for swaps table
ALTER TABLE swaps
ADD CONSTRAINT swaps_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

ALTER TABLE swaps
ADD CONSTRAINT swaps_new_owner_id_fkey FOREIGN KEY (new_owner_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

ALTER TABLE premium_services
ADD CONSTRAINT premium_services_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

ALTER TABLE challenges
ADD CONSTRAINT challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

ALTER TABLE user_goals
ADD CONSTRAINT user_goals_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

ALTER TABLE user_high_freq_stats
ADD CONSTRAINT user_high_freq_stats_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;

ALTER TABLE user_low_freq_stats
ADD CONSTRAINT user_low_freq_stats_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_profiles (user_id) ON DELETE CASCADE;
