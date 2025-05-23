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
    SELECT 1 FROM user_achievements WHERE user_id = current_user_id AND achievement_name = '1st_item_gifted'
  ) THEN '1st_item_gifted'
  WHEN items_edited = 1 AND NOT EXISTS (
    SELECT 1 FROM user_achievements WHERE user_id = current_user_id AND achievement_name = '1st_item_pic_edited'
  ) THEN '1st_item_pic_edited'
  WHEN items_sold = 1 AND NOT EXISTS (
    SELECT 1 FROM user_achievements WHERE user_id = current_user_id AND achievement_name = '1st_item_sold'
  ) THEN '1st_item_sold'
  WHEN items_swapped = 1 AND NOT EXISTS (
    SELECT 1 FROM user_achievements WHERE user_id = current_user_id AND achievement_name = '1st_item_swap'
  ) THEN '1st_item_swap'
  WHEN items_uploaded = 1 AND NOT EXISTS (
    SELECT 1 FROM user_achievements WHERE user_id = current_user_id AND achievement_name = '1st_item_uploaded'
  ) THEN '1st_item_uploaded'
  WHEN outfits_created = 1 AND NOT EXISTS (
    SELECT 1 FROM user_achievements WHERE user_id = current_user_id AND achievement_name = '1st_outfit_created'
  ) THEN '1st_outfit_created'
  WHEN selfie_taken = 1 AND NOT EXISTS (
    SELECT 1 FROM user_achievements WHERE user_id = current_user_id AND achievement_name = '1st_selfie_taken'
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


