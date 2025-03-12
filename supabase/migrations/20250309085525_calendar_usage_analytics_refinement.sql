CREATE OR REPLACE FUNCTION fetch_daily_outfits(f_outfit_id UUID DEFAULT NULL)
RETURNS JSONB
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id UUID := auth.uid();
    f_focused_date DATE;
    has_previous_outfits BOOLEAN;
    has_next_outfits BOOLEAN;
    f_ignore_event_name BOOLEAN;
    f_event_name_filter TEXT;
    f_feedback_filter TEXT;
    f_is_outfit_active_filter TEXT;
    result JSONB;
BEGIN
    ----------------------------------------------------------------------------
    -- Step 1: Fetch the focused date and user preferences from shared_preferences
    ----------------------------------------------------------------------------
    SELECT
        sp.focused_date,
        sp.ignore_event_name,
        sp.event_name,
        sp.feedback,
        sp.is_outfit_active
    INTO f_focused_date, f_ignore_event_name, f_event_name_filter, f_feedback_filter, f_is_outfit_active_filter
    FROM public.shared_preferences sp
    WHERE sp.user_id = current_user_id
    LIMIT 1;

    ----------------------------------------------------------------------------
    -- Step 2: Create a temporary filtered outfits table
    ----------------------------------------------------------------------------
    DROP TABLE IF EXISTS temp_filtered_outfits;

    CREATE TEMP TABLE temp_filtered_outfits AS
    SELECT
        o.*,
        o.created_at::DATE AS created_day,
        o.created_at::DATE = f_focused_date AS has_outfit_on_date
    FROM public.outfits o
    WHERE o.reviewed = true
      AND o.user_id = current_user_id
      AND (
          f_ignore_event_name
          OR (o.event_name ILIKE '%' || COALESCE(f_event_name_filter, '') || '%')
      )
      AND (
          f_feedback_filter = 'all'
          OR o.feedback = f_feedback_filter
      )
      AND (
          f_is_outfit_active_filter = 'all'
          OR (f_is_outfit_active_filter = 'active' AND o.is_active = true)
          OR (f_is_outfit_active_filter = 'inactive' AND o.is_active = false)
      );

    ----------------------------------------------------------------------------
    -- Step 3: Determine has_previous_outfits and has_next_outfits
    ----------------------------------------------------------------------------
    SELECT
        EXISTS (SELECT 1 FROM temp_filtered_outfits WHERE created_day < f_focused_date LIMIT 1),
        EXISTS (SELECT 1 FROM temp_filtered_outfits WHERE created_day > f_focused_date LIMIT 1)
    INTO has_previous_outfits, has_next_outfits;

    ----------------------------------------------------------------------------
    -- Step 4: Fetch daily outfits using JSON aggregation
    ----------------------------------------------------------------------------
    SELECT JSONB_AGG(
        JSONB_BUILD_OBJECT(
            'outfit_id', opd.outfit_id,
            'feedback', opd.feedback,
            'reviewed', opd.reviewed,
            'is_active', opd.is_active,
            'outfit_image_url', opd.outfit_image_url,
            'event_name', opd.event_name,
            'outfit_comments', opd.outfit_comments,
            'items', COALESCE(di.items, '[]'::JSONB)  -- Precomputed item aggregation
        )
    )
    INTO result
    FROM (
        SELECT
            o.outfit_id,
            o.feedback,
            o.reviewed,
            o.is_active,
            o.outfit_image_url,
            o.event_name,
            o.outfit_comments
        FROM temp_filtered_outfits o
        WHERE created_day = f_focused_date
        ORDER BY o.updated_at
    ) opd
    LEFT JOIN (
        SELECT
            oi.outfit_id,
            JSONB_AGG(
                JSONB_BUILD_OBJECT(
                    'item_id', i.item_id,
                    'image_url', i.image_url,
                    'name', i.name,
                    'item_is_active', i.is_active,
                    'is_disliked', oi.disliked
                )
            ) AS items  -- ✅ Aggregating items separately
        FROM public.outfit_items oi
        JOIN public.items i ON oi.item_id = i.item_id
        WHERE i.current_owner_id = current_user_id
        GROUP BY oi.outfit_id  -- ✅ Ensure this groups properly
    ) di
    ON opd.outfit_id = di.outfit_id;


    ----------------------------------------------------------------------------
    -- Step 5: Drop temporary table and return JSON response
    ----------------------------------------------------------------------------
    DROP TABLE IF EXISTS temp_filtered_outfits;

    RETURN JSONB_BUILD_OBJECT(
        'status', 'success',
        'focused_date', f_focused_date,
        'has_previous_outfits', has_previous_outfits,
        'has_next_outfits', has_next_outfits,
        'outfits', result
    );
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
        AND o.is_active = TRUE
        AND o.user_id = current_user_id
        ORDER BY o.is_active DESC, o.created_at DESC
        LIMIT outfits_per_page OFFSET offset_val
    ) o;

    RETURN result;
END;
$$;

CREATE OR REPLACE FUNCTION outfit_focused_date(_outfit_id uuid)
RETURNS BOOLEAN
LANGUAGE plpgsql
SET search_path = ''
AS $$
DECLARE
    current_user_id UUID := auth.uid();
    outfit_created_at TIMESTAMP;
BEGIN
    -- Fetch the created_at date of the outfit for the authenticated user
    SELECT created_at INTO outfit_created_at
    FROM public.outfits
    WHERE outfit_id = _outfit_id AND user_id = current_user_id;

    -- If no outfit is found, return FALSE
    IF outfit_created_at IS NULL THEN
        RETURN FALSE;
    END IF;

    -- Update the shared_preferences table for the user
    UPDATE public.shared_preferences
    SET
        focused_date = outfit_created_at,
        only_unworn = false
    WHERE user_id = current_user_id;

    -- Check if the update was successful
    IF NOT FOUND THEN
        RETURN FALSE; -- If no rows were updated, return FALSE
    END IF;

    -- Update the outfits table's updated_at timestamp
    UPDATE public.outfits
    SET updated_at = NOW()
    WHERE outfit_id = _outfit_id;

    -- If everything succeeded, return TRUE
    RETURN TRUE;
END;
$$;

CREATE OR REPLACE FUNCTION get_active_items_from_calendar(selected_outfit_ids UUID[])
RETURNS UUID[]
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id UUID := auth.uid();
    active_item_ids UUID[];
BEGIN
    -- Update shared_preferences for the current user
    UPDATE public.shared_preferences
    SET
        all_closet = TRUE,
        sort = 'updated_at',
        sort_order = 'DESC',
        filter = '{}'::jsonb,  -- Corrected JSONB empty object
        only_unworn = FALSE,
        ignore_item_name = TRUE,
        updated_at = NOW()
    WHERE user_id = current_user_id;

    -- Retrieve active item IDs
    SELECT ARRAY_AGG(DISTINCT i.item_id)
    INTO active_item_ids
    FROM public.outfit_items oi
    INNER JOIN public.items i ON oi.item_id = i.item_id
    INNER JOIN public.outfits o ON oi.outfit_id = o.outfit_id
    WHERE
        o.user_id = current_user_id AND
        i.current_owner_id = current_user_id AND
        oi.outfit_id = ANY(selected_outfit_ids) AND
        i.is_active = TRUE;

    -- Update `updated_at` in public.items for retrieved items
    UPDATE public.items
    SET updated_at = NOW()
    WHERE item_id = ANY(active_item_ids)
    AND current_owner_id = current_user_id;

    RETURN active_item_ids;
END;
$$;

create or replace function fetch_filter_settings()
returns jsonb
language sql
SET search_path = ''
as $$
    select json_build_object(
        'f_filter', filter,
        'f_closet_id', closet_id,
        'f_all_closet', all_closet,
        'f_only_unworn', only_unworn,
        'f_item_name', item_name,
        'f_ignore_event_name', ignore_item_name
    )
    from public.shared_preferences
    where user_id = auth.uid();
$$;

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
                    'event_name', fo.event_name,
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