CREATE OR REPLACE FUNCTION update_focused_date(f_outfit_id UUID)
RETURNS BOOLEAN
SECURITY INVOKER
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id UUID := auth.uid();
    result BOOLEAN;
BEGIN
    -- Validate input
    IF f_outfit_id IS NULL THEN
        RAISE EXCEPTION 'f_outfit_id cannot be NULL';
    END IF;

    -- Update the focused_date only if the outfit belongs to the current user
    UPDATE public.shared_preferences sp
    SET focused_date = o.created_at,
        updated_at = NOW()
    FROM public.outfits o
    WHERE o.outfit_id = f_outfit_id -- Explicitly reference the function parameter
    AND o.user_id = current_user_id
    AND sp.user_id = current_user_id -- Explicitly reference the table column
    AND (sp.focused_date IS DISTINCT FROM o.created_at)  -- Prevent unnecessary updates
    RETURNING TRUE INTO result;

    -- Return whether the update was successful
    RETURN COALESCE(result, FALSE);
END;
$$;
