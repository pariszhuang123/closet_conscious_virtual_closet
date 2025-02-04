DROP FUNCTION IF EXISTS update_filter_settings(
    jsonb,
    text,
    bool,
    bool,
    text
);

DROP FUNCTION IF EXISTS fetch_daily_outfits();

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
            'items', COALESCE(
                JSONB_AGG(
                    JSONB_BUILD_OBJECT(
                        'item_id', di.item_id,
                        'item_image_url', di.item_image_url,
                        'item_name', di.item_name,
                        'item_is_active', di.item_is_active,
                        'disliked', di.disliked
                    )
                ) FILTER (WHERE di.item_id IS NOT NULL), '[]'
            )
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
            i.item_id,
            i.item_image_url,
            i.name AS item_name,
            i.is_active AS item_is_active,
            oi.disliked
        FROM public.outfit_items oi
        JOIN public.items i
            ON oi.item_id = i.item_id
            WHERE i.current_owner_id = current_user_id
    ) di
    ON opd.outfit_id = di.outfit_id
    GROUP BY opd.outfit_id;

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

CREATE OR REPLACE FUNCTION public.activate_trial_premium_features()
RETURNS BOOLEAN
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    -- Automatically retrieve the current user's ID
    current_user_id UUID := auth.uid();
    v_target_features TEXT[] := ARRAY[
        'com.makinglifeeasie.closetconscious.filter',
        'com.makinglifeeasie.closetconscious.arrange',
        'com.makinglifeeasie.closetconscious.multicloset',
        'com.makinglifeeasie.closetconscious.multipleoutfits',
        'com.makinglifeeasie.closetconscious.calendar'
    ];
    v_one_off_features JSONB;
BEGIN
    -- Check if the user is authenticated
    IF current_user_id IS NULL THEN
        RAISE EXCEPTION 'User not authenticated';
    END IF;

    -- Quick pass: Check if the user is ineligible for update
    IF NOT EXISTS (
        SELECT 1
        FROM public.premium_services
        WHERE user_id = current_user_id
          AND DATE(created_at) = CURRENT_DATE
          AND is_trial = FALSE
    ) THEN
        RETURN FALSE; -- User does not meet the criteria for update
    END IF;

    -- Build the JSONB object for the target features
    v_one_off_features := (
        SELECT jsonb_object_agg(
            u.feature_key,
            jsonb_build_object(
                'acquisition_date', (CURRENT_TIMESTAMP + INTERVAL '30 days')::TEXT,
                'acquisition_method', 'trial'
            )
        )
        FROM (
            SELECT UNNEST(v_target_features) AS feature_key
        ) u
    );

    -- Update the premium_services table
    UPDATE public.premium_services
    SET one_off_features = COALESCE(one_off_features, '{}'::JSONB) || v_one_off_features,
        is_trial = TRUE
    WHERE user_id = current_user_id
      AND is_trial = FALSE
      AND DATE(created_at) = CURRENT_DATE;

    RETURN TRUE; -- Update was successful
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
    DROP TABLE IF EXISTS temp_filtered_outfits;

    CREATE TEMP TABLE temp_filtered_outfits AS
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

    -- Step 5: Update focused date if no outfit exists for the current date
    SELECT
        MAX(o.created_day) FILTER (WHERE NOT o.has_outfit_on_date)
    INTO latest_reviewed_date
    FROM temp_filtered_outfits o;

    IF latest_reviewed_date IS NOT NULL THEN
        f_focused_date := latest_reviewed_date;

        -- Optional: Update shared_preferences with the new focused date
        UPDATE public.shared_preferences
        SET focused_date = latest_reviewed_date
        WHERE user_id = current_user_id;
    END IF;

    -- Step 6: Calculate date range
    f_start_date := date_trunc('month', f_focused_date) - INTERVAL '1 day';
    f_end_date := (date_trunc('month', f_focused_date) + INTERVAL '1 month');

    -- Step 7: Compute backward_arrow and forward_arrow
    SELECT
        EXISTS(SELECT 1 FROM temp_filtered_outfits o WHERE o.created_day < f_start_date),
        EXISTS(SELECT 1 FROM temp_filtered_outfits o WHERE o.created_day > f_end_date)
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
        FROM temp_filtered_outfits o
        WHERE o.created_day BETWEEN f_start_date AND f_end_date
        ORDER BY o.created_day, o.created_at
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
                                'item_id', i.item_id,
                                'image_url', i.image_url,
                                'name', i.name
                            )
                        )
                        FROM public.outfit_items oi
                        JOIN public.items i ON oi.item_id = i.item_id
                        WHERE oi.outfit_id = d.outfit_id
                        ORDER BY i.is_active DESC, i.created_at DESC
                        LIMIT 1
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
            -- Monthly navigation
            WHEN navigation_mode = 'monthly' AND direction = 'backward' THEN
                MAX(created_day)
                FILTER (WHERE created_day < date_trunc('month', current_focused_date))
            WHEN navigation_mode = 'monthly' AND direction = 'forward' THEN
                MIN(created_day)
                FILTER (WHERE created_day >= (date_trunc('month', current_focused_date) + INTERVAL '1 month'))

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
