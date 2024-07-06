-- Start a transaction
BEGIN;

-- Rename columns
ALTER TABLE premium_services
RENAME COLUMN usage_feature TO usage_features,
RENAME COLUMN challenge_feature TO challenge_features;

-- Add comment for one_off_features column
COMMENT ON COLUMN premium_services.one_off_features IS 'Stores features that are one-time or non-recurring in nature.';

-- Add comment for usage_features column
COMMENT ON COLUMN premium_services.usage_features IS 'Holds features related to user-specific usage limits or capabilities. This may include different subscription levels such as bronze, silver, or gold which dictate limits or capacities like the number of items a user can upload.';

-- Add comment for challenge_features column
COMMENT ON COLUMN premium_services.challenge_features IS 'Contains features associated with user challenges or achievements. This can track user participation in challenges, progress, and rewards.';

-- Add Boolean for closet upload
ALTER TABLE items
ADD COLUMN closet_upload BOOLEAN DEFAULT FALSE;

-- Add comment for closet_upload column
COMMENT ON COLUMN items.closet_upload IS 'Indicates whether the item was uploaded during the initial closet setup or added later. TRUE means the item was part of the initial upload, and FALSE means it was added afterward.';

-- Add columns to user_high_freq_stats
ALTER TABLE user_high_freq_stats
ADD COLUMN initial_upload_item_count integer NOT NULL DEFAULT 0,
ADD COLUMN initial_upload_items_worn_count integer NOT NULL DEFAULT 0;

-- Add comments to the columns in user_high_freq_stats
COMMENT ON COLUMN public.user_high_freq_stats.initial_upload_item_count IS 'The count of items uploaded during the initial closet upload';
COMMENT ON COLUMN public.user_high_freq_stats.initial_upload_items_worn_count IS 'The count of items worn from the initial closet upload';

-- Add a generated column for the percentage of items worn vs. items uploaded
ALTER TABLE public.user_high_freq_stats
ADD COLUMN initial_upload_items_worn_percentage numeric(5, 2) GENERATED ALWAYS AS (
    CASE
        WHEN initial_upload_item_count = 0 THEN 0.00
        ELSE LEAST(GREATEST((initial_upload_items_worn_count::numeric / initial_upload_item_count::numeric) * 100, 0), 100)
    END
) STORED;

-- Add comment for the generated column
COMMENT ON COLUMN public.user_high_freq_stats.initial_upload_items_worn_percentage IS 'The percentage of items worn versus items uploaded during the initial closet upload';

-- Commit the transaction
COMMIT;
