CREATE OR REPLACE FUNCTION public.archive_multi_closet(
    p_closet_id uuid
) RETURNS JSON
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id uuid := auth.uid(); -- Authenticated user
    default_closet_id uuid; -- ID of the default closet
BEGIN
    -- Fetch the default closet ID for the user, sorted by created_date
    SELECT closet_id
    INTO default_closet_id
    FROM public.user_closets
    WHERE user_id = current_user_id
      AND closet_name = 'cc_none'
    ORDER BY created_at ASC
    LIMIT 1;

    -- Ensure default_closet_id is found
    IF default_closet_id IS NULL THEN
        RETURN json_build_object(
            'status', 'error',
            'message', 'Default closet not found for the user.'
        );
    END IF;

    -- Archive the specified closet
    UPDATE public.user_closets
    SET
        is_active = FALSE,
        updated_at = NOW()
    WHERE
        user_id = current_user_id
        AND closet_id = p_closet_id;

    -- Reassign items from the archived closet to the default closet
    UPDATE public.items
    SET closet_id = default_closet_id,
        updated_at = NOW()
    WHERE closet_id = p_closet_id;

    -- Return success JSON
    RETURN json_build_object(
        'status', 'success',
        'message', 'Closet archived and items reassigned to default closet successfully.'
    );

EXCEPTION
    WHEN OTHERS THEN
        -- Handle unexpected errors
        RETURN json_build_object(
            'status', 'error',
            'message', 'An unexpected error occurred.',
            'error', SQLERRM
        );

END;
$$;
