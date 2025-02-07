CREATE OR REPLACE FUNCTION update_focused_date(outfit_id UUID)
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
    IF outfit_id IS NULL THEN
        RAISE EXCEPTION 'outfit_id cannot be NULL';
    END IF;

    -- Update the focused_date only if the outfit belongs to the current user
    UPDATE public.shared_preferences sp
    SET sp.focused_date = o.created_at,
        sp.updated_at = NOW()
    FROM public.outfits o
    WHERE o.outfit_id = outfit_id
    AND o.user_id = current_user_id
    AND sp.outfit_id = outfit_id
    AND (sp.focused_date IS DISTINCT FROM o.created_at)  -- Prevent unnecessary updates
    RETURNING TRUE INTO result;

    -- Return whether the update was successful
    RETURN COALESCE(result, FALSE);
END;
$$;
