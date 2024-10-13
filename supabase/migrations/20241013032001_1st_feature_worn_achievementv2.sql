CREATE OR REPLACE FUNCTION public.fetch_clothes_worn_achievement_combined()
RETURNS JSON
SET search_path = ''
AS $$
DECLARE
    clothes_worn BOOLEAN;
    achievement_missing BOOLEAN;
    closet_achievement_completed BOOLEAN;
    current_user_id UUID := auth.uid();
    p_achievement_name TEXT := 'all_clothes_worn';
    c_achievement_name TEXT := 'closet_uploaded';
    reward_result JSONB;
    result JSON;
    feature_exists BOOLEAN;
    feature_name TEXT := 'com.makinglifeeasie.closetconscious.arrange';  -- Direct assignment since only one case
    acquisition_method TEXT := 'milestone'; -- Default value for acquisition_method
BEGIN

    SELECT EXISTS (
        SELECT 1 FROM public.user_achievements ua
        WHERE ua.user_id = current_user_id
        AND ua.achievement_name = c_achievement_name
    ) INTO closet_achievement_completed;

    IF NOT closet_achievement_completed THEN
        RETURN json_build_object('status', 'no_achievement', 'badge_url', 'none', 'feature', 'none');
    END IF;

    -- Check if user has 100% clothes worn and has not yet achieved 'all_clothes_worn'
    SELECT uhfs.initial_upload_items_worn_percentage = 100
    INTO clothes_worn
    FROM public.user_high_freq_stats uhfs
    WHERE uhfs.user_id = current_user_id;

    -- Exit early if clothes_worn is false
    IF NOT clothes_worn THEN
        RETURN json_build_object('status', 'no_achievement', 'badge_url', 'none', 'feature', 'none');
    END IF;

    -- Check if achievement is already awarded
    SELECT NOT EXISTS (
        SELECT 1 FROM public.user_achievements ua
        WHERE ua.user_id = current_user_id
        AND ua.achievement_name = p_achievement_name
    ) INTO achievement_missing;

    -- Exit if the achievement already exists
    IF NOT achievement_missing THEN
        RETURN json_build_object('status', 'no_achievement', 'badge_url', 'none', 'feature', 'none');
    END IF;

    -- Insert the achievement into the user_achievements table
    INSERT INTO public.user_achievements (user_id, achievement_name, awarded_at)
    VALUES (current_user_id, p_achievement_name, NOW());

    -- Fetch badge URL from achievements table
    SELECT json_build_object(
        'status', 'success',
        'badge_url', badge_url,
        'achievement_name', achievement_name)
    INTO result
    FROM public.achievements
    WHERE achievement_name = p_achievement_name;

    -- Check if the feature already exists in the premium_services table
    SELECT one_off_features ? feature_name INTO feature_exists
    FROM public.premium_services
    WHERE user_id = current_user_id;

    -- If feature doesn't exist, update it in the premium_services table
    IF NOT feature_exists THEN
        reward_result := jsonb_build_object(
            'acquisition_method', acquisition_method,
            'acquisition_date', CURRENT_TIMESTAMP
        );

        UPDATE public.premium_services
        SET one_off_features = jsonb_set(
            coalesce(one_off_features, '{}'::jsonb),
            ARRAY[feature_name],
            '{}'::jsonb || reward_result::jsonb
        ),
        updated_at = NOW()
        WHERE user_id = current_user_id;

        -- Return combined success result
        RETURN json_build_object(
            'status', 'success',
            'achievement_name', result->>'achievement_name',
            'badge_url', result->>'badge_url',
            'feature', 'activated'
        );
    ELSE
        -- Feature already exists, return with no update
        RETURN json_build_object(
            'status', 'success',
            'achievement_name', result->>'achievement_name',
            'badge_url', result->>'badge_url',
            'feature', 'already_exists'
        );
    END IF;

EXCEPTION WHEN OTHERS THEN
    -- Handle errors
    RETURN json_build_object(
        'status', 'error',
        'message', SQLERRM
    );
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION first_item_upload_achievement()
RETURNS JSON
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id uuid := auth.uid();  -- Get the current user ID from Supabase auth context
    result JSON;  -- JSON result to return success and badge URL
    item_upload_count INTEGER;  -- Variable to store the item uploaded count
    achievement_exists BOOLEAN;  -- Variable to check if the achievement already exists
BEGIN
    -- Ensure the user is authenticated
    IF current_user_id IS NULL THEN
        RETURN json_build_object(
            'status', 'error',
            'message', 'User not authenticated.'
        );
    END IF;

    -- Check how many items the user has uploaded
    SELECT COALESCE(items_uploaded, 0) INTO item_upload_count
    FROM public.user_high_freq_stats
    WHERE user_id = current_user_id;

    -- Check if the '1st_item_uploaded' achievement already exists for the user
    SELECT EXISTS (
        SELECT 1
        FROM public.user_achievements
        WHERE user_id = current_user_id
        AND achievement_name = '1st_item_uploaded'
    ) INTO achievement_exists;

    -- If the user has uploaded their first item and the achievement doesn't already exist
    IF item_upload_count = 1 AND NOT achievement_exists THEN
        -- Insert the achievement into the user_achievements table
        INSERT INTO public.user_achievements (user_id, achievement_name)
        VALUES (current_user_id, '1st_item_uploaded');

        -- Fetch the badge_url and other relevant information from the achievements table
        SELECT json_build_object(
            'status', 'success',
            'badge_url', badge_url,
            'achievement_name', achievement_name,
            'feature', 'cc_none'
        ) INTO result
        FROM public.achievements
        WHERE achievement_name = '1st_item_uploaded';

        -- Return the success JSON object
        RETURN result;
    ELSE
        -- If this is not their first upload or the achievement already exists
        RETURN json_build_object(
            'status', 'no_action',
            'message', 'Achievement already unlocked or not first upload.'
        );
    END IF;

END;
$$;


CREATE OR REPLACE FUNCTION first_item_pic_edited_achievement()
RETURNS JSON
SET search_path = ''  -- Set schema explicitly
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id uuid := auth.uid();  -- Get the current user ID from Supabase auth context
    result JSON;  -- JSON result to return success and badge URL
    item_pic_edited_count INTEGER;  -- Variable to store the item edited count
    achievement_exists BOOLEAN;  -- Variable to check if the achievement already exists
BEGIN
    -- Ensure the user is authenticated
    IF current_user_id IS NULL THEN
        RETURN json_build_object(
            'status', 'error',
            'message', 'User not authenticated.'
        );
    END IF;

    -- Check how many items the user has uploaded
    SELECT COALESCE(items_edited, 0) INTO item_pic_edited_count
    FROM public.user_high_freq_stats
    WHERE user_id = current_user_id;

    -- Check if the user has already unlocked the '1st_item_pic_edited' achievement
    SELECT EXISTS (
        SELECT 1
        FROM public.user_achievements
        WHERE user_id = current_user_id
        AND achievement_name = '1st_item_pic_edited'
    ) INTO achievement_exists;

    -- If the user has edited their first item picture and doesn't already have the achievement
    IF item_pic_edited_count = 1 AND NOT achievement_exists THEN
        -- Insert the achievement into the user_achievements table
        INSERT INTO public.user_achievements (user_id, achievement_name)
        VALUES (current_user_id, '1st_item_pic_edited');

        -- Fetch the badge_url and other relevant information from the achievements table
        SELECT json_build_object(
            'status', 'success',
            'badge_url', badge_url,
            'achievement_name', achievement_name,
            'feature', 'cc_none'
        ) INTO result
        FROM public.achievements
        WHERE achievement_name = '1st_item_pic_edited';

        -- Return the success JSON object
        RETURN result;
    ELSE
        -- If the achievement already exists or not their first item picture edit, return a different response
        RETURN json_build_object(
            'status', 'no_action',
            'message', 'Achievement already unlocked or not first item picture edit.'
        );
    END IF;

END;
$$;

CREATE OR REPLACE FUNCTION first_item_gifted_achievement()
RETURNS JSON
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id uuid := auth.uid();
    result JSON;
    item_gifted_count INTEGER;
    achievement_exists BOOLEAN;
BEGIN
    IF current_user_id IS NULL THEN
        RETURN json_build_object(
            'status', 'error',
            'message', 'User not authenticated.'
        );
    END IF;

    SELECT COALESCE(items_gifted, 0) INTO item_gifted_count
    FROM public.user_low_freq_stats
    WHERE user_id = current_user_id;

    -- Check if achievement already exists
    SELECT EXISTS (
        SELECT 1
        FROM public.user_achievements
        WHERE user_id = current_user_id
        AND achievement_name = '1st_item_gifted'
    ) INTO achievement_exists;

    IF item_gifted_count = 1 AND NOT achievement_exists THEN
        -- Insert the achievement if it doesn't already exist
        INSERT INTO public.user_achievements (user_id, achievement_name)
        VALUES (current_user_id, '1st_item_gifted');

        SELECT json_build_object(
            'status', 'success',
            'badge_url', badge_url,
            'achievement_name', achievement_name,
            'feature', 'cc_none'
        ) INTO result
        FROM public.achievements
        WHERE achievement_name = '1st_item_gifted';

        RETURN result;
    ELSE
        RETURN json_build_object(
            'status', 'no_action',
            'message', 'Achievement already unlocked or not first gift.'
        );
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION first_item_sold_achievement()
RETURNS JSON
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id uuid := auth.uid();
    result JSON;
    item_sold_count INTEGER;
    achievement_exists BOOLEAN;
BEGIN
    IF current_user_id IS NULL THEN
        RETURN json_build_object(
            'status', 'error',
            'message', 'User not authenticated.'
        );
    END IF;

    SELECT COALESCE(items_sold, 0) INTO item_sold_count
    FROM public.user_low_freq_stats
    WHERE user_id = current_user_id;

    -- Check if achievement already exists
    SELECT EXISTS (
        SELECT 1
        FROM public.user_achievements
        WHERE user_id = current_user_id
        AND achievement_name = '1st_item_sold'
    ) INTO achievement_exists;

    IF item_sold_count = 1 AND NOT achievement_exists THEN
        -- Insert the achievement if it doesn't already exist
        INSERT INTO public.user_achievements (user_id, achievement_name)
        VALUES (current_user_id, '1st_item_sold');

        SELECT json_build_object(
            'status', 'success',
            'badge_url', badge_url,
            'achievement_name', achievement_name,
            'feature', 'cc_none'
        ) INTO result
        FROM public.achievements
        WHERE achievement_name = '1st_item_sold';

        RETURN result;
    ELSE
        RETURN json_build_object(
            'status', 'no_action',
            'message', 'Achievement already unlocked or not first sale.'
        );
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION first_item_swap_achievement()
RETURNS JSON
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id uuid := auth.uid();
    result JSON;
    item_swap_count INTEGER;
    achievement_exists BOOLEAN;
BEGIN
    IF current_user_id IS NULL THEN
        RETURN json_build_object(
            'status', 'error',
            'message', 'User not authenticated.'
        );
    END IF;

    SELECT COALESCE(items_swapped, 0) INTO item_swap_count
    FROM public.user_low_freq_stats
    WHERE user_id = current_user_id;

    -- Check if achievement already exists
    SELECT EXISTS (
        SELECT 1
        FROM public.user_achievements
        WHERE user_id = current_user_id
        AND achievement_name = '1st_item_swap'
    ) INTO achievement_exists;

    IF item_swap_count = 1 AND NOT achievement_exists THEN
        -- Insert the achievement if it doesn't already exist
        INSERT INTO public.user_achievements (user_id, achievement_name)
        VALUES (current_user_id, '1st_item_swap');

        SELECT json_build_object(
            'status', 'success',
            'badge_url', badge_url,
            'achievement_name', achievement_name,
            'feature', 'cc_none'
        ) INTO result
        FROM public.achievements
        WHERE achievement_name = '1st_item_swap';

        RETURN result;
    ELSE
        RETURN json_build_object(
            'status', 'no_action',
            'message', 'Achievement already unlocked or not first swap.'
        );
    END IF;
END;
$$;


CREATE OR REPLACE FUNCTION first_outfit_created_achievement()
RETURNS JSON
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id uuid := auth.uid();
    result JSON;
    outfit_created_count INTEGER;
    achievement_exists BOOLEAN;
BEGIN
    IF current_user_id IS NULL THEN
        RETURN json_build_object(
            'status', 'error',
            'message', 'User not authenticated.'
        );
    END IF;

    SELECT COALESCE(outfits_created, 0) INTO outfit_created_count
    FROM public.user_high_freq_stats
    WHERE user_id = current_user_id;

    -- Check if achievement already exists
    SELECT EXISTS (
        SELECT 1
        FROM public.user_achievements
        WHERE user_id = current_user_id
        AND achievement_name = '1st_outfit_created'
    ) INTO achievement_exists;

    IF outfit_created_count = 1 AND NOT achievement_exists THEN
        -- Insert the achievement if it doesn't already exist
        INSERT INTO public.user_achievements (user_id, achievement_name)
        VALUES (current_user_id, '1st_outfit_created');

        SELECT json_build_object(
            'status', 'success',
            'badge_url', badge_url,
            'achievement_name', achievement_name,
            'feature', 'cc_none'
        ) INTO result
        FROM public.achievements
        WHERE achievement_name = '1st_outfit_created';

        RETURN result;
    ELSE
        RETURN json_build_object(
            'status', 'no_action',
            'message', 'Achievement already unlocked or not first outfit created.'
        );
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION first_selfie_taken_achievement()
RETURNS JSON
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id uuid := auth.uid();
    result JSON;
    selfie_taken_count INTEGER;
    achievement_exists BOOLEAN;
BEGIN
    IF current_user_id IS NULL THEN
        RETURN json_build_object(
            'status', 'error',
            'message', 'User not authenticated.'
        );
    END IF;

    SELECT COALESCE(selfie_taken, 0) INTO selfie_taken_count
    FROM public.user_high_freq_stats
    WHERE user_id = current_user_id;

    -- Check if achievement already exists
    SELECT EXISTS (
        SELECT 1
        FROM public.user_achievements
        WHERE user_id = current_user_id
        AND achievement_name = '1st_selfie_taken'
    ) INTO achievement_exists;

    IF selfie_taken_count = 1 AND NOT achievement_exists THEN
        -- Insert the achievement if it doesn't already exist
        INSERT INTO public.user_achievements (user_id, achievement_name)
        VALUES (current_user_id, '1st_selfie_taken');

        SELECT json_build_object(
            'status', 'success',
            'badge_url', badge_url,
            'achievement_name', achievement_name,
            'feature', 'cc_none'
        ) INTO result
        FROM public.achievements
        WHERE achievement_name = '1st_selfie_taken';

        RETURN result;
    ELSE
        RETURN json_build_object(
            'status', 'no_action',
            'message', 'Achievement already unlocked or not first selfie taken.'
        );
    END IF;
END;
$$;
