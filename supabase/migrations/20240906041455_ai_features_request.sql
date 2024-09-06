-- Add a new column to the user_low_freq_stats table
ALTER TABLE public.user_low_freq_stats
ADD COLUMN
    ai_upload_usage_request int4 DEFAULT 0 NOT NULL
    ai_stylist_usage_request int4 DEFAULT 0 NOT NULL;


-- Add a comment to the new column
COMMENT ON COLUMN public.user_low_freq_stats.ai_upload_usage_request  IS 'Tracks the number of times a user has requested AI assistance for uploading items to their virtual closet. Default value is 0.';
COMMENT ON COLUMN public.user_low_freq_stats.ai_stylist_usage_request  IS 'Records the number of times a user has utilized AI stylist services for outfit suggestions or recommendations. Default value is 0.';

-- Create or replace the function to increment ai_upload_usage requests
CREATE OR REPLACE FUNCTION public.increment_ai_upload_usage_request()
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
        ai_upload_usage_request = ai_upload_usage_request + 1,
        updated_at = now()
    WHERE user_id = current_user_id;

    -- Check if the update was successful
    IF FOUND THEN
        result := json_build_object('status', 'success', 'message', 'Recorded ai upload usage request');
    ELSE
        result := json_build_object('status', 'failure', 'message', 'Cannot record ai upload usage request');
    END IF;

    RETURN result;
EXCEPTION
    WHEN others THEN
        RETURN json_build_object('status', 'error', 'message', format('An error occurred: %s', SQLERRM));
END;
$$;

-- Create or replace the function to increment ai_stylist_usage requests
CREATE OR REPLACE FUNCTION public.increment_ai_stylist_usage_request()
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
        ai_stylist_usage_request = ai_stylist_usage_request + 1,
        updated_at = now()
    WHERE user_id = current_user_id;

    -- Check if the update was successful
    IF FOUND THEN
        result := json_build_object('status', 'success', 'message', 'Recorded ai stylist usage request');
    ELSE
        result := json_build_object('status', 'failure', 'message', 'Cannot record ai stylist usage request');
    END IF;

    RETURN result;
EXCEPTION
    WHEN others THEN
        RETURN json_build_object('status', 'error', 'message', format('An error occurred: %s', SQLERRM));
END;
$$;

