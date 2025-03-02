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
    total_user_outfits INT;
    total_filtered_outfits INT;
BEGIN
    -- Check if the user has any outfits (unfiltered)
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

    -------------------------------------------------------------------------------
    -- 1) Create temporary table for filtered outfits (including event_name)
    -------------------------------------------------------------------------------
    CREATE TEMP TABLE temp_filtered_outfits ON COMMIT DROP AS
    WITH relevant_outfits AS (
        SELECT
            o.outfit_id,
            o.outfit_image_url,
            o.is_active,
            o.event_name,  -- ✅ Fetch event_name
            o.created_at,
            i.closet_id
        FROM public.outfits o
        JOIN public.outfit_items oi ON o.outfit_id = oi.outfit_id
        JOIN public.items i       ON oi.item_id   = i.item_id
        WHERE o.user_id = current_user_id
          AND o.reviewed = TRUE
          AND o.feedback = user_feedback
    )
    SELECT
        ro.outfit_id,
        ro.outfit_image_url,
        ro.is_active,
        ro.event_name,  -- ✅ Include event_name in temp table
        ro.created_at
    FROM relevant_outfits ro
    GROUP BY ro.outfit_id, ro.outfit_image_url, ro.is_active, ro.event_name, ro.created_at
    HAVING (
        user_all_closet
        OR bool_and(ro.closet_id = user_closet_id)
    );

    -- Check if there are any outfits after filtering
    SELECT COUNT(*) INTO total_filtered_outfits
    FROM temp_filtered_outfits;

    IF total_filtered_outfits = 0 THEN
        DROP TABLE IF EXISTS temp_filtered_outfits;
        RETURN JSONB_BUILD_OBJECT(
            'status', 'no_filtered_outfits'
        );
    END IF;

    -------------------------------------------------------------------------------
    -- 2) Paginate and Build Final JSON (Include event_name & item_is_active)
    -------------------------------------------------------------------------------
    SELECT JSONB_BUILD_OBJECT(
        'status', 'success',
        'outfits',
        COALESCE(
            JSONB_AGG(
                JSONB_BUILD_OBJECT(
                    'outfit_id', tfo.outfit_id,
                    'outfit_image_url', tfo.outfit_image_url,
                    'outfit_is_active', tfo.is_active,
                    'event_name', tfo.event_name,  -- ✅ Include event_name
                    'created_at', tfo.created_at,
                    'items', CASE
                        WHEN tfo.outfit_image_url = 'cc_none' THEN (
                            SELECT JSONB_AGG(
                                JSONB_BUILD_OBJECT(
                                    'item_id', subq.item_id,
                                    'image_url', subq.image_url,
                                    'name', subq.name,
                                    'item_is_active', subq.is_active  -- ✅ Include item_is_active
                                )
                            )
                            FROM (
                                SELECT i.item_id, i.image_url, i.name, i.is_active  -- ✅ Fetch is_active
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
        SELECT outfit_id, outfit_image_url, is_active, event_name, created_at
        FROM temp_filtered_outfits
        ORDER BY is_active DESC, created_at DESC
        LIMIT items_per_page
        OFFSET offset_val
    ) tfo;

    -- Drop temporary table
    DROP TABLE IF EXISTS temp_filtered_outfits;

    -- Return final JSON result
    RETURN result;
END;
$$;