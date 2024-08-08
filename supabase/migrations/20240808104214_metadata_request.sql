-- Add a new column to the user_low_freq_stats table
ALTER TABLE public.user_low_freq_stats
ADD COLUMN metadata_request int4 DEFAULT 0 NOT NULL;

-- Add a comment to the new column
COMMENT ON COLUMN public.user_low_freq_stats.metadata_request IS 'Stores additional metadata requests count. Defaults to 0 if no requests are recorded.';

-- Create or replace the function to increment swap requests
CREATE OR REPLACE FUNCTION increment_metadata_request()
RETURNS json
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id uuid := auth.uid();
    result json;
BEGIN
    -- Update the metadata_request count for the current user
    UPDATE public.user_low_freq_stats
    SET
        metadata_request = metadata_request + 1,
        updated_at = now()
    WHERE user_id = current_user_id;

    -- Check if the update was successful
    IF FOUND THEN
        result := json_build_object('status', 'success', 'message', 'Recorded metadata request');
    ELSE
        result := json_build_object('status', 'failure', 'message', 'Cannot record metadata request');
    END IF;

    RETURN result;
EXCEPTION
    WHEN others THEN
        RETURN json_build_object('status', 'error', 'message', format('An error occurred: %s', SQLERRM));
END;
$$;

