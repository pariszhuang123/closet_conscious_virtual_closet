CREATE OR REPLACE FUNCTION get_related_outfits(_outfit_id UUID, p_current_page INT)
RETURNS JSONB
LANGUAGE plpgsql
SET search_path = ''
AS $$
DECLARE
    current_user_id UUID := auth.uid();
    total_related_count INT;
    outfits_per_page INT := 15;  -- Define how many outfits per page
    offset_val INT := (p_current_page) * outfits_per_page;  -- Calculate offset
BEGIN
    -- Update user shared preferences
    UPDATE public.shared_preferences
    SET feedback = 'all',
        is_outfit_active = 'active',
        ignore_item_name = TRUE,
        ignore_event_name = TRUE,
        all_closet = TRUE,
        filter = '{}',
        sort = 'updated_at',
        sort_order = 'DESC',
        updated_at = NOW()
    WHERE user_id = current_user_id;

    -- Count the number of related outfits
    SELECT COUNT(DISTINCT o.outfit_id) INTO total_related_count
    FROM public.outfits o
    JOIN public.outfit_items oi ON o.outfit_id = oi.outfit_id
    JOIN public.outfit_items moi ON moi.outfit_id = _outfit_id AND moi.item_id = oi.item_id
    WHERE o.is_active = TRUE
      AND o.outfit_id != _outfit_id
      AND o.user_id = current_user_id;

    -- ✅ EARLY EXIT: If no related outfits exist, return immediately
    IF total_related_count = 0 THEN
        RETURN JSONB_BUILD_OBJECT(
            'status', 'no_similar_items'
        );
    END IF;

    -- ✅ Use inline CASE query for fallback items instead of LATERAL JOIN
    RETURN (
        WITH main_outfit_items AS (
            SELECT oi.item_id
            FROM public.outfit_items oi
            WHERE oi.outfit_id = _outfit_id
        ),
        ranked_outfits AS (
            SELECT
                o.outfit_id,
                COUNT(oi.item_id) AS matching_items
            FROM public.outfits o
            JOIN public.outfit_items oi ON o.outfit_id = oi.outfit_id
            JOIN main_outfit_items moi ON oi.item_id = moi.item_id
            WHERE o.is_active = TRUE
              AND o.outfit_id != _outfit_id
              AND o.user_id = current_user_id
            GROUP BY o.outfit_id
            ORDER BY matching_items DESC, o.created_at DESC
        ),
        final_outfits AS (
            SELECT
                o.outfit_id,
                o.outfit_image_url,
                o.is_active,
                o.event_name,
                o.created_at
            FROM public.outfits o
            JOIN ranked_outfits ro ON o.outfit_id = ro.outfit_id
        )
        SELECT JSONB_BUILD_OBJECT(
            'status', 'success',
            'outfits', JSONB_AGG(
                JSONB_BUILD_OBJECT(
                    'outfit_id', fo.outfit_id,
                    'outfit_image_url', fo.outfit_image_url,
                    'outfit_is_active', fo.is_active,
                    'items', CASE
                        WHEN fo.outfit_image_url = 'cc_none' THEN (
                            SELECT COALESCE(
                                JSONB_AGG(
                                    JSONB_BUILD_OBJECT(
                                        'item_id', i.item_id,
                                        'image_url', i.image_url,
                                        'name', i.name,
                                        'item_is_active', i.is_active,
                                        'is_disliked', oi.disliked
                                    )
                                ), '[]'::JSONB
                            )
                            FROM public.outfit_items oi
                            JOIN public.items i ON oi.item_id = i.item_id
                            WHERE oi.outfit_id = fo.outfit_id
                        )
                        ELSE '[]'::JSONB
                    END
                )
            )
        )
        FROM final_outfits fo
        LIMIT outfits_per_page OFFSET offset_val
    );
END;
$$;


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
    outfits_per_page INT := 15;  -- Define how many items per page
    offset_val INT := (p_current_page) * outfits_per_page;  -- Calculate offset based on page number
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

    -- Count how many total outfits remain after filtering
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
                            SELECT COALESCE(
                                JSONB_AGG(
                                    JSONB_BUILD_OBJECT(
                                        'item_id', i.item_id,
                                        'image_url', i.image_url,
                                        'name', i.name,
                                        'item_is_active', i.is_active,
                                        'is_disliked', oi.disliked
                                    )
                                    ORDER BY i.updated_at DESC
                                ), '[]'::JSONB
                            )
                            FROM public.outfit_items oi
                            JOIN public.items i ON oi.item_id = i.item_id
                            WHERE oi.outfit_id = tfo.outfit_id
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
        LIMIT outfits_per_page
        OFFSET offset_val
    ) tfo;

    -- Drop temporary table
    DROP TABLE IF EXISTS temp_filtered_outfits;

    -- Return final JSON result
    RETURN result;
END;
$$;


CREATE OR REPLACE FUNCTION get_item_related_outfits(f_item_id UUID, p_current_page INT)
RETURNS JSONB
LANGUAGE plpgsql
SET search_path = ''
AS $$
DECLARE
    current_user_id UUID := auth.uid();
    result JSONB;
    outfits_per_page INT := 15;  -- Define how many items per page
    offset_val INT := (p_current_page) * outfits_per_page;  -- Calculate offset based on page number
BEGIN

    -- Update user shared preferences
    UPDATE public.shared_preferences
    SET feedback = 'all',
        is_outfit_active = 'active',
        ignore_item_name = TRUE,
        ignore_event_name = TRUE,
        all_closet = TRUE,
        filter = '{}',
        sort = 'updated_at',
        sort_order = 'DESC',
        updated_at = NOW()
    WHERE user_id = current_user_id;

    -- Check if there is at least one related outfit (fast exit if none exist)
    IF NOT EXISTS (
        SELECT 1 FROM public.outfit_items oi
        JOIN public.outfits o ON oi.outfit_id = o.outfit_id
        WHERE oi.item_id = f_item_id
        AND o.reviewed = TRUE
        AND o.user_id = current_user_id
    ) THEN
        RETURN JSONB_BUILD_OBJECT('status', 'no_outfits');
    END IF;

    -- Build and return the response with outfits
    SELECT JSONB_BUILD_OBJECT(
        'status', 'success',
        'outfits', COALESCE(
            JSONB_AGG(
                JSONB_BUILD_OBJECT(
                    'outfit_id', o.outfit_id,
                    'outfit_image_url', o.outfit_image_url,
                    'event_name', o.event_name,
                    'outfit_is_active', o.is_active,
                    'items', CASE
                        WHEN o.outfit_image_url = 'cc_none' THEN (
                            SELECT COALESCE(
                                JSONB_AGG(
                                    JSONB_BUILD_OBJECT(
                                        'item_id', i.item_id,
                                        'image_url', i.image_url,
                                        'name', i.name,
                                        'item_is_active', i.is_active,
                                        'is_disliked', oi.disliked
                                    )
                                    ORDER BY i.updated_at DESC
                                ), '[]'::JSONB
                            )
                            FROM public.outfit_items oi
                            JOIN public.items i ON oi.item_id = i.item_id
                            WHERE oi.outfit_id = o.outfit_id
                        )
                        ELSE '[]'::JSONB
                    END
                )
            ), '[]'::JSONB
        )
    ) INTO result
    FROM (
        -- Select all reviewed outfits that contain the item
        SELECT o.outfit_id, o.outfit_image_url, o.is_active, o.event_name, o.created_at
        FROM public.outfits o
        JOIN public.outfit_items oi ON o.outfit_id = oi.outfit_id
        WHERE oi.item_id = f_item_id
        AND o.reviewed = TRUE
        AND o.user_id = current_user_id
        ORDER BY o.is_active DESC, o.created_at DESC
        LIMIT outfits_per_page OFFSET offset_val
    ) o;

    RETURN result;
END;
$$;
