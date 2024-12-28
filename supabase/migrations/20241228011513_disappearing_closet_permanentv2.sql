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
        FROM public.user_closets
        WHERE type = 'disappear'
          AND valid_date < CURRENT_DATE
          AND user_id = current_user_id
        ORDER BY valid_date ASC
        LIMIT 1
    ),
    updated_closets AS (
        UPDATE public.user_closets
        SET type = 'permanent'
        WHERE closet_id IN (SELECT closet_id FROM eligible_closet)
        RETURNING closet_id, closet_image, closet_name
    )
    SELECT closet_id, closet_image, closet_name
    FROM updated_closets;
END;
$$;
