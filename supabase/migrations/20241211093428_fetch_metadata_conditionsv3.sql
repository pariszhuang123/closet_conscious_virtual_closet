DROP FUNCTION IF EXISTS public.fetch_closet_metadata(uuid);
DROP FUNCTION IF EXISTS public.check_closet_conditions();

CREATE OR REPLACE FUNCTION public.fetch_closet_metadata_conditions()
RETURNS JSONB
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    closet_metadata JSONB;
    current_user_id UUID := auth.uid();
    p_closet_id UUID;
    is_hidden BOOLEAN;
BEGIN
    -- Check if the user is authenticated
    IF current_user_id IS NULL THEN
        RETURN jsonb_build_object('error', 'User not authenticated.');
    END IF;

    -- Get the closet_id from user preferences
    SELECT closet_id
    INTO p_closet_id
    FROM public.shared_preferences
    WHERE user_id = current_user_id;

    -- Validate that a closet_id exists
    IF p_closet_id IS NULL THEN
        RETURN jsonb_build_object('error', 'No closet_id found in user preferences.');
    END IF;

    -- Determine whether the closet should be hidden
    is_hidden := EXISTS (
        SELECT 1
        FROM public.user_closets uc
        JOIN public.shared_preferences sp
        ON uc.closet_id = sp.closet_id
        WHERE uc.closet_name = 'cc_closet'
          AND uc.user_id = current_user_id
          AND sp.user_id = current_user_id
    ) OR EXISTS (
        SELECT 1
        FROM public.shared_preferences
        WHERE user_id = current_user_id
          AND all_closet = true
    );

    -- Return hidden status if applicable
    IF is_hidden THEN
        RETURN jsonb_build_object('should_hide', is_hidden, 'metadata', NULL);
    END IF;

    -- Fetch closet metadata if not hidden
    SELECT jsonb_build_object(
        'type', uc.type,
        'closet_name', uc.closet_name,
        'closet_image', uc.closet_image,
        'is_public', uc.is_public,
        'valid_date', uc.valid_date
    )
    INTO closet_metadata
    FROM public.user_closets uc
    WHERE uc.user_id = current_user_id
      AND uc.closet_id = p_closet_id
    LIMIT 1;

    -- Handle no metadata found
    IF closet_metadata IS NULL THEN
        RETURN jsonb_build_object('error', 'No metadata found for the specified closet.');
    END IF;

    RETURN jsonb_build_object('should_hide', is_hidden, 'metadata', closet_metadata);
END;
$$;
