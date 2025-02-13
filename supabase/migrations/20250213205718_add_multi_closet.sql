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
            WHEN _closet_type = 'disappear' THEN NOW() + (_months_later || ' months')::INTERVAL
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

    WHERE item_id = ANY(_item_ids)
        AND current_owner_id = current_user_id;

    UPDATE public.shared_preferences
    SET
        closet_id = _generated_closet_id,
        updated_at = NOW()
    WHERE user_id = current_user_id;

    -- Return success JSON
    RETURN json_build_object(
        'status', 'success',
        'message', 'Closet saved successfully.',
        'closet_id', _generated_closet_id
    );

EXCEPTION
    WHEN OTHERS THEN
        -- Log the error details without exposing internal messages to the caller
        RAISE LOG 'Error in add_multi_closet: %', SQLERRM;
        RETURN json_build_object(
            'status', 'error',
            'message', 'An error occurred while saving the closet. Please try again later.',
            'closet_id', NULL
        );
END;
$$;
