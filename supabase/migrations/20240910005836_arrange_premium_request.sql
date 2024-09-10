-- Add a new column to the user_low_freq_stats table
ALTER TABLE public.user_low_freq_stats
ADD COLUMN arrange_request int4 DEFAULT 0 NOT NULL;

-- Add a comment to the new column
COMMENT ON COLUMN public.user_low_freq_stats.arrange_request IS 'Stores arrange requests count. Defaults to 0 if no requests are recorded.';

-- Create or replace the function to increment arrange requests
CREATE OR REPLACE FUNCTION increment_arrange_request()
RETURNS json
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id uuid := auth.uid();
    result json;
BEGIN
    -- Update the swap_request count for the current user
    UPDATE public.user_low_freq_stats
    SET
        arrange_request = arrange_request + 1,
        updated_at = now()
    WHERE user_id = current_user_id;

    -- Check if the update was successful
    IF FOUND THEN
        result := json_build_object('status', 'success', 'message', 'Recorded arrange request');
    ELSE
        result := json_build_object('status', 'failure', 'message', 'Cannot record arrange request');
    END IF;

    RETURN result;
EXCEPTION
    WHEN others THEN
        RETURN json_build_object('status', 'error', 'message', format('An error occurred: %s', SQLERRM));
END;
$$;

