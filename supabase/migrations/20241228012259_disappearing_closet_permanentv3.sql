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
        SELECT uc.closet_id
        FROM public.user_closets uc
        WHERE uc.type = 'disappear'
          AND uc.valid_date < CURRENT_DATE
          AND uc.user_id = current_user_id
        ORDER BY uc.valid_date ASC
        LIMIT 1
    ),
    updated_closets AS (
        UPDATE public.user_closets
        SET type = 'permanent'
        WHERE user_closets.closet_id IN (SELECT eligible_closet.closet_id FROM eligible_closet)
        RETURNING user_closets.closet_id, user_closets.closet_image, user_closets.closet_name
    )
    SELECT updated_closets.closet_id, updated_closets.closet_image, updated_closets.closet_name
    FROM updated_closets;
END;
$$;
