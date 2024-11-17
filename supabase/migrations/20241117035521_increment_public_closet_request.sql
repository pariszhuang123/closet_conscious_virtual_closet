ALTER TABLE public.items
ALTER COLUMN price_per_wear TYPE NUMERIC(20, 6);

COMMENT ON COLUMN public.items.price_per_wear
IS 'Stores the calculated price per wear for an item, with up to 30 total digits and 6 decimal places to support global currencies like IDR and scenarios involving micro-costs or high wear counts.';

ALTER TABLE public.user_closets
ADD COLUMN is_active BOOLEAN DEFAULT TRUE NOT NULL;

COMMENT ON COLUMN public.user_closets.is_active
IS 'Indicates whether a user closet is active (TRUE) or inactive (FALSE). Replaces the status column for improved performance and storage efficiency.';

ALTER TABLE public.items
ADD COLUMN is_active BOOLEAN DEFAULT TRUE NOT NULL;

COMMENT ON COLUMN public.items.is_active
IS 'Indicates whether an item is active (TRUE) or inactive (FALSE). Replaces the status column for better performance and storage efficiency.';

-- Altering user_low_freq_stats table
ALTER TABLE public.user_low_freq_stats
ADD COLUMN public_closet_request int4 DEFAULT 0 NOT NULL;

-- Adding comments to user_low_freq_stats table columns
COMMENT ON COLUMN public.user_low_freq_stats.public_closet_request
IS 'Tracks the number of user requests or interactions with the Global Closet feature, such as interest in joining, liking items, or hosting events.';

-- Increment multi-closet requests
CREATE OR REPLACE FUNCTION increment_public_closet_request()
RETURNS json
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id uuid := auth.uid();
    result json;
BEGIN
    UPDATE public.user_low_freq_stats
    SET
        public_closet_request = public_closet_request + 1,
        updated_at = NOW()
    WHERE user_id = current_user_id;

    -- Check if the update was successful
    IF FOUND THEN
        result := json_build_object('status', 'success', 'message', 'Recorded public-closet request');
    ELSE
        result := json_build_object('status', 'failure', 'message', 'Cannot record public-closet request');
    END IF;

    RETURN result;
EXCEPTION
    WHEN others THEN
        RETURN json_build_object('status', 'error', 'message', format('An error occurred: %s', SQLERRM));
END;
$$;
