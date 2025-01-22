CREATE OR REPLACE FUNCTION fetch_calendar_metadata()
RETURNS TABLE (
    event_name TEXT,
    ignore_event_name BOOLEAN,
    feedback TEXT,
    is_calendar_selectable BOOLEAN,
    is_outfit_active TEXT
)
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    -- Automatically retrieve the current user's ID
    current_user_id UUID := auth.uid();
BEGIN
    RETURN QUERY
    SELECT
        sp.event_name,
        sp.ignore_event_name,
        sp.feedback,
        sp.is_calendar_selectable,
        sp.is_outfit_active
    FROM
        public.shared_preferences sp
    WHERE
        sp.user_id = current_user_id;
END;
$$;

CREATE OR REPLACE FUNCTION fetch_monthly_calendar_images()
RETURNS JSONB
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    f_focused_date DATE;
    f_ignore_event_name BOOLEAN;
    f_event_name_filter TEXT;
    f_feedback_filter TEXT;
    f_is_outfit_active_filter BOOLEAN;
    f_start_date DATE;
    f_end_date DATE;
    current_user_id UUID := auth.uid();
    has_previous_outfits BOOLEAN;
    has_next_outfits BOOLEAN;
    has_reviewed_outfits BOOLEAN;
    has_filtered_outfits BOOLEAN;
    latest_reviewed_date DATE;
    f_is_calendar_selectable BOOLEAN;
    result JSONB;
BEGIN
    -- Step 1: Fetch user preferences from shared_preferences
    SELECT
        sp.focused_date,
        sp.ignore_event_name,
        sp.event_name,
        sp.feedback,
        sp.is_outfit_active,
        sp.is_calendar_selectable
    INTO
        f_focused_date,
        f_ignore_event_name,
        f_event_name_filter,
        f_feedback_filter,
        f_is_outfit_active_filter,
        f_is_calendar_selectable
    FROM public.shared_preferences sp
    WHERE sp.user_id = current_user_id;

    -- Step 2: Check if the user has reviewed outfits
    SELECT EXISTS(
        SELECT 1 FROM public.outfits o
        WHERE o.reviewed = true AND o.user_id = current_user_id
    ) INTO has_reviewed_outfits;

    IF NOT has_reviewed_outfits THEN
        RETURN JSONB_BUILD_OBJECT('status', 'no reviewed outfit');
    END IF;

    -- Step 3: Filter reviewed outfits
    WITH filtered_outfits AS (
        SELECT *,
               o.created_at::DATE = f_focused_date::DATE AS has_outfit_on_date
        FROM public.outfits o
        WHERE o.reviewed = true
          AND o.user_id = current_user_id
          AND (
              f_ignore_event_name OR o.event_name ILIKE f_event_name_filter
          )
          AND (
              f_feedback_filter = 'all' OR o.feedback = f_feedback_filter
          )
          AND (
              f_is_outfit_active_filter = 'all' OR
              (f_is_outfit_active_filter = 'active' AND o.is_active = true) OR
              (f_is_outfit_active_filter = 'inactive' AND o.is_active = false)
          )
    )
    -- Check if filtered_outfits is empty
    SELECT EXISTS(
        SELECT 1 FROM filtered_outfits
    ) INTO has_filtered_outfits;

    IF NOT has_filtered_outfits THEN
        RETURN JSONB_BUILD_OBJECT('status', 'no reviewed outfit with filter');
    END IF;

    -- Step 4: Update focused date if no outfit exists for the current date
    SELECT
        MAX(o.created_at::DATE) FILTER (WHERE o.has_outfit_on_date = FALSE)
    INTO latest_reviewed_date
    FROM filtered_outfits o;

    IF latest_reviewed_date IS NOT NULL THEN
        f_focused_date := latest_reviewed_date;

        -- Optional: Update shared_preferences with the new focused date
        UPDATE public.shared_preferences sp
        SET sp.focused_date = latest_reviewed_date
        WHERE sp.user_id = current_user_id;
    END IF;

    -- Step 5: Calculate date range based on the (updated) focused date
    f_start_date := date_trunc('month', f_focused_date) - INTERVAL '1 day';
    f_end_date := (date_trunc('month', f_focused_date) + INTERVAL '1 month');

    -- Step 6: Compute backward_arrow and forward_arrow
    SELECT
        EXISTS(SELECT 1 FROM filtered_outfits o WHERE o.created_day < f_start_date),
        EXISTS(SELECT 1 FROM filtered_outfits o WHERE o.created_day > f_end_date)
    INTO has_previous_outfits, has_next_outfits;

    WITH calendar_outfits AS (
        SELECT
            o.created_day,
            JSONB_BUILD_OBJECT(
                'outfit_id', o.outfit_id,
                'outfit_image_url', CASE
                    WHEN o.outfit_image_url = 'cc_none' THEN NULL
                    ELSE o.outfit_image_url
                END,
                'items', CASE
                    WHEN o.outfit_image_url IS NULL OR o.outfit_image_url = 'cc_none' THEN (
                        SELECT JSONB_AGG(
                            JSONB_BUILD_OBJECT(
                                'item_id', i.item_id,
                                'item_image_url', i.image_url
                            )
                        )
                        FROM public.outfit_items oi
                        JOIN public.items i ON oi.item_id = i.item_id
                        WHERE oi.outfit_id = o.outfit_id
                    )
                    ELSE NULL
                END
            ) AS outfit_data
        FROM filtered_outfits o
        WHERE o.created_day BETWEEN f_start_date AND f_end_date
        ORDER BY o.created_day
    )
    SELECT JSONB_AGG(
        JSONB_BUILD_OBJECT(
            'date', o.created_day,
            'outfit_data', o.outfit_data
        )
    )
    INTO result
    FROM calendar_outfits o;

    -- Step 7: Return the final JSON object
    RETURN JSONB_BUILD_OBJECT(
        'status', 'success',
        'focused_date', f_focused_date,
        'start_date', f_start_date,
        'end_date', f_end_date,
        'has_previous_outfits', has_previous_outfits,
        'has_next_outfits', has_next_outfits,
        'calendar_data', result
    );
END;
$$;
