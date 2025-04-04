CREATE OR REPLACE FUNCTION get_filtered_outfits(
    p_current_page INT
)
RETURNS JSONB
LANGUAGE plpgsql
SET search_path = ''
AS $$
DECLARE
    current_user_id UUID := auth.uid();
    result JSONB;
    items_per_page INT;
    offset_val INT;
    user_all_closet BOOLEAN;
    user_closet_id UUID;
    user_feedback TEXT;
BEGIN
    -- Retrieve items per page from user preferences
    SELECT FLOOR(grid * 1.5 * grid)::INT
    INTO items_per_page
    FROM public.shared_preferences sp
    WHERE sp.user_id = current_user_id;

    offset_val := p_current_page * items_per_page;

    -- Get user's filtering preferences
    SELECT all_closet, closet_id,
           CASE WHEN feedback = 'all' THEN 'like' ELSE feedback END AS user_feedback
    INTO user_all_closet, user_closet_id, user_feedback
    FROM public.shared_preferences
    WHERE user_id = current_user_id;

    -- Create temporary table for filtering outfits
    CREATE TEMP TABLE temp_filtered_outfits ON COMMIT DROP AS
    SELECT
        o.outfit_id,
        o.outfit_image_url,
        o.is_active
    FROM public.outfits o
    JOIN public.outfit_items oi ON oi.outfit_id = o.outfit_id
    JOIN public.items i ON oi.item_id = i.item_id
        AND (user_all_closet OR i.closet_id = user_closet_id)
    WHERE o.user_id = current_user_id
      AND o.reviewed = TRUE
      AND o.feedback = user_feedback;

    -- Fetch outfits along with items (if outfit image is missing)
    SELECT JSONB_BUILD_OBJECT(
        'status', 'success',
        'outfits', COALESCE(
            JSONB_AGG(
                JSONB_BUILD_OBJECT(
                    'outfit_id', tfo.outfit_id,
                    'outfit_image_url', tfo.outfit_image_url,
                    'outfit_is_active', tfo.is_active,
                    'items', CASE
                        WHEN tfo.outfit_image_url = 'cc_none' THEN (
                            SELECT JSONB_AGG(
                                JSONB_BUILD_OBJECT(
                                    'item_id', subquery.item_id,
                                    'image_url', subquery.image_url,
                                    'name', subquery.name
                                )
                            )
                            FROM (
                                SELECT i.item_id, i.image_url, i.name
                                FROM public.outfit_items oi
                                JOIN public.items i ON oi.item_id = i.item_id
                                WHERE oi.outfit_id = tfo.outfit_id
                                ORDER BY i.is_active DESC, i.updated_at DESC
                                LIMIT 1
                            ) AS subquery
                        )
                        ELSE '[]'::JSONB
                    END
                )
            ), '[]'::JSONB
        )
    ) INTO result
    FROM temp_filtered_outfits tfo
    ORDER BY tfo.is_active DESC, tfo.outfit_id
    LIMIT items_per_page OFFSET offset_val;

    -- Drop temporary table
    DROP TABLE IF EXISTS temp_filtered_outfits;

    -- Return final JSON result
    RETURN result;
END;
$$;

