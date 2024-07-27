-- Increment calendar requests
CREATE OR REPLACE FUNCTION increment_calendar_request()
RETURNS json
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id uuid := auth.uid();
    result json;
BEGIN
    -- Update the calendar request count for the current user
    UPDATE public.user_low_freq_stats
    SET calendar_request = calendar_request + 1
    WHERE user_id = current_user_id;

    -- Check if the update was successful
    IF FOUND THEN
        result := json_build_object('status', 'success', 'message', 'Recorded calendar request');
    ELSE
        result := json_build_object('status', 'failure', 'message', 'Cannot record calendar request');
    END IF;

    RETURN result;
EXCEPTION
    WHEN others THEN
        RETURN json_build_object('status', 'error', 'message', format('An error occurred: %s', SQLERRM));
END;
$$;
