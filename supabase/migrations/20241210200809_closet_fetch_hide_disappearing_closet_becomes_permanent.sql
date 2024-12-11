CREATE OR REPLACE FUNCTION public.fetch_closet_metadata(p_closet_id uuid)
RETURNS JSONB
SET search_path = ''
LANGUAGE plpgsql
AS $$

DECLARE
    closet_metadata JSONB;
    current_user_id UUID := auth.uid();
BEGIN
    -- Check if the user is authenticated
    IF current_user_id IS NULL THEN
        RAISE EXCEPTION 'User not authenticated.';
    END IF;

    -- Validate closet ID
    IF p_closet_id IS NULL THEN
        RAISE EXCEPTION 'Closet ID cannot be NULL.';
    END IF;

    -- Fetch closet metadata
    SELECT jsonb_build_object(
        'type', type,
        'closet_name', closet_name,
        'closet_image', closet_image,
        'is_public', is_public,
        'valid_date', valid_date
    )
    INTO closet_metadata
    FROM public.user_closets
    WHERE user_id = current_user_id
        AND closet_id = p_closet_id;

    -- Handle no metadata found
    IF closet_metadata IS NULL THEN
        RAISE EXCEPTION 'No metadata found for user: %', current_user_id;
    END IF;

    RETURN closet_metadata;
END;
$$;

CREATE OR REPLACE FUNCTION public.check_closet_conditions()
RETURNS BOOLEAN
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id UUID := auth.uid();
BEGIN
    -- Validate if user_id is not null
    IF current_user_id IS NULL THEN
        RAISE EXCEPTION 'Unauthorized access. User ID is null.';
    END IF;

    RETURN EXISTS (
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
END;
$$;

CREATE OR REPLACE FUNCTION public.update_disappeared_closets()
RETURNS TABLE (
    closet_id UUID,
    closet_image TEXT,
    closet_name TEXT
)
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id UUID := auth.uid();
BEGIN
    RETURN QUERY
    WITH eligible_closet AS (
        SELECT closet_id
        FROM public.user_closet
        WHERE type = 'disappear'
          AND valid_date < CURRENT_DATE
          AND user_id = current_user_id
        ORDER BY valid_date ASC
        LIMIT 1
    ),
    updated_closets AS (
        UPDATE public.user_closet
        SET type = 'permanent'
        WHERE closet_id IN (SELECT closet_id FROM eligible_closet)
        RETURNING closet_id, closet_image, closet_name
    )
    SELECT closet_id, closet_image, closet_name
    FROM updated_closets;
END;
$$;
