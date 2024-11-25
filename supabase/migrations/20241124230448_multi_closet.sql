CREATE OR REPLACE FUNCTION public.add_multi_closet(
    _closet_name TEXT,
    _closet_type TEXT,
     _item_ids UUID[],
    _months_later INT DEFAULT 0,
    _is_public BOOLEAN DEFAULT FALSE -- Default value for permanent closets
) RETURNS JSON
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    _generated_closet_id UUID :=  gen_random_uuid();
    current_user_id uuid := auth.uid(); -- Authenticated user
BEGIN
    -- Insert into user_closets table
    INSERT INTO public.user_closets (
        closet_id, closet_name, type, valid_date, is_public, user_id
    )
    VALUES (
        _generated_closet_id,
        _closet_name,
        _closet_type,
        CASE
            WHEN _closet_type = 'disappearing' THEN NOW() + (_months_later || ' months')::INTERVAL
            ELSE NOW()
        END,
        CASE
            WHEN _closet_type = 'permanent' THEN _is_public
            ELSE FALSE
        END,
        current_user_id
    );

    -- Update items table with the new closet_id for the selected items
    UPDATE public.items
    SET
        closet_id = _generated_closet_id,
        updated_at = NOW()

    WHERE item_id = ANY(_item_ids) AND current_owner_id = current_user_id;

    -- Return success JSON
    RETURN json_build_object(
        'status', 'success',
        'message', 'Closet saved successfully.',
        'closet_id', _generated_closet_id
    );

EXCEPTION
    WHEN OTHERS THEN
        RETURN JSON_BUILD_OBJECT('status', 'error', 'message', SQLERRM, 'closet_id', NULL);
END;
$$ ;


CREATE OR REPLACE FUNCTION public.edit_multi_closet(
    p_closet_id uuid DEFAULT NULL, -- Optional closet ID
    p_closet_name text DEFAULT NULL,
    p_closet_type text DEFAULT NULL,
    p_valid_date text DEFAULT NULL,
    p_is_public boolean DEFAULT NULL,
    p_item_ids uuid[] DEFAULT NULL, -- Optional array
    p_new_closet_id uuid DEFAULT NULL
)
RETURNS json
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id uuid := auth.uid(); -- Authenticated user
BEGIN
    -- First Guard Clause: Skip if closet_id is NULL
    IF p_closet_id IS NULL THEN
        RAISE NOTICE 'Skipping closet update: closet_id is NULL.';
    ELSE
        -- Update closet metadata only for provided fields
        UPDATE public.user_closets
        SET
            closet_name = COALESCE(p_closet_name, closet_name), -- Update only if provided
            type = COALESCE(p_closet_type, type),               -- Update only if provided
            valid_date = CASE
                WHEN p_closet_type = 'disappearing' AND p_valid_date IS NOT NULL THEN p_valid_date::timestamptz
                ELSE valid_date -- Retain existing value
            END,
            is_public = CASE
                WHEN p_is_public IS NOT NULL THEN p_is_public -- Update to the provided value (TRUE or FALSE)
                ELSE is_public -- Retain the current value if no input is provided (NULL)
            END,
            updated_date = NOW()
        WHERE closet_id = p_closet_id
          AND user_id = current_user_id;

        RAISE NOTICE 'Closet updated successfully for closet_id %.', p_closet_id;
    END IF;

    -- Second Guard Clause: Skip if p_item_ids or p_new_closet_id is NULL
    IF p_item_ids IS NULL OR p_new_closet_id IS NULL THEN
        RAISE NOTICE 'Skipping item transfer: Missing item IDs or new closet ID.';
    ELSE
        -- Transfer items to a new closet
        UPDATE public.items
        SET
            closet_id = p_new_closet_id,
            updated_date = NOW()
        WHERE item_id = ANY(p_item_ids)
          AND user_id = current_user_id;

        RAISE NOTICE 'Items transferred successfully to new closet_id %.', p_new_closet_id;
    END IF;

    -- Return success JSON
    RETURN json_build_object(
        'status', 'success',
        'message', 'Closet and items updated successfully.',
        'closet_id', p_closet_id
    );
END;
$$;


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
    ORDER BY created_date ASC
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
