CREATE OR REPLACE FUNCTION fetch_monthly_calendar_images()
RETURNS JSONB
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    f_focused_date DATE;
    f_ignore_event_name BOOLEAN;
    event_name_filter TEXT;
    feedback_filter TEXT;
    is_outfit_active_filter BOOLEAN;
    start_date DATE;
    end_date DATE;
    current_user_id UUID := auth.uid();
    has_previous_outfits BOOLEAN;
    has_next_outfits BOOLEAN;
    has_reviewed_outfits BOOLEAN;
    has_filtered_outfits BOOLEAN;
    latest_reviewed_date DATE;
    is_calendar_selectable BOOLEAN;
    result JSONB;
BEGIN
    -- Step 1: Fetch user preferences from shared_preferences
    SELECT
        focused_date,
        ignore_event_name,
        event_name,
        feedback,
        is_outfit_active,
        is_calendar_selectable
    INTO
        f_focused_date,
        f_ignore_event_name,
        event_name_filter,
        feedback_filter,
        is_outfit_active_filter,
        is_calendar_selectable
    FROM public.shared_preferences
    WHERE user_id = current_user_id;

    -- Step 2: Check if the user has reviewed outfits
    SELECT EXISTS(
        SELECT 1 FROM public.outfits
        WHERE reviewed = true AND user_id = current_user_id
    ) INTO has_reviewed_outfits;

    IF NOT has_reviewed_outfits THEN
        RETURN JSONB_BUILD_OBJECT('status', 'no reviewed outfit');
    END IF;

    -- Step 3: Filter reviewed outfits
    WITH filtered_outfits AS (
        SELECT *,
               created_at::DATE = f_focused_date::DATE AS has_outfit_on_date
        FROM public.outfits
        WHERE reviewed = true
          AND user_id = current_user_id
          AND (
              f_ignore_event_name OR event_name ILIKE event_name_filter
          )
          AND (
              feedback_filter = 'all' OR feedback = feedback_filter
          )
          AND (
              is_outfit_active_filter = 'all' OR
              (is_outfit_active_filter = 'active' AND is_active = true) OR
              (is_outfit_active_filter = 'inactive' AND is_active = false)
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
        MAX(created_at::DATE) FILTER (WHERE has_outfit_on_date = FALSE) INTO latest_reviewed_date
    FROM filtered_outfits;

    IF latest_reviewed_date IS NOT NULL THEN
        f_focused_date := latest_reviewed_date;

        -- Optional: Update shared_preferences with the new focused date
        UPDATE public.shared_preferences
        SET focused_date = latest_reviewed_date
        WHERE user_id = current_user_id;
    END IF;

    -- Step 5: Calculate date range based on the (updated) focused date
    start_date := date_trunc('month', f_focused_date) - INTERVAL '1 day';
    end_date := (date_trunc('month', f_focused_date) + INTERVAL '1 month') ;

    -- Step 6: Compute backward_arrow and forward_arrow
    SELECT
        EXISTS(SELECT 1 FROM filtered_outfits WHERE created_day < start_date),
        EXISTS(SELECT 1 FROM filtered_outfits WHERE created_day > end_date)
    INTO has_previous_outfits, has_next_outfits;

    WITH calendar_outfits AS (
        SELECT
            created_day,
            JSONB_BUILD_OBJECT(
                'outfit_id', outfit_id,
                'outfit_image_url', CASE
                    WHEN outfit_image_url = 'cc_none' THEN NULL
                    ELSE outfit_image_url
                END,
                'items', CASE
                    WHEN outfit_image_url IS NULL OR outfit_image_url = 'cc_none' THEN (
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
        WHERE created_day BETWEEN start_date AND end_date
        ORDER BY created_day
    )
    SELECT JSONB_AGG(
        JSONB_BUILD_OBJECT(
            'date', created_day,
            'outfit_data', outfit_data
        )
    )
    INTO result
    FROM calendar_outfits;

    -- Step 7: Return the final JSON object
    RETURN JSONB_BUILD_OBJECT(
        'status', 'success',
        'focused_date', f_focused_date,
        'start_date', start_date,
        'end_date', end_date,
        'has_previous_outfits', has_previous_outfits,
        'has_next_outfits', has_next_outfits,
        'calendar_data', result
    );
END;
$$;
