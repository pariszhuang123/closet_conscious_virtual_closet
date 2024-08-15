-- Step 1: Drop the existing check constraint if it exists
ALTER TABLE public.items DROP CONSTRAINT IF EXISTS items_colour_variations_check;

-- Step 2: Add the new check constraint
ALTER TABLE public.items ADD CONSTRAINT items_colour_variations_check
CHECK (colour_variations = ANY (ARRAY['light', 'medium', 'dark', 'cc_none']));

-- Step 3: Set the column to NOT NULL and set the default value
ALTER TABLE public.items ALTER COLUMN colour_variations SET DEFAULT 'cc_none';
ALTER TABLE public.items ALTER COLUMN colour_variations SET NOT NULL;

-- Combine Step: Set the column outfits_image_url to NOT NULL and set the default value
ALTER TABLE public.outfits ALTER COLUMN outfits_image_url SET DEFAULT 'cc_none';
ALTER TABLE public.outfits ALTER COLUMN outfits_image_url SET NOT NULL;

-- Drop the 'selfie' column from user_low_freq_stats
ALTER TABLE public.user_low_freq_stats DROP COLUMN selfie;

-- Add the 'selfie_taken' column to user_high_freq_stats
ALTER TABLE public.user_high_freq_stats ADD COLUMN selfie_taken INT4 NOT NULL DEFAULT 0;
COMMENT ON COLUMN public.user_high_freq_stats.selfie_taken IS 'The number of selfies taken';

-- Add the 'share_request' column to user_low_freq_stats
ALTER TABLE public.user_low_freq_stats ADD COLUMN share_request INT4 NOT NULL DEFAULT 0;
COMMENT ON COLUMN public.user_low_freq_stats.share_request IS 'The number of people interested in sharing their outfits through social media.';

-- Add the 'outfit_comments' column to outfits
ALTER TABLE public.outfits ADD COLUMN outfit_comments TEXT NOT NULL DEFAULT 'cc_none';
COMMENT ON COLUMN public.outfits.outfit_comments IS 'User comments on the outfit they have worn. If cc_none, means that the user did not insert comments.';
