CREATE OR REPLACE FUNCTION fetch_items_with_preferences(p_current_page INT)
RETURNS TABLE(
  item_id UUID,
  image_url TEXT,
  name TEXT,
  item_type TEXT
)
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
  items_per_page INT;
  offset_val INT;
  sort_column TEXT;
  sort_direction TEXT;
  current_user_id UUID := auth.uid();
BEGIN

  -- Calculate items per page and offset based on user preferences
  SELECT
    FLOOR(grid * 1.5 * grid)::INT,  -- Use floor to avoid rounding up
    sort,
    sort_order
  INTO
    items_per_page,
    sort_column,
    sort_direction
  FROM
    public.shared_preferences sp
  WHERE
    sp.user_id = current_user_id;

  -- Standard offset calculation without any additional adjustments
  offset_val := p_current_page * items_per_page;

  -- Execute dynamic SQL for sorting and pagination
  RETURN QUERY EXECUTE FORMAT(
    $sql$
    SELECT
      i.item_id,
      i.image_url,
      i.name,
      i.item_type
    FROM
      public.items i
    LEFT JOIN public.items_accessory_basic a ON i.item_id = a.item_id AND i.item_type = 'accessory'
    LEFT JOIN public.items_clothing_basic c ON i.item_id = c.item_id AND i.item_type = 'clothing'
    LEFT JOIN public.items_shoes_basic s ON i.item_id = s.item_id AND i.item_type = 'shoes'
    JOIN public.shared_preferences sp ON i.current_owner_id = sp.user_id
    WHERE
      i.is_active = true
      AND (sp.all_closet OR i.closet_id = sp.closet_id)  -- Closet filter
      AND (
          sp.ignore_item_name  -- ✅ Skip name filtering if ignore_item_name is true
          OR (sp.item_name IS NOT NULL AND i.name ILIKE '%%' || sp.item_name || '%%')  -- ✅ Apply filtering only if item_name is provided
      )
      AND (
        sp.filter = '{}'::jsonb OR sp.filter IS NULL
        OR (
          (sp.filter->'item_type' IS NULL OR EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'item_type') elem WHERE elem = i.item_type
          ))
          AND (sp.filter->'occasion' IS NULL OR EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'occasion') elem WHERE elem = i.occasion
          ))
          AND (sp.filter->'season' IS NULL OR EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'season') elem WHERE elem = i.season
          ))
          AND (sp.filter->'colour' IS NULL OR EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'colour') elem WHERE elem = i.colour
          ))
          AND (sp.filter->'colour_variations' IS NULL OR EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'colour_variations') elem WHERE elem = i.colour_variations
          ))
          AND (sp.filter->'accessory_type' IS NULL OR (i.item_type = 'accessory' AND EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'accessory_type') elem WHERE elem = a.accessory_type
          )))
          AND (sp.filter->'clothing_type' IS NULL OR (i.item_type = 'clothing' AND EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'clothing_type') elem WHERE elem = c.clothing_type
          )))
          AND (sp.filter->'clothing_layer' IS NULL OR (i.item_type = 'clothing' AND EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'clothing_layer') elem WHERE elem = c.clothing_layer
          )))
          AND (sp.filter->'shoes_type' IS NULL OR (i.item_type = 'shoes' AND EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'shoes_type') elem WHERE elem = s.shoes_type
          )))
        )
      )
      ORDER BY i.%I %s, i.item_id -- Stable sorting with item_id as a secondary criterion
      OFFSET %L LIMIT %L
    $sql$,
    sort_column,      -- Injects the validated column name
    sort_direction,   -- Injects the sort direction (ASC or DESC)
    offset_val,
    items_per_page
  );

END;
$$;

CREATE OR REPLACE FUNCTION fetch_outfit_items_with_preferences(
  p_current_page INT,
  p_category TEXT
)
RETURNS TABLE(
  item_id UUID,
  image_url TEXT,
  name TEXT,
  item_type TEXT
)
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
  items_per_page INT;
  offset_val INT;
  sort_column TEXT;
  sort_direction TEXT;
  current_user_id UUID := auth.uid();
BEGIN

  -- Calculate items per page and offset based on user preferences
  SELECT
    FLOOR(grid * 1.5 * grid)::INT,  -- Use floor to avoid rounding up
    sort,
    sort_order
  INTO
    items_per_page,
    sort_column,
    sort_direction
  FROM
    public.shared_preferences sp
  WHERE
    sp.user_id = current_user_id;

  -- Standard offset calculation
  offset_val := p_current_page * items_per_page;

  -- Execute dynamic SQL for sorting, pagination, and filtering
  RETURN QUERY EXECUTE FORMAT(
    $sql$
    SELECT
      i.item_id,
      i.image_url,
      i.name,
      i.item_type
    FROM
      public.items i
    LEFT JOIN public.items_accessory_basic a ON i.item_id = a.item_id AND i.item_type = 'accessory'
    LEFT JOIN public.items_clothing_basic c ON i.item_id = c.item_id AND i.item_type = 'clothing'
    LEFT JOIN public.items_shoes_basic s ON i.item_id = s.item_id AND i.item_type = 'shoes'
    JOIN public.shared_preferences sp ON i.current_owner_id = sp.user_id
    WHERE
      i.is_active = true
      AND i.item_type = %L  -- Mandatory category filter
      AND (sp.all_closet OR i.closet_id = sp.closet_id)  -- Closet filter
      AND (
          sp.ignore_item_name
          OR (sp.item_name IS NOT NULL AND i.name ILIKE '%%' || sp.item_name || '%%')
      )
      AND (
        sp.filter = '{}'::jsonb OR sp.filter IS NULL
        OR (
          (sp.filter->'item_type' IS NULL OR EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'item_type') elem WHERE elem = i.item_type
          ))
          AND (sp.filter->'occasion' IS NULL OR EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'occasion') elem WHERE elem = i.occasion
          ))
          AND (sp.filter->'season' IS NULL OR EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'season') elem WHERE elem = i.season
          ))
          AND (sp.filter->'colour' IS NULL OR EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'colour') elem WHERE elem = i.colour
          ))
          AND (sp.filter->'colour_variations' IS NULL OR EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'colour_variations') elem WHERE elem = i.colour_variations
          ))
          AND (sp.filter->'accessory_type' IS NULL OR (i.item_type = 'accessory' AND EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'accessory_type') elem WHERE elem = a.accessory_type
          )))
          AND (sp.filter->'clothing_type' IS NULL OR (i.item_type = 'clothing' AND EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'clothing_type') elem WHERE elem = c.clothing_type
          )))
          AND (sp.filter->'clothing_layer' IS NULL OR (i.item_type = 'clothing' AND EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'clothing_layer') elem WHERE elem = c.clothing_layer
          )))
          AND (sp.filter->'shoes_type' IS NULL OR (i.item_type = 'shoes' AND EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'shoes_type') elem WHERE elem = s.shoes_type
          )))
        )
      )
      ORDER BY i.%I %s, i.item_id -- Stable sorting with item_id as secondary criterion
      OFFSET %L LIMIT %L
    $sql$,
    p_category,      -- Injects the validated category filter
    sort_column,      -- Injects the validated column name
    sort_direction,   -- Injects the sort direction (ASC or DESC)
    offset_val,
    items_per_page
  );

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
        -- Step 5A: Try to find the **latest available** future outfit first
        SELECT MAX(tfo.created_day)  -- Pick the latest future date
        INTO latest_reviewed_date
        FROM temp_filtered_outfits tfo
        WHERE tfo.created_day > f_focused_date;  -- Only future dates

        IF latest_reviewed_date IS NULL THEN
            SELECT MAX(tfo.created_day)  -- Pick the latest past date
            INTO latest_reviewed_date
            FROM temp_filtered_outfits tfo
            WHERE tfo.created_day < f_focused_date;  -- Only past dates
        END IF;

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
        SELECT DISTINCT ON (tfo.created_day)  -- ✅ Fixed alias
            tfo.created_day,
            tfo.outfit_id,
            tfo.outfit_image_url,
            tfo.created_at
        FROM temp_filtered_outfits tfo  -- ✅ Correct alias
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
