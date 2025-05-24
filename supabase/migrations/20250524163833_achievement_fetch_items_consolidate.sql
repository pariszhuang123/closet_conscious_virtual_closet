CREATE OR REPLACE FUNCTION award_user_achievements()
RETURNS JSON
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
  current_user_id UUID := auth.uid();
  result JSON;
  counter_value INTEGER;
  clothes_worn BOOLEAN;
  closet_uploaded BOOLEAN;
  streak_value INTEGER;
  p_achievement_name TEXT;
  feature_name TEXT;
  feature_exists BOOLEAN;
  acquisition_method TEXT := 'milestone';
  items_gifted INTEGER;
  items_sold INTEGER;
  items_swapped INTEGER;
  items_uploaded INTEGER;
  items_edited INTEGER;
  outfits_created INTEGER;
  selfie_taken INTEGER;

BEGIN
  IF current_user_id IS NULL THEN
    RETURN json_build_object(
      'status', 'error',
      'message', 'User not authenticated.'
    );
  END IF;

  -- ================================
  -- First-Time Achievements Section
  -- ================================
SELECT
  COALESCE(ulfs.items_gifted, 0) AS items_gifted,
  COALESCE(ulfs.items_sold, 0) AS items_sold,
  COALESCE(ulfs.items_swapped, 0) AS items_swapped,
  COALESCE(uhfs.items_uploaded, 0) AS items_uploaded,
  COALESCE(uhfs.items_edited, 0) AS items_edited,
  COALESCE(uhfs.outfits_created, 0) AS outfits_created,
  COALESCE(uhfs.selfie_taken, 0) AS selfie_taken
INTO STRICT
  items_gifted, items_sold, items_swapped,
  items_uploaded, items_edited, outfits_created, selfie_taken
FROM public.user_low_freq_stats ulfs
JOIN public.user_high_freq_stats uhfs ON uhfs.user_id = ulfs.user_id
WHERE ulfs.user_id = current_user_id;

-- CASE block to identify the first unlocked achievement
p_achievement_name := CASE
  WHEN items_gifted = 1 AND NOT EXISTS (
    SELECT 1 FROM public.user_achievements WHERE user_id = current_user_id AND achievement_name = '1st_item_gifted'
  ) THEN '1st_item_gifted'
  WHEN items_edited = 1 AND NOT EXISTS (
    SELECT 1 FROM public.user_achievements WHERE user_id = current_user_id AND achievement_name = '1st_item_pic_edited'
  ) THEN '1st_item_pic_edited'
  WHEN items_sold = 1 AND NOT EXISTS (
    SELECT 1 FROM public.user_achievements WHERE user_id = current_user_id AND achievement_name = '1st_item_sold'
  ) THEN '1st_item_sold'
  WHEN items_swapped = 1 AND NOT EXISTS (
    SELECT 1 FROM public.user_achievements WHERE user_id = current_user_id AND achievement_name = '1st_item_swap'
  ) THEN '1st_item_swap'
  WHEN items_uploaded = 1 AND NOT EXISTS (
    SELECT 1 FROM public.user_achievements WHERE user_id = current_user_id AND achievement_name = '1st_item_uploaded'
  ) THEN '1st_item_uploaded'
  WHEN outfits_created = 1 AND NOT EXISTS (
    SELECT 1 FROM public.user_achievements WHERE user_id = current_user_id AND achievement_name = '1st_outfit_created'
  ) THEN '1st_outfit_created'
  WHEN selfie_taken = 1 AND NOT EXISTS (
    SELECT 1 FROM public.user_achievements WHERE user_id = current_user_id AND achievement_name = '1st_selfie_taken'
  ) THEN '1st_selfie_taken'
  ELSE NULL
END;

-- Award if one was matched
IF p_achievement_name IS NOT NULL THEN
  INSERT INTO public.user_achievements (user_id, achievement_name)
  VALUES (current_user_id, p_achievement_name);

  SELECT json_build_object(
    'status', 'success',
    'achievement_name', a.achievement_name,
    'badge_url', a.badge_url,
    'feature', 'cc_none'
  ) INTO result
  FROM public.achievements a
  WHERE a.achievement_name = p_achievement_name;

  RETURN result;
END IF;
  -- ================================
  -- Closet Uploaded Achievement
  -- ================================
  IF NOT EXISTS (
    SELECT 1 FROM public.user_achievements
    WHERE user_id = current_user_id AND achievement_name = 'closet_uploaded'
  ) THEN
    INSERT INTO public.user_achievements (user_id, achievement_name)
    VALUES (current_user_id, 'closet_uploaded');

    SELECT json_build_object(
      'status', 'success',
      'achievement_name', a.achievement_name,
      'badge_url', a.badge_url,
      'feature', 'cc_none'
    ) INTO result
    FROM public.achievements a
    WHERE a.achievement_name = 'closet_uploaded';

    RETURN result;
  END IF;

  -- ================================
  -- All Clothes Worn Achievement
  -- ================================
  SELECT uhfs.initial_upload_items_worn_percentage = 100
  INTO clothes_worn
  FROM public.user_high_freq_stats uhfs
  WHERE uhfs.user_id = current_user_id;

  IF clothes_worn AND NOT EXISTS (
    SELECT 1 FROM public.user_achievements
    WHERE user_id = current_user_id AND achievement_name = 'all_clothes_worn'
  ) THEN
    INSERT INTO public.user_achievements (user_id, achievement_name, awarded_at)
    VALUES (current_user_id, 'all_clothes_worn', NOW());

    feature_name := 'com.makinglifeeasie.closetconscious.arrange';

    SELECT json_build_object(
      'status', 'success',
      'achievement_name', a.achievement_name,
      'badge_url', a.badge_url
    ) INTO result
    FROM public.achievements a
    WHERE a.achievement_name = 'all_clothes_worn';

    SELECT one_off_features ? feature_name INTO feature_exists
    FROM public.premium_services
    WHERE user_id = current_user_id;

    IF NOT feature_exists THEN
      UPDATE public.premium_services
      SET one_off_features = jsonb_set(
        COALESCE(one_off_features, '{}'::jsonb),
        ARRAY[feature_name],
        jsonb_build_object(
          'acquisition_method', acquisition_method,
          'acquisition_date', CURRENT_TIMESTAMP
        )
      ),
      updated_at = NOW()
      WHERE user_id = current_user_id;

      RETURN result || json_build_object('feature', 'activated');
    ELSE
      RETURN result || json_build_object('feature', 'already_exists');
    END IF;
  END IF;

  -- ================================
  -- No Buy Streak Milestones
  -- ================================
  SELECT COALESCE(no_buy_highest_streak, 0) INTO streak_value
  FROM public.user_high_freq_stats
  WHERE user_id = current_user_id;

  p_achievement_name := CASE
    WHEN streak_value = 90 THEN 'no_new_clothes_90'
    WHEN streak_value = 225 THEN 'no_new_clothes_225'
    WHEN streak_value = 405 THEN 'no_new_clothes_405'
    WHEN streak_value = 630 THEN 'no_new_clothes_630'
    WHEN streak_value = 900 THEN 'no_new_clothes_900'
    WHEN streak_value = 1215 THEN 'no_new_clothes_1215'
    WHEN streak_value = 1575 THEN 'no_new_clothes_1575'
    WHEN streak_value = 1980 THEN 'no_new_clothes_1980'
    ELSE NULL
  END;

  IF p_achievement_name IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM public.user_achievements
    WHERE user_id = current_user_id AND achievement_name = p_achievement_name
  ) THEN
    INSERT INTO public.user_achievements (user_id, achievement_name, awarded_at)
    VALUES (current_user_id, p_achievement_name, NOW());

    -- Map feature
    feature_name := CASE
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

    SELECT json_build_object(
      'status', 'success',
      'achievement_name', a.achievement_name,
      'badge_url', a.badge_url
    ) INTO result
    FROM public.achievements a
    WHERE a.achievement_name = p_achievement_name;

    IF feature_name IS NULL THEN
      RETURN result || json_build_object('feature', 'none');
    END IF;

    SELECT one_off_features ? feature_name INTO feature_exists
    FROM public.premium_services
    WHERE user_id = current_user_id;

    IF NOT feature_exists THEN
      UPDATE public.premium_services
      SET one_off_features = jsonb_set(
        COALESCE(one_off_features, '{}'::jsonb),
        ARRAY[feature_name],
        jsonb_build_object(
          'acquisition_method', acquisition_method,
          'acquisition_date', CURRENT_TIMESTAMP
        )
      ),
      updated_at = NOW()
      WHERE user_id = current_user_id;

      RETURN result || json_build_object('feature', 'activated');
    ELSE
      RETURN result || json_build_object('feature', 'already_exists');
    END IF;
  END IF;

  -- ================================
  -- No New Achievements
  -- ================================
  RETURN json_build_object(
    'status', 'no_action',
    'message', 'No new achievement unlocked.'
  );

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object(
    'status', 'error',
    'message', SQLERRM
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.consolidate_fetch_items_with_preferences(
  p_current_page INTEGER,
  p_category      TEXT DEFAULT NULL    -- pass NULL to return all item types
)
RETURNS TABLE (
  item_id        UUID,
  image_url      TEXT,
  name           TEXT,
  item_type      TEXT,
  price_per_wear NUMERIC,
  worn_in_outfit NUMERIC,
  item_last_worn DATE,
) AS $$
DECLARE
  items_per_page INT;
  offset_val     INT;
  sort_column    TEXT;
  sort_direction TEXT;
  current_user   UUID := auth.uid();
BEGIN
  -- Pull the user’s page‐size & sort preferences
  SELECT
    FLOOR(sp.grid * 1.5 * sp.grid)::INT,
    sp.sort,
    sp.sort_order
  INTO
    items_per_page,
    sort_column,
    sort_direction
  FROM public.shared_preferences sp
  WHERE sp.user_id = current_user;

  offset_val := p_current_page * items_per_page;

  -- Build & run the dynamic query
  RETURN QUERY EXECUTE FORMAT($sql$
    SELECT
      i.item_id,
      i.image_url,
      i.name,
      i.item_type,
      i.price_per_wear,
      i.worn_in_outfit,
      i.item_last_worn
    FROM public.items i
    LEFT JOIN public.items_accessory_basic a ON i.item_id = a.item_id     AND i.item_type = 'accessory'
    LEFT JOIN public.items_clothing_basic  c ON i.item_id = c.item_id     AND i.item_type = 'clothing'
    LEFT JOIN public.items_shoes_basic     s ON i.item_id = s.item_id     AND i.item_type = 'shoes'
    JOIN public.shared_preferences sp ON i.current_owner_id = sp.user_id
    WHERE
      i.is_active   = TRUE
      AND i.is_pending = FALSE

      -- optional category filter
      AND (%L IS NULL OR i.item_type = %L)

      -- closet scope
      AND (sp.all_closet OR i.closet_id = sp.closet_id)

      -- only-unworn
      AND (sp.only_unworn = FALSE OR i.worn_in_outfit = 0)

      -- name filter
      AND (
        sp.ignore_item_name
        OR (sp.item_name IS NOT NULL AND i.name ILIKE '%%' || sp.item_name || '%%')
      )

      -- arbitrary JSON-based filters
      AND (
        sp.filter = '{}'::jsonb OR sp.filter IS NULL OR (
          (sp.filter->'item_type'      IS NULL OR EXISTS (SELECT 1 FROM jsonb_array_elements_text(sp.filter->'item_type')      e WHERE e = i.item_type))
          AND (sp.filter->'occasion'       IS NULL OR EXISTS (SELECT 1 FROM jsonb_array_elements_text(sp.filter->'occasion')       e WHERE e = i.occasion))
          AND (sp.filter->'season'         IS NULL OR EXISTS (SELECT 1 FROM jsonb_array_elements_text(sp.filter->'season')         e WHERE e = i.season))
          AND (sp.filter->'colour'         IS NULL OR EXISTS (SELECT 1 FROM jsonb_array_elements_text(sp.filter->'colour')         e WHERE e = i.colour))
          AND (sp.filter->'colour_variations' IS NULL OR EXISTS (SELECT 1 FROM jsonb_array_elements_text(sp.filter->'colour_variations') e WHERE e = i.colour_variations))
          AND (sp.filter->'accessory_type' IS NULL OR (i.item_type = 'accessory' AND EXISTS (SELECT 1 FROM jsonb_array_elements_text(sp.filter->'accessory_type') e WHERE e = a.accessory_type)))
          AND (sp.filter->'clothing_type'  IS NULL OR (i.item_type = 'clothing'  AND EXISTS (SELECT 1 FROM jsonb_array_elements_text(sp.filter->'clothing_type')  e WHERE e = c.clothing_type)))
          AND (sp.filter->'clothing_layer' IS NULL OR (i.item_type = 'clothing'  AND EXISTS (SELECT 1 FROM jsonb_array_elements_text(sp.filter->'clothing_layer') e WHERE e = c.clothing_layer)))
          AND (sp.filter->'shoes_type'     IS NULL OR (i.item_type = 'shoes'     AND EXISTS (SELECT 1 FROM jsonb_array_elements_text(sp.filter->'shoes_type')     e WHERE e = s.shoes_type)))
        )
      )

    ORDER BY
      i.%I %s,
      i.item_id  -- stable tiebreaker

    OFFSET %L
    LIMIT  %L
  $sql$,
    -- format() arguments in order:
    p_category,     -- first %L (nullable category)
    p_category,     -- second %L (exact match)
    sort_column,    -- %I (sort column)
    sort_direction, -- %s (ASC/DESC)
    offset_val,     -- %L (OFFSET)
    items_per_page  -- %L (LIMIT)
  );

END;
$$ LANGUAGE plpgsql;
