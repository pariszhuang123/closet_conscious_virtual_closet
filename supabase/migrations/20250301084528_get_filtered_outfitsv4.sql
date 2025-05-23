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
    total_user_outfits INT;     -- For checking if user has any outfits
    total_filtered_outfits INT; -- For checking outfits after filter
BEGIN
    -- 1) Check if the user has *any* outfits (unfiltered)
    SELECT COUNT(*)
    INTO total_user_outfits
    FROM public.outfits
    WHERE user_id = current_user_id;

    IF total_user_outfits = 0 THEN
        RETURN JSONB_BUILD_OBJECT(
            'status', 'no_user_outfits'
        );
    END IF;

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

    ------------------------------------------------------------------------------
    -- 2) Create temporary table for filtered outfits (ensuring distinct outfit IDs)
    ------------------------------------------------------------------------------
    CREATE TEMP TABLE temp_filtered_outfits ON COMMIT DROP AS
    SELECT DISTINCT
        o.outfit_id,
        o.outfit_image_url,
        o.is_active,
        o.created_at  -- Include created_at for ordering
    FROM public.outfits o
    JOIN public.outfit_items oi ON oi.outfit_id = o.outfit_id
    JOIN public.items i ON oi.item_id = i.item_id
        AND (user_all_closet OR i.closet_id = user_closet_id)
    WHERE o.user_id = current_user_id
      AND o.reviewed = TRUE
      AND o.feedback = user_feedback;

    -- Check if there are any outfits after applying filters
    SELECT COUNT(*) INTO total_filtered_outfits
    FROM temp_filtered_outfits;

    IF total_filtered_outfits = 0 THEN
        -- No outfits match the user’s current filter preferences
        DROP TABLE IF EXISTS temp_filtered_outfits;
        RETURN JSONB_BUILD_OBJECT(
            'status', 'no_filtered_outfits'
        );
    END IF;

    ------------------------------------------------------------------------------
    -- 3) Paginate and build the final JSON
    ------------------------------------------------------------------------------
    /*
       1) We SELECT from temp_filtered_outfits using LIMIT/OFFSET.
       2) For each returned row (1 row per distinct outfit), we embed
          a subquery to fetch the items if outfit_image_url = 'cc_none'.
       3) We ORDER BY created_at DESC to show the newest outfits first.
    */

    SELECT JSONB_BUILD_OBJECT(
        'status', 'success',
        'outfits',
        COALESCE(
            JSONB_AGG(
                JSONB_BUILD_OBJECT(
                    'outfit_id', tfo.outfit_id,
                    'outfit_image_url', tfo.outfit_image_url,
                    'outfit_is_active', tfo.is_active,
                    'created_at', tfo.created_at,  -- Include created_at in the response
                    'items', CASE
                        WHEN tfo.outfit_image_url = 'cc_none' THEN (
                            SELECT JSONB_AGG(
                                JSONB_BUILD_OBJECT(
                                    'item_id', subq.item_id,
                                    'image_url', subq.image_url,
                                    'name', subq.name
                                )
                            )
                            FROM (
                                SELECT i.item_id, i.image_url, i.name
                                FROM public.outfit_items oi
                                JOIN public.items i ON oi.item_id = i.item_id
                                WHERE oi.outfit_id = tfo.outfit_id
                                ORDER BY i.is_active DESC, i.updated_at DESC
                            ) AS subq
                        )
                        ELSE '[]'::JSONB
                    END
                )
            ),
            '[]'::JSONB
        )
    )
    INTO result
    FROM (
        SELECT outfit_id, outfit_image_url, is_active, created_at
        FROM temp_filtered_outfits
        ORDER BY is_active DESC,  created_at DESC  -- Sorting by newest outfits first
        LIMIT items_per_page
        OFFSET offset_val
    ) tfo;

    -- Drop temporary table
    DROP TABLE IF EXISTS temp_filtered_outfits;

    -- Return final JSON result
    RETURN result;
END;
$$;
