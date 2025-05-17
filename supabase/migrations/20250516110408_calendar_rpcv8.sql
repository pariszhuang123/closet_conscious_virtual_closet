CREATE OR REPLACE FUNCTION navigate_calendar(
    direction TEXT, -- Accepts 'backward' or 'forward'
    navigation_mode TEXT DEFAULT 'detailed' -- Accepts 'detailed' (day) or 'monthly' (month)
)
RETURNS BOOLEAN
SET search_path = ''
LANGUAGE plpgsql
AS $$

DECLARE
    current_focused_date DATE;
    next_date DATE;
    current_user_id UUID := auth.uid();
    f_ignore_event_name BOOLEAN;
    f_event_name_filter TEXT;
    f_feedback_filter TEXT;
    f_is_outfit_active_filter TEXT;
    has_filtered_outfits BOOLEAN;
BEGIN
    -- Step 1: Retrieve the current focused date and user preferences from shared_preferences
    SELECT
        sp.focused_date,
        sp.ignore_event_name,
        sp.event_name,
        sp.feedback,
        sp.is_outfit_active
    INTO
        current_focused_date,
        f_ignore_event_name,
        f_event_name_filter,
        f_feedback_filter,
        f_is_outfit_active_filter
    FROM public.shared_preferences sp
    WHERE sp.user_id = current_user_id;

    -- If no focused_date is set, return FALSE
    IF current_focused_date IS NULL THEN
        RETURN FALSE;
    END IF;

    -- Step 2: Create temporary table for filtered outfits
    DROP TABLE IF EXISTS temp_filtered_outfits;

    CREATE TEMP TABLE temp_filtered_outfits AS
    SELECT
        o.*,
        o.created_at::DATE AS created_day
    FROM public.outfits o
    WHERE o.reviewed = TRUE
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
          OR (f_is_outfit_active_filter = 'active' AND o.is_active = TRUE)
          OR (f_is_outfit_active_filter = 'inactive' AND o.is_active = FALSE)
      );

    -- Step 3: Check if temp_filtered_outfits has data
    SELECT EXISTS(SELECT 1 FROM temp_filtered_outfits)
    INTO has_filtered_outfits;

    IF NOT has_filtered_outfits THEN
        DROP TABLE IF EXISTS temp_filtered_outfits;
        RETURN FALSE;
    END IF;

    -- Step 4: Determine the next date based on navigation mode and direction
    SELECT
        CASE
            -- Monthly navigation - ensure result is not in same month
            WHEN navigation_mode = 'monthly' AND direction = 'backward' THEN
                MAX(created_day)
                FILTER (
                    WHERE created_day < date_trunc('month', current_focused_date)
                      AND date_trunc('month', created_day) <> date_trunc('month', current_focused_date)
                )
            WHEN navigation_mode = 'monthly' AND direction = 'forward' THEN
                MIN(created_day)
                FILTER (
                    WHERE created_day >= (date_trunc('month', current_focused_date) + INTERVAL '1 month')
                      AND date_trunc('month', created_day) <> date_trunc('month', current_focused_date)
                )

            -- Detailed (day) navigation
            WHEN navigation_mode = 'detailed' AND direction = 'backward' THEN
                MAX(created_day)
                FILTER (WHERE created_day < current_focused_date)
            WHEN navigation_mode = 'detailed' AND direction = 'forward' THEN
                MIN(created_day)
                FILTER (WHERE created_day > current_focused_date)
        END
    INTO next_date
    FROM temp_filtered_outfits;

    -- Step 5: Drop the temporary table
    DROP TABLE IF EXISTS temp_filtered_outfits;

    -- If no valid next date is found, return FALSE
    IF next_date IS NULL THEN
        RETURN FALSE;
    END IF;

    -- Step 6: Update focused_date in shared_preferences
    UPDATE public.shared_preferences
    SET
        focused_date = next_date,
        updated_at = NOW()
    WHERE user_id = current_user_id;

    RETURN TRUE;
END;
$$;
