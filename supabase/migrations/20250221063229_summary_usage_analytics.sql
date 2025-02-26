DROP FUNCTION IF EXISTS get_outfit_usage_analytics();

CREATE OR REPLACE FUNCTION public.activate_trial_premium_features()
RETURNS BOOLEAN
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id UUID := auth.uid();
    v_target_features TEXT[] := ARRAY[
        'com.makinglifeeasie.closetconscious.filter',
        'com.makinglifeeasie.closetconscious.arrange',
        'com.makinglifeeasie.closetconscious.multicloset',
        'com.makinglifeeasie.closetconscious.multipleoutfits',
        'com.makinglifeeasie.closetconscious.calendar',
        'com.makinglifeeasie.closetconscious.usageanalytics'
    ];
    v_existing_features TEXT[];
    v_new_trial_features JSONB;
BEGIN
    -- Check if the user is authenticated
    IF current_user_id IS NULL THEN
        RAISE EXCEPTION 'User not authenticated';
    END IF;

    -- Quick pass: Ensure user is eligible for trial activation
    IF NOT EXISTS (
        SELECT 1
        FROM public.premium_services
        WHERE user_id = current_user_id
          AND trial_status = 'pending' -- Only allow activation if trial is 'pending'
    ) THEN
        RETURN FALSE; -- User does not meet the criteria for update
    END IF;

    -- Get existing feature keys in one_off_features JSONB
    SELECT array_agg(key)
    INTO v_existing_features
    FROM public.premium_services,
         LATERAL jsonb_each_text(one_off_features)
    WHERE user_id = current_user_id;

    -- Build JSONB object for only missing features
    v_new_trial_features := (
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
        WHERE u.feature_key NOT IN (SELECT UNNEST(v_existing_features))
    );

    -- If no new features to add, return false
    IF v_new_trial_features IS NULL THEN
        RETURN FALSE;
    END IF;

    -- Update the premium_services table with only missing features and set trial_status to 'active'
    UPDATE public.premium_services
    SET one_off_features = one_off_features || v_new_trial_features,
        trial_status = 'active' -- Set trial as active
    WHERE user_id = current_user_id
      AND trial_status = 'pending';

    RETURN TRUE;
END;
$$;


create or replace function get_filtered_item_summary()
returns table (
    total_items int,
    total_item_cost numeric,
    avg_price_per_wear numeric
)
language plpgsql
set search_path = ''
as $$
declare
    current_user_id uuid := auth.uid();  -- Standardized for all RPCs
begin
    return query
    with filtered_items as (
        select
            i.item_id,
            i.amount_spent,
            i.worn_in_outfit
        from
            public.items i
        LEFT JOIN public.items_accessory_basic a ON i.item_id = a.item_id AND i.item_type = 'accessory'
        LEFT JOIN public.items_clothing_basic c ON i.item_id = c.item_id AND i.item_type = 'clothing'
        LEFT JOIN public.items_shoes_basic s ON i.item_id = s.item_id AND i.item_type = 'shoes'
        JOIN public.shared_preferences sp ON i.current_owner_id = sp.user_id
        WHERE
            i.is_active = true
            AND i.current_owner_id = current_user_id  -- Use standardized user ID
            and (sp.all_closet OR i.closet_id = sp.closet_id)  -- Closet filter
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
                        ))
                    )
                    AND (sp.filter->'clothing_type' IS NULL OR (i.item_type = 'clothing' AND EXISTS (
                        SELECT 1 FROM jsonb_array_elements_text(sp.filter->'clothing_type') elem WHERE elem = c.clothing_type
                        ))
                    )
                    AND (sp.filter->'clothing_layer' IS NULL OR (i.item_type = 'clothing' AND EXISTS (
                        SELECT 1 FROM jsonb_array_elements_text(sp.filter->'clothing_layer') elem WHERE elem = c.clothing_layer
                        ))
                    )
                    AND (sp.filter->'shoes_type' IS NULL OR (i.item_type = 'shoes' AND EXISTS (
                        SELECT 1 FROM jsonb_array_elements_text(sp.filter->'shoes_type') elem WHERE elem = s.shoes_type
                    ))
                )
            )
        )
    )
    select
        coalesce(count(item_id)::int, 0) as total_items,
        coalesce(sum(amount_spent), 0) as total_item_cost,
        coalesce(
            case
                when sum(worn_in_outfit) > 0
                then sum(amount_spent) / sum(worn_in_outfit)
                else 0
            end, 0
        ) as avg_price_per_wear
    from filtered_items;
end;
$$;


CREATE OR REPLACE FUNCTION fetch_item_with_preferences(p_current_page INT)
RETURNS TABLE(
  item_id UUID,
  image_url TEXT,
  name TEXT,
  item_type TEXT,
  sort_value TEXT  -- Additional column for the dynamic sort value
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
  sort_value_expr TEXT;
BEGIN
  -- Retrieve items per page, sort column, and sort order from user preferences.
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

  -- ✅ If sort_column is NULL or does not exist in public.items, set default to price_per_wear
  IF sort_column IS NULL OR NOT EXISTS (
      SELECT 1 FROM information_schema.columns
      WHERE table_schema = 'public' AND table_name = 'items' AND column_name = sort_column
  ) THEN
      sort_column := 'price_per_wear';
  END IF;

  -- Build the expression for displaying the sort value.
  -- For timestamp columns, format to show only the date.
  IF sort_column IN ('updated_at', 'created_at') THEN
    sort_value_expr := format('to_char(i.%I, ''YYYY-MM-DD'')', sort_column);
  ELSE
    sort_value_expr := format('i.%I::text', sort_column);
  END IF;

  -- Execute dynamic SQL with the dynamic sort_value_expr.
  RETURN QUERY EXECUTE FORMAT(
    $sql$
    SELECT
      i.item_id,
      i.image_url,
      i.name,
      i.item_type,
      %s AS sort_value
    FROM
      public.items i
    LEFT JOIN public.items_accessory_basic a ON i.item_id = a.item_id AND i.item_type = 'accessory'
    LEFT JOIN public.items_clothing_basic c ON i.item_id = c.item_id AND i.item_type = 'clothing'
    LEFT JOIN public.items_shoes_basic s ON i.item_id = s.item_id AND i.item_type = 'shoes'
    JOIN public.shared_preferences sp ON i.current_owner_id = sp.user_id
    WHERE
      i.is_active = true
      AND (sp.all_closet OR i.closet_id = sp.closet_id)
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
      ORDER BY i.%I %s, i.item_id
      LIMIT %L OFFSET %L
    $sql$,
    sort_value_expr,    -- Injects our dynamically built expression for sort_value
    sort_column,        -- For the ORDER BY clause: the dynamic column name
    sort_direction,     -- Sort order (ASC or DESC)
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
                    else extract(day from NOW() - first_reviewed_outfit_date)
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
                else extract(day from NOW() - (select first_date from first_review_date))
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
                    'related_items', fallback_items.related_items
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
        FROM public.outfit_items oi
        JOIN public.items i ON oi.item_id = i.item_id
        WHERE oi.outfit_id = filtered_outfits.outfit_id
             AND (user_all_closet OR i.closet_id = user_closet_id)

    ) AS fallback_items ON (filtered_outfits.outfit_image_url = 'cc_none');

    RETURN result;
END;
$$;

