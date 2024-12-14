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
                WHEN p_closet_type = 'disappear' AND p_valid_date IS NOT NULL THEN p_valid_date::timestamptz
                ELSE valid_date -- Retain existing value
            END,
            is_public = CASE
                WHEN p_is_public IS NOT NULL THEN p_is_public -- Update to the provided value (TRUE or FALSE)
                ELSE is_public -- Retain the current value if no input is provided (NULL)
            END,
            updated_at = NOW()
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
            updated_at = NOW()
        WHERE item_id = ANY(p_item_ids)
          AND current_owner_id = current_user_id;

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
