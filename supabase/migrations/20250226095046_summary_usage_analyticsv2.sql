ALTER TABLE public.shared_preferences
ADD COLUMN only_unworn BOOLEAN NOT NULL DEFAULT FALSE;

COMMENT ON COLUMN public.shared_preferences.only_unworn
IS 'Boolean flag to filter only unworn items: TRUE shows only unworn items, FALSE shows all items.';

create or replace function save_default_selection()
returns jsonb
language plpgsql
SET search_path = ''
as $$
declare
    default_closet_id uuid;
    current_user_id uuid := auth.uid();
begin
    -- Retrieve the closet_id from user_closets where closet_name is 'cc_closet' for the authenticated user
    select closet_id into default_closet_id
    from public.user_closets
    where user_id = current_user_id
      and closet_name = 'cc_closet';

    -- Reset the user's preferences to default values
    update public.shared_preferences
    set
        filter = '{}'::jsonb,
        closet_id = default_closet_id,
        all_closet = FALSE,
        only_unworn = FALSE,
        item_name = 'cc_none',
        ignore_item_name = TRUE
    where user_id = current_user_id;

    -- Return the updated values as a single JSON object
    return json_build_object(
        'r_filter', '{}'::jsonb,
        'r_closet_id', default_closet_id,
        'r_all_closet', FALSE,
        'r_only_unworn', FALSE,
        'r_item_name', ''
    );
end;
$$;

create or replace function update_filter_settings(
    new_filter jsonb,
    new_closet_id text,
    new_only_unworn bool,
    new_all_closet bool,
    new_item_name text
)
returns jsonb
SET search_path = ''
language plpgsql
as $$
declare
    result jsonb;
    current_user_id uuid := auth.uid();
begin
  -- Update the user_preferences row for the authenticated user
  update public.shared_preferences
  set
      filter = new_filter,
      closet_id = new_closet_id::uuid,
      all_closet = new_all_closet,
      only_unworn = new_only_unworn,
      ignore_item_name = case
                            when new_item_name is null or new_item_name = '' then TRUE
                            else FALSE
                         end,
      item_name = case
                     when new_item_name is null or new_item_name = '' then 'cc_none'
                     else new_item_name
                  end
  where user_id = current_user_id;

  -- Check if the update was successful
  if found then
    result := jsonb_build_object('status', 'success', 'message', 'Filter settings updated successfully');
  else
    result := jsonb_build_object('status', 'error', 'message', 'Failed to update filter settings');
  end if;

  return result;
end;
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
        'f_item_name', case when item_name = 'cc_none' then '' else item_name end
    )
    from public.shared_preferences
    where user_id = auth.uid();
$$;


CREATE OR REPLACE FUNCTION fetch_item_with_preferences(p_current_page INT)
RETURNS TABLE(
  item_id UUID,
  image_url TEXT,
  name TEXT,
  item_type TEXT,
  price_per_wear NUMERIC
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

  -- Retrieve user preferences for pagination & sorting
  SELECT
    FLOOR(grid * 1.5 * grid)::INT,
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

  offset_val := p_current_page * items_per_page;

  -- Execute dynamic SQL
  RETURN QUERY EXECUTE FORMAT(
    $sql$
    SELECT
      i.item_id,
      i.image_url,
      i.name,
      i.item_type,
      i.price_per_wear
    FROM
      public.items i
    LEFT JOIN public.items_accessory_basic a ON i.item_id = a.item_id AND i.item_type = 'accessory'
    LEFT JOIN public.items_clothing_basic c ON i.item_id = c.item_id AND i.item_type = 'clothing'
    LEFT JOIN public.items_shoes_basic s ON i.item_id = s.item_id AND i.item_type = 'shoes'
    JOIN public.shared_preferences sp ON i.current_owner_id = sp.user_id
    WHERE
      i.is_active = true
      AND (sp.all_closet OR i.closet_id = sp.closet_id)  -- Closet filter

      -- ✅ Apply only_unworn filter
      AND (sp.only_unworn = FALSE OR i.worn_in_outfit = 0)

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
      AND (sp.only_unworn = FALSE OR i.worn_in_outfit = 0)
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

create or replace function get_outfit_usage_analytics()
returns table (
    total_reviews int,
    like_percentage numeric,
    alright_percentage numeric,
    dislike_percentage numeric,
    status text,
    days_tracked int,
    closet_shown text,
    user_feedback text
)
language plpgsql
SET search_path = ''
as $$
declare
    current_user_id uuid := auth.uid();
    first_reviewed_outfit_date timestamp;
    user_all_closet boolean;
    user_closet_id uuid;
    user_closet_name text;
    user_feedback text;
begin
    -- Get the first reviewed outfit's creation date
    select min(created_at)
    into first_reviewed_outfit_date
    from public.outfits
    where user_id = current_user_id
      and reviewed = TRUE;

    -- EARLY EXIT if no reviewed outfit exists
    if first_reviewed_outfit_date is null then
        return query
        select 0, 0.0, 0.0, 0.0, 'no reviewed outfit', 0, 'allClosetShown';
        return;
    end if;

    -- Update 'all' feedback to 'like' in public.shared_preferences
    update public.shared_preferences
    set feedback = 'like', updated_at = NOW()
    where user_id = current_user_id and feedback = 'all';

    -- Get the user's closet filtering preferences
    select all_closet, closet_id, feedback
    into user_all_closet, user_closet_id, user_feedback
    from public.shared_preferences
    where user_id = current_user_id;

    -- Get closet name if filtering
    if user_all_closet = FALSE then
        select closet_name into user_closet_name
        from public.user_closets
        where closet_id = user_closet_id;
    end if;

    -- 🚀 OPTIMIZATION: If all_closet = TRUE, skip filtering logic
    if user_all_closet = TRUE then
        return query
        (
            with reviewed_outfits as (
                select feedback
                from public.outfits
                where user_id = current_user_id
                  and reviewed = TRUE
                  and created_at >=
                    case
                        when first_reviewed_outfit_date <= NOW() - INTERVAL '60 days'
                        then NOW() - INTERVAL '60 days'
                        else first_reviewed_outfit_date
                    end
            )
            select
                count(*)::int as total_reviews,
                coalesce(100.0 * sum(case when feedback = 'like' then 1 else 0 end) / count(*), 0) as like_percentage,
                coalesce(100.0 * sum(case when feedback = 'alright' then 1 else 0 end) / count(*), 0) as alright_percentage,
                coalesce(100.0 * sum(case when feedback = 'dislike' then 1 else 0 end) / count(*), 0) as dislike_percentage,
                'data available' as status,
                case
                    when first_reviewed_outfit_date <= NOW() - INTERVAL '60 days'
                    then 60
                    else extract(day from NOW() - first_reviewed_outfit_date)::int
                end as days_tracked,
               'allClosetShown' as closet_shown  -- ✅ Showing "allClosetShown" when all closets are included
            from reviewed_outfits
        );

    else
        -- 1️⃣ Get valid outfit IDs based on closet filtering
        return query
        with filtered_outfits as (
            select o.outfit_id
            from public.outfits o
            join public.outfit_items oi on o.outfit_id = oi.outfit_id
            join public.items i on oi.item_id = i.item_id
            where o.user_id = current_user_id
              and o.reviewed = TRUE
              and i.is_active = TRUE
              and i.closet_id = user_closet_id
            group by o.outfit_id
        ),
        first_review_date as (
            select min(o.created_at) as first_date
            from public.outfits o
            join filtered_outfits f on o.outfit_id = f.outfit_id
        )
        select
            count(*)::int as total_reviews,
            coalesce(100.0 * sum(case when feedback = 'like' then 1 else 0 end) / count(*), 0) as like_percentage,
            coalesce(100.0 * sum(case when feedback = 'alright' then 1 else 0 end) / count(*), 0) as alright_percentage,
            coalesce(100.0 * sum(case when feedback = 'dislike' then 1 else 0 end) / count(*), 0) as dislike_percentage,
            'filtered data available' as status,
            case
                when (select first_date from first_review_date) <= NOW() - INTERVAL '60 days'
                then 60
                    else extract(day from NOW() - (select first_date from first_review_date))::int
            end as days_tracked,
            user_closet_name as closet_shown  -- ✅ Showing closet name if filtering by a specific closet
        from public.outfits o
        join filtered_outfits f on o.outfit_id = f.outfit_id
        where o.created_at >=
            case
                when (select first_date from first_review_date) <= NOW() - INTERVAL '60 days'
                then NOW() - INTERVAL '60 days'
                else (select first_date from first_review_date)
            end;
    end if;
end;
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
    items_per_page INT;
    offset_val INT;
    user_all_closet BOOLEAN;
    user_closet_id UUID;
    user_feedback text;
BEGIN
    -- Retrieve items per page from user preferences
    SELECT FLOOR(grid * 1.5 * grid)::INT
    INTO items_per_page
    FROM public.shared_preferences sp
    WHERE sp.user_id = current_user_id;

    offset_val := p_current_page * items_per_page;

    -- Get user's closet filtering preferences
    SELECT all_closet, closet_id,
           CASE WHEN feedback = 'all' THEN 'like' ELSE feedback END AS user_feedback
    INTO user_all_closet, user_closet_id, user_feedback
    FROM public.shared_preferences
    WHERE user_id = current_user_id;

    -- Fetch outfits with LATERAL JOIN for related items
    SELECT JSONB_BUILD_OBJECT(
        'status', 'success',
        'outfits', COALESCE(
            JSONB_AGG(
                JSONB_BUILD_OBJECT(
                    'outfit_id', filtered_outfits.outfit_id,
                    'outfit_image_url', filtered_outfits.outfit_image_url,
                    'outfit_is_active', filtered_outfits.is_active,
                    'items', fallback_items.related_items
                )
            ), '[]'::JSONB
        )
    ) INTO result
    FROM (
        -- Select outfits first, applying filters and pagination
        SELECT o.outfit_id, o.outfit_image_url, o.is_active
        FROM public.outfits o
        JOIN public.outfit_items oi ON oi.outfit_id = o.outfit_id
        JOIN public.items i ON oi.item_id = i.item_id
                    AND (user_all_closet OR i.closet_id = user_closet_id) -- Only filter closet when user_all_closet is FALSE
        WHERE o.user_id = current_user_id
          AND o.reviewed = TRUE
          AND o.feedback = user_feedback
        ORDER BY o.is_active DESC, o.updated_at DESC
        LIMIT items_per_page OFFSET offset_val
    ) filtered_outfits
    -- Efficiently fetch fallback items for outfits where `outfit_image_url = 'cc_none'`
    LEFT JOIN LATERAL (
        SELECT JSONB_AGG(
            JSONB_BUILD_OBJECT(
                'item_id', i.item_id,
                'image_url', i.image_url,
                'name', i.name,
                'item_is_active', i.is_active
            )
        ) AS related_items
        FROM (
            SELECT i.item_id, i.image_url, i.name, i.is_active
            FROM public.outfit_items oi
            JOIN public.items i ON oi.item_id = i.item_id
            WHERE oi.outfit_id = filtered_outfits.outfit_id
                  AND (user_all_closet OR i.closet_id = user_closet_id)
            ORDER BY i.is_active DESC, i.updated_at DESC
            LIMIT 1  -- ✅ Ensures only ONE item is fetched per outfit
        ) AS subquery
    ) AS fallback_items ON (filtered_outfits.outfit_image_url = 'cc_none');

    RETURN result;
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
                    -- If outfit_image_url is 'cc_none', fetch ONLY ONE active item
                    WHEN d.outfit_image_url = 'cc_none' THEN (
                        SELECT JSONB_AGG(
                            JSONB_BUILD_OBJECT(
                                'item_id', i.item_id,
                                'image_url', i.image_url,
                                'name', i.name
                            )
                        )
                        FROM (
                            SELECT i.item_id, i.image_url, i.name
                            FROM public.outfit_items oi
                            JOIN public.items i ON oi.item_id = i.item_id
                            WHERE oi.outfit_id = d.outfit_id
                            ORDER BY i.is_active DESC, i.updated_at DESC
                            LIMIT 1  -- ✅ Ensures only one item per outfit
                        ) AS subquery
                    )
                    ELSE '[]'::JSONB  -- ✅ Ensures `items` is always a list, even if empty
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
