BEGIN;

-- Step 1: Remove the existing primary key constraint on id
ALTER TABLE user_low_freq_stats DROP CONSTRAINT IF EXISTS user_low_freq_stats_pkey;
ALTER TABLE user_high_freq_stats DROP CONSTRAINT IF EXISTS user_high_freq_stats_pkey;

-- Step 2: Drop the id column if it is not needed
ALTER TABLE user_low_freq_stats DROP COLUMN IF EXISTS id;
ALTER TABLE user_high_freq_stats DROP COLUMN IF EXISTS id;

-- Step 3: Set user_id as the primary key
ALTER TABLE user_low_freq_stats ADD PRIMARY KEY (user_id);
ALTER TABLE user_high_freq_stats ADD PRIMARY KEY (user_id);

COMMIT;
