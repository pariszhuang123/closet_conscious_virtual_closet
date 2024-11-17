create or replace function fetch_items_with_preferences(p_current_page int)
returns table(
  item_id uuid,
  image_url text,
  name text,
  item_type text
)
SET search_path = ''
language plpgsql
as $$
declare
  items_per_page int;
  offset_val int;
  sort_column text;
  sort_direction text;
  current_user_id uuid := auth.uid();

begin

  -- Calculate items per page and offset based on user preferences
  select
    floor(grid * 1.5 * grid)::int,  -- Use floor to avoid rounding up
    sort,
    sort_order
  into
    items_per_page,
    sort_column,
    sort_direction
  from
    public.shared_preferences sp
  where
    sp.user_id = current_user_id;

  -- Standard offset calculation without any additional adjustments
  offset_val := p_current_page * items_per_page;

  -- Execute dynamic SQL for sorting and pagination
  return query execute format(
    $sql$
    select
      i.item_id,
      i.image_url,
      i.name,
      i.item_type
    from
      public.items i
    LEFT JOIN public.items_accessory_basic a ON i.item_id = a.item_id AND i.item_type = 'accessory'
    LEFT JOIN public.items_clothing_basic c ON i.item_id = c.item_id AND i.item_type = 'clothing'
    LEFT JOIN public.items_shoes_basic s ON i.item_id = s.item_id AND i.item_type = 'shoes'
    JOIN public.shared_preferences sp ON i.current_owner_id = sp.user_id
    WHERE
      i.is_active = true
      AND (sp.all_closet OR i.closet_id = sp.closet_id)  -- Closet filter
      and (sp.ignore_item_name OR i.name ILIKE '%%' || sp.item_name || '%%')
      AND (
        sp.filter = '{}'::jsonb OR sp.filter IS NULL
        OR (
          (sp.filter->'item_type' IS NULL OR i.item_type = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'item_type'))))
          AND (sp.filter->'occasion' IS NULL OR i.occasion = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'occasion'))))
          AND (sp.filter->'season' IS NULL OR i.season = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'season'))))
          AND (sp.filter->'colour' IS NULL OR i.colour = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'colour'))))
          AND (sp.filter->'colour_variations' IS NULL OR i.colour_variations = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'colour_variations'))))
          AND (sp.filter->'accessory_type' IS NULL OR (i.item_type = 'accessory' AND a.accessory_type = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'accessory_type')))))
          AND (sp.filter->'clothing_type' IS NULL OR (i.item_type = 'clothing' AND c.clothing_type = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'clothing_type')))))
          AND (sp.filter->'clothing_layer' IS NULL OR (i.item_type = 'clothing' AND c.clothing_layer = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'clothing_layer')))))
          AND (sp.filter->'shoes_type' IS NULL OR (i.item_type = 'shoes' AND s.shoes_type = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'shoes_type')))))
        )
      )
      order by i.%I %s, i.item_id -- Stable sorting with item_id as secondary criterion
      offset %L limit %L
    $sql$,
    sort_column,      -- Injects the validated column name
    sort_direction,   -- Injects the sort direction (ASC or DESC)
    offset_val,
    items_per_page
  );

end;
$$;

create or replace function fetch_outfit_items_with_preferences(
  p_current_page int,
  p_category text
)
returns table(
  item_id uuid,
  image_url text,
  name text,
  item_type text
)
SET search_path = ''
language plpgsql
as $$
declare
  items_per_page int;
  offset_val int;
  sort_column text;
  sort_direction text;
  current_user_id uuid := auth.uid();

begin

  -- Calculate items per page and offset based on user preferences
  select
    floor(grid * 1.5 * grid)::int,  -- Use floor to avoid rounding up
    sort,
    sort_order
  into
    items_per_page,
    sort_column,
    sort_direction
  from
    public.shared_preferences sp
  where
    sp.user_id = current_user_id;

  -- Standard offset calculation
  offset_val := p_current_page * items_per_page;

  -- Execute dynamic SQL for sorting, pagination, and mandatory category filtering
  return query execute format(
    $sql$
    select
      i.item_id,
      i.image_url,
      i.name,
      i.item_type
    from
      public.items i
    LEFT JOIN public.items_accessory_basic a ON i.item_id = a.item_id AND i.item_type = 'accessory'
    LEFT JOIN public.items_clothing_basic c ON i.item_id = c.item_id AND i.item_type = 'clothing'
    LEFT JOIN public.items_shoes_basic s ON i.item_id = s.item_id AND i.item_type = 'shoes'
    JOIN public.shared_preferences sp ON i.current_owner_id = sp.user_id
    WHERE
      i.is_active = true
      AND i.item_type = %L  -- Mandatory category filter
      and (sp.all_closet OR i.closet_id = sp.closet_id)  -- Closet filter
      and (sp.ignore_item_name OR i.name ILIKE '%%' || sp.item_name || '%%')
      AND (
        sp.filter = '{}'::jsonb OR sp.filter IS NULL
        OR (
          (sp.filter->'item_type' IS NULL OR i.item_type = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'item_type'))))
          AND (sp.filter->'occasion' IS NULL OR i.occasion = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'occasion'))))
          AND (sp.filter->'season' IS NULL OR i.season = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'season'))))
          AND (sp.filter->'colour' IS NULL OR i.colour = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'colour'))))
          AND (sp.filter->'colour_variations' IS NULL OR i.colour_variations = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'colour_variations'))))
          AND (sp.filter->'accessory_type' IS NULL OR (i.item_type = 'accessory' AND a.accessory_type = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'accessory_type')))))
          AND (sp.filter->'clothing_type' IS NULL OR (i.item_type = 'clothing' AND c.clothing_type = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'clothing_type')))))
          AND (sp.filter->'clothing_layer' IS NULL OR (i.item_type = 'clothing' AND c.clothing_layer = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'clothing_layer')))))
          AND (sp.filter->'shoes_type' IS NULL OR (i.item_type = 'shoes' AND s.shoes_type = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'shoes_type')))))
        )
      )
      order by i.%I %s, i.item_id -- Stable sorting with item_id as secondary criterion
      offset %L limit %L
    $sql$,
    p_category,  -- Inject category as a mandatory filter
    sort_column,      -- Injects the validated column name
    sort_direction,   -- Injects the sort direction (ASC or DESC)
    offset_val,
    items_per_page
  );

end;
$$;


-- Function for increment_items_gifted
create or replace function public.increment_items_gifted(current_item_id uuid)
returns json
SET search_path = ''
language plpgsql
as $$
declare
  current_user_id uuid := auth.uid();
  result json;
begin
    -- Update item status
    update public.items
    set
        sub_status = 'gift',
        is_active = false,
        updated_at = now()
    where
        current_owner_id = current_user_id and
        item_id = current_item_id;

    -- Update user high frequency stats if item was uploaded but never worn in an outfit
    update public.user_high_freq_stats
    set
        initial_upload_item_count = initial_upload_item_count - 1,
        updated_at = NOW()
    where
        user_id = current_user_id and
        exists (
            select 1
            from public.items
            where closet_upload = true and worn_in_outfit = 0 and current_owner_id = current_user_id and item_id = current_item_id
        );

    -- Update user high frequency stats if item was uploaded and worn in an outfit
    update public.user_high_freq_stats
    set
        initial_upload_item_count = initial_upload_item_count - 1,
        initial_upload_items_worn_count = initial_upload_items_worn_count - 1,
        updated_at = NOW()
    where
        user_id = current_user_id and
        exists (
            select 1
            from public.items
            where closet_upload = true and worn_in_outfit > 0 and current_owner_id = current_user_id and item_id = current_item_id
        );

    -- Update user low frequency stats
    update public.user_low_freq_stats
    set
        items_gifted = items_gifted + 1,
        updated_at = now()
    where
        user_id = current_user_id;

    return json_build_object('status', 'success');
end;
$$;

-- Function for increment_items_sold
create or replace function public.increment_items_sold(current_item_id uuid)
returns json
SET search_path = ''
language plpgsql
as $$
declare
  current_user_id uuid := auth.uid();
  result json;
begin
    -- Update item status
    update public.items
    set
        sub_status = 'sold',
        is_active = false,
        updated_at = now()
    where
        current_owner_id = current_user_id and
        item_id = current_item_id;

    -- Update user high frequency stats if item was uploaded but never worn in an outfit
    update public.user_high_freq_stats
    set
        initial_upload_item_count = initial_upload_item_count - 1
    where
        user_id = current_user_id and
        exists (
            select 1
            from public.items
            where closet_upload = true and worn_in_outfit = 0 and current_owner_id = current_user_id and item_id = current_item_id
        );

    -- Update user high frequency stats if item was uploaded and worn in an outfit
    update public.user_high_freq_stats
    set
        initial_upload_item_count = initial_upload_item_count - 1,
        initial_upload_items_worn_count = initial_upload_items_worn_count - 1,
        updated_at = NOW()
    where
        user_id = current_user_id and
        exists (
            select 1
            from public.items
            where closet_upload = true and worn_in_outfit > 0 and current_owner_id = current_user_id and item_id = current_item_id
        );

    -- Update user low frequency stats
    update public.user_low_freq_stats
    set
        items_sold = items_sold + 1,
        updated_at = now()
    where
        user_id = current_user_id;

    return json_build_object('status', 'success');
end;
$$;

-- Function for items_swapped
create or replace function public.increment_items_swapped(current_item_id uuid)
returns json
SET search_path = ''
language plpgsql
as $$
declare
  current_user_id uuid := auth.uid();
  result json;
begin
    -- Update item status
    update public.items
    set
        sub_status = 'swap',
        is_active = false,
        updated_at = now()
    where
        current_owner_id = current_user_id and
        item_id = current_item_id;

    -- Update user high frequency stats if item was uploaded but never worn in an outfit
    update public.user_high_freq_stats
    set
        initial_upload_item_count = initial_upload_item_count - 1,
        updated_at = NOW()
    where
        user_id = current_user_id and
        exists (
            select 1
            from public.items
            where closet_upload = true and worn_in_outfit = 0 and current_owner_id = current_user_id and item_id = current_item_id
        );

    -- Update user high frequency stats if item was uploaded and worn in an outfit
    update public.user_high_freq_stats
    set
        initial_upload_item_count = initial_upload_item_count - 1,
        initial_upload_items_worn_count = initial_upload_items_worn_count - 1,
        updated_at = NOW()
    where
        user_id = current_user_id and
        exists (
            select 1
            from public.items
            where closet_upload = true and worn_in_outfit > 0 and current_owner_id = current_user_id and item_id = current_item_id
        );

    -- Update user low frequency stats
    update public.user_low_freq_stats
    set
        items_swapped = items_swapped + 1,
        updated_at = now()
    where
        user_id = current_user_id;

    return json_build_object('status', 'success');
end;
$$;

-- Function for increment_items_thrown
create or replace function public.increment_items_thrown(current_item_id uuid)
returns json
SET search_path = ''
language plpgsql
as $$
declare
  current_user_id uuid := auth.uid();
  result json;
begin
    -- Update item status
    update public.items
    set
        sub_status = 'throw_away',
        is_active = false,
        updated_at = now()
    where
        current_owner_id = current_user_id and
        item_id = current_item_id;

    -- Update user high frequency stats if item was uploaded but never worn in an outfit
    update public.user_high_freq_stats
    set
        initial_upload_item_count = initial_upload_item_count - 1,
        updated_at = NOW()
    where
        user_id = current_user_id and
        exists (
            select 1
            from public.items
            where closet_upload = true and worn_in_outfit = 0 and current_owner_id = current_user_id and item_id = current_item_id
        );

    -- Update user high frequency stats if item was uploaded and worn in an outfit
    update public.user_high_freq_stats
    set
        initial_upload_item_count = initial_upload_item_count - 1,
        initial_upload_items_worn_count = initial_upload_items_worn_count - 1,
        updated_at = NOW()
    where
        user_id = current_user_id and
        exists (
            select 1
            from public.items
            where closet_upload = true and worn_in_outfit > 0 and current_owner_id = current_user_id and item_id = current_item_id
        );

    return json_build_object('status', 'success');
end;
$$;

CREATE OR REPLACE FUNCTION fetch_milestone_achievements()
RETURNS json
SET search_path = ''
AS $$
DECLARE
    current_streak int;
    current_user_id uuid := auth.uid();
    p_achievement_name text;
    reward_result json;
    result json;
    feature_exists boolean;
    feature_name text;
    acquisition_method text := 'milestone';  -- Default acquisition method

BEGIN
    -- Fetch the user's current streak, default to 0 if null
    SELECT coalesce(no_buy_highest_streak, 0) INTO current_streak
    FROM public.user_high_freq_stats
    WHERE user_id = current_user_id;

    -- Determine the milestone achievement based on the current streak
    p_achievement_name := CASE
        WHEN current_streak = 1980 THEN 'no_new_clothes_1980'
        WHEN current_streak = 1575 THEN 'no_new_clothes_1575'
        WHEN current_streak = 1215 THEN 'no_new_clothes_1215'
        WHEN current_streak = 900 THEN 'no_new_clothes_900'
        WHEN current_streak = 630 THEN 'no_new_clothes_630'
        WHEN current_streak = 405 THEN 'no_new_clothes_405'
        WHEN current_streak = 225 THEN 'no_new_clothes_225'
        WHEN current_streak = 90 THEN 'no_new_clothes_90'
        ELSE NULL
    END;

    -- If no milestone is reached, return no milestone status
    IF p_achievement_name IS NULL THEN
        RETURN json_build_object(
            'status', 'no_milestone',
            'message', 'No milestone reached for the current streak'
        );
    END IF;

    -- Check if the achievement is already awarded
    IF NOT EXISTS (
        SELECT 1 FROM public.user_achievements
        WHERE user_id = current_user_id
        AND achievement_name = p_achievement_name
    ) THEN
        -- Insert the new achievement into user_achievements table
        INSERT INTO public.user_achievements (user_id, achievement_name, awarded_at)
        VALUES (current_user_id, p_achievement_name, now());

        -- Step 1: Map achievement to feature
        feature_name := CASE
            WHEN p_achievement_name = 'all_clothes_worn' THEN 'com.makinglifeeasie.closetconscious.arrange'
            WHEN p_achievement_name = 'no_new_clothes_90' THEN 'com.makinglifeeasie.closetconscious.multipleoutfits'
            WHEN p_achievement_name = 'no_new_clothes_225' THEN 'com.makinglifeeasie.closetconscious.filter'
            WHEN p_achievement_name = 'no_new_clothes_405' THEN 'com.makinglifeeasie.closetconscious.multicloset'
            WHEN p_achievement_name = 'no_new_clothes_630' THEN 'com.makinglifeeasie.closetconscious.adddetails'
            WHEN p_achievement_name = 'no_new_clothes_900' THEN 'com.makinglifeeasie.closetconscious.calendar'
            WHEN p_achievement_name = 'no_new_clothes_1215' THEN 'com.makinglifeeasie.closetconscious.swap'
            WHEN p_achievement_name = 'no_new_clothes_1575' THEN 'com.makinglifeeasie.closetconscious.usageanalytics'
            WHEN p_achievement_name = 'no_new_clothes_1980' THEN 'com.makinglifeeasie.closetconscious.publiccloset'
            ELSE NULL
        END;

        -- Step 2: Fetch badge URL for the achievement
        SELECT json_build_object(
            'status', 'success',
            'badge_url', badge_url,
            'achievement_name', achievement_name)
        INTO result
        FROM public.achievements
        WHERE achievement_name = p_achievement_name;

        -- If no badge found, return error
        IF result IS NULL THEN
            RETURN json_build_object(
                'status', 'failure',
                'message', 'Achievement not found or badge not available'
            );
        END IF;

        -- Step 3: Check if the feature already exists for the user
        IF feature_name IS NOT NULL THEN
            SELECT one_off_features ? feature_name INTO feature_exists
            FROM public.premium_services
            WHERE user_id = current_user_id;

            -- Step 4: If feature doesn't exist, update it in the premium_services table
            IF NOT feature_exists THEN
                UPDATE public.premium_services
                SET
                    one_off_features = jsonb_set(
                        one_off_features,
                        ARRAY[feature_name],
                        jsonb_build_object('acquisition_method', acquisition_method, 'acquisition_date', CURRENT_TIMESTAMP)
                    ),
                    updated_at = NOW()
                WHERE user_id = current_user_id;

                -- Return success response with inserted achievement and activated feature
                RETURN json_build_object(
                    'status', 'success',
                    'achievement_name', result->>'achievement_name',
                    'badge_url', result->>'badge_url',
                    'feature', 'activated'
                );
            ELSE
                -- Feature already exists
                RETURN json_build_object(
                    'status', 'success',
                    'achievement_name', result->>'achievement_name',
                    'badge_url', result->>'badge_url',
                    'feature', 'already_exists'
                );
            END IF;
        ELSE
            -- If feature mapping is missing
            RETURN json_build_object(
                'status', 'failure',
                'message', 'No feature mapped to this achievement'
            );
        END IF;
    ELSE
        -- If milestone already achieved
        RETURN json_build_object(
            'status', 'no_achievement',
            'message', 'Milestone already achieved'
        );
    END IF;

EXCEPTION WHEN OTHERS THEN
    -- Handle any errors that occur
    RETURN json_build_object(
        'status', 'error',
        'message', SQLERRM
    );
END;
$$ LANGUAGE plpgsql;

ALTER TABLE public.user_closets
ADD COLUMN is_public BOOLEAN DEFAULT FALSE NOT NULL;

COMMENT ON COLUMN public.user_closets.is_public
IS 'Indicates whether a user closet is public (TRUE) or private (FALSE). Items in the public closets can be seen by anybody in the app, while items in the private closets can only be seen by owner. It is defaulted to false.';


ALTER TABLE public.user_closets
DROP COLUMN status;
