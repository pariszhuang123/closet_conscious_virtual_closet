CREATE OR REPLACE FUNCTION fetch_monthly_calendar_images()
RETURNS JSONB
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    f_focused_date DATE;
    f_focused_date_valid BOOLEAN;
    f_ignore_event_name BOOLEAN;
    f_event_name_filter TEXT;
    f_feedback_filter TEXT;
    f_is_outfit_active_filter TEXT;
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
        SELECT 1
        FROM public.outfits o
        WHERE o.reviewed = true
          AND o.user_id = current_user_id
    )
    INTO has_reviewed_outfits;

    IF NOT has_reviewed_outfits THEN
        RETURN JSONB_BUILD_OBJECT('status', 'no reviewed outfit');
    END IF;

    -- Step 3: Create a temporary table for filtered_outfits
    CREATE TEMP TABLE temp_filtered_outfits ON COMMIT DROP AS
    SELECT
        o.*,
        o.created_at::DATE AS created_day,         -- Consolidate created_at to created_day
        o.created_at::DATE = f_focused_date::DATE AS has_outfit_on_date
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

    -- Step 4: Check if filtered_outfits is empty
    SELECT EXISTS(SELECT 1 FROM temp_filtered_outfits)
    INTO has_filtered_outfits;

    IF NOT has_filtered_outfits THEN
        RETURN JSONB_BUILD_OBJECT('status', 'no reviewed outfit with filter');
    END IF;

    SELECT EXISTS (
        SELECT 1
        FROM temp_filtered_outfits tfo
        WHERE tfo.created_day = f_focused_date
    ) INTO f_focused_date_valid;


    -- Step 5: Update focused date if no outfit exists for the current date
-- If f_focused_date is valid, do NOT override it with latest_reviewed_date
    IF NOT f_focused_date_valid THEN
        SELECT MAX(created_day)
        INTO latest_reviewed_date
        FROM temp_filtered_outfits tfo
        WHERE tfo.created_day <= f_focused_date;  -- Ensure we pick a previous valid date

        -- Only update f_focused_date if latest_reviewed_date is not NULL and different from f_focused_date
        IF latest_reviewed_date IS NOT NULL AND latest_reviewed_date <> f_focused_date THEN
            f_focused_date := latest_reviewed_date;

            -- Update shared_preferences only if we changed f_focused_date
            UPDATE public.shared_preferences
            SET focused_date = latest_reviewed_date
            WHERE user_id = current_user_id;
        END IF;
    END IF;

    -- Step 6: Calculate date range
    f_start_date := date_trunc('month', f_focused_date) - INTERVAL '1 day';
    f_end_date := (date_trunc('month', f_focused_date) + INTERVAL '1 month');

    -- Step 7: Compute backward_arrow and forward_arrow
    SELECT
        EXISTS(SELECT 1 FROM temp_filtered_outfits tfo WHERE tfo.created_day < f_start_date),
        EXISTS(SELECT 1 FROM temp_filtered_outfits tfo WHERE tfo.created_day > f_end_date)
    INTO has_previous_outfits, has_next_outfits;

    ----------------------------------------------------------------------------
    -- Step 8: Fetch only the FIRST OUTFIT per day using DISTINCT ON
    ----------------------------------------------------------------------------
    WITH daily_first_outfit AS (
        SELECT DISTINCT ON (o.created_day)
            o.created_day,
            o.outfit_id,
            o.outfit_image_url,
            o.created_at
        FROM temp_filtered_outfits tfo
        WHERE tfo.created_day BETWEEN f_start_date AND f_end_date
        ORDER BY tfo.created_day, tfo.created_at
    )
    SELECT JSONB_AGG(
        JSONB_BUILD_OBJECT(
            'date', d.created_day,
            'outfit_data', JSONB_BUILD_OBJECT(
                'outfit_id', d.outfit_id,
                'outfit_image_url', d.outfit_image_url,
                'items', CASE
                    -- If outfit_image_url is 'cc_none', fetch related item details
                    WHEN d.outfit_image_url = 'cc_none' THEN (
                        SELECT JSONB_AGG(
                            JSONB_BUILD_OBJECT(
                                'item_id', p.item_id,
                                'image_url', p.image_url,
                                'name', p.name
                            )
                        )
                        FROM (
                            SELECT DISTINCT ON (oi.outfit_id)
                                i.item_id, i.image_url, i.name
                            FROM public.outfit_items oi
                            JOIN public.items i ON oi.item_id = i.item_id
                            WHERE oi.outfit_id = d.outfit_id
                            ORDER BY oi.outfit_id, i.is_active DESC, i.created_at DESC
                        ) AS p
                    )
                    ELSE NULL
                END
            )
        )
    ) AS calendar_data
    INTO result
    FROM daily_first_outfit d;

    -- Step 9: Drop the temporary table
    DROP TABLE IF EXISTS temp_filtered_outfits;

    -- Step 10: Return the final JSON object
    RETURN JSONB_BUILD_OBJECT(
        'status', 'success',
        'focused_date', f_focused_date,
        'start_date', f_start_date,
        'end_date', f_end_date,
        'has_previous_outfits', has_previous_outfits,
        'has_next_outfits', has_next_outfits,
        'is_calendar_selectable', f_is_calendar_selectable,
        'calendar_data', result
    );
END;
$$;
