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

    -- Check if the focused_date is already up to date
    SELECT TRUE INTO result
    FROM public.shared_preferences sp
    JOIN public.outfits o ON o.outfit_id = f_outfit_id
    WHERE o.user_id = current_user_id
    AND sp.user_id = current_user_id
    AND sp.focused_date = o.created_at;

    -- If the value is already set, return TRUE
    IF result THEN
        RETURN TRUE;
    END IF;

    -- Otherwise, attempt to update the focused_date
    UPDATE public.shared_preferences sp
    SET focused_date = o.created_at,
        updated_at = NOW()
    FROM public.outfits o
    WHERE o.outfit_id = f_outfit_id
    AND o.user_id = current_user_id
    AND sp.user_id = current_user_id
    AND sp.focused_date IS DISTINCT FROM o.created_at
    RETURNING TRUE INTO result;

    -- Return TRUE if updated, FALSE otherwise
    RETURN COALESCE(result, FALSE);
END;
$$;


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
          OR o.event_name ILIKE '%' || COALESCE(f_event_name_filter, '') || '%'
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
        ORDER BY
            CASE
                WHEN f_outfit_id IS NOT NULL AND o.outfit_id = f_outfit_id THEN 0
                ELSE 1
            END, o.outfit_id
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
