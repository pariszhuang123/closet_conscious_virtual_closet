-- Increment filter requests
CREATE OR REPLACE FUNCTION increment_filter_request()
RETURNS json
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id uuid := auth.uid();
    result json;
BEGIN
    -- Update the filter request count for the current user
    UPDATE user_low_freq_stats
    SET filter_request = filter_request + 1
    WHERE user_id = current_user_id;

    -- Check if the update was successful
    IF FOUND THEN
        result := json_build_object('status', 'success', 'message', 'Recorded filtering request');
    ELSE
        result := json_build_object('status', 'failure', 'message', 'Cannot record filtering request');
    END IF;

    RETURN result;
EXCEPTION
    WHEN others THEN
        RETURN json_build_object('status', 'error', 'message', format('An error occurred: %s', SQLERRM));
END;
$$;


-- Increment multi-closet requests
CREATE OR REPLACE FUNCTION increment_multi_closet_request()
RETURNS json
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id uuid := auth.uid();
    result json;
BEGIN
    UPDATE user_low_freq_stats
    SET multi_closet_request = multi_closet_request + 1
    WHERE user_id = current_user_id;

    -- Check if the update was successful
    IF FOUND THEN
        result := json_build_object('status', 'success', 'message', 'Recorded multi-closet request');
    ELSE
        result := json_build_object('status', 'failure', 'message', 'Cannot record multi-closet request');
    END IF;

    RETURN result;
EXCEPTION
    WHEN others THEN
        RETURN json_build_object('status', 'error', 'message', format('An error occurred: %s', SQLERRM));
END;
$$;


-- Increment analytics requests
CREATE OR REPLACE FUNCTION increment_analytics_request()
RETURNS json
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id uuid := auth.uid();
    result json;
BEGIN
    UPDATE user_low_freq_stats
    SET analytics_request = analytics_request + 1
    WHERE user_id = current_user_id;

    -- Check if the update was successful
    IF FOUND THEN
        result := json_build_object('status', 'success', 'message', 'Recorded analytics request');
    ELSE
        result := json_build_object('status', 'failure', 'message', 'Cannot record analytics request');
    END IF;

    RETURN result;
EXCEPTION
    WHEN others THEN
        RETURN json_build_object('status', 'error', 'message', format('An error occurred: %s', SQLERRM));
END;
$$;
