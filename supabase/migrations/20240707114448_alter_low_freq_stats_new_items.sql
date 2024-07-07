-- Start a transaction
BEGIN;

-- Rename columns
ALTER TABLE public.user_low_freq_stats
RENAME COLUMN new_clothings TO new_items;

ALTER TABLE public.user_low_freq_stats
RENAME COLUMN new_clothings_value TO new_items_value;

-- Add comment for usage_features column
COMMENT ON COLUMN public.user_low_freq_stats.new_items IS 'The number of new items purchased by the user after initial closet uploaded.';

-- Add comment for challenge_features column
COMMENT ON COLUMN public.user_low_freq_stats.new_items_value IS 'The value of new items purchased by the user after initial closet uploaded.';

-- Commit the transaction
COMMIT;
