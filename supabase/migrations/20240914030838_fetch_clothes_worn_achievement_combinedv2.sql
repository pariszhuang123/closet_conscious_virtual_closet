CREATE OR REPLACE FUNCTION public.fetch_clothes_worn_achievement_combined()
RETURNS jsonb
SET search_path = ''
AS $$
DECLARE
    clothes_worn BOOLEAN;
    current_user_id UUID := auth.uid();
    p_achievement_name CONSTANT TEXT := 'all_clothes_worn';
    result JSONB;
    feature_exists BOOLEAN;
    feature_name CONSTANT TEXT := 'arrange';  -- Declaring as CONSTANT
    acquisition_method CONSTANT TEXT := 'milestone';  -- Declaring as CONSTANT
    debug_info JSONB := '{}'::JSONB; -- Initialize JSONB for debugging
BEGIN
    -- Track current user ID in debug info
    debug_info := jsonb_set(debug_info, '{user_id}', to_jsonb(current_user_id));

    -- Check if user has 100% clothes worn and achievement not earned
    SELECT uhfs.initial_upload_items_worn_percentage = 100,
           NOT EXISTS (SELECT 1 FROM public.user_achievements ua WHERE ua.user_id = current_user_id AND ua.achievement_name = p_achievement_name)
    INTO clothes_worn, clothes_worn
    FROM public.user_high_freq_stats uhfs
    WHERE uhfs.user_id = current_user_id;

    -- Add clothes_worn check to debug info
    debug_info := jsonb_set(debug_info, '{clothes_worn_check}', to_jsonb(clothes_worn));

    -- Early exit if clothes_worn is false
    IF NOT clothes_worn THEN
        RETURN jsonb_build_object(
            'status', 'no_achievement',
            'message', 'No achievement unlocked, clothes worn percentage is below 100%',
            'debug_info', debug_info
        );
    END IF;

    -- Insert the achievement into the user_achievements table
    INSERT INTO public.user_achievements (user_id, achievement_name, awarded_at)
    VALUES (current_user_id, p_achievement_name, NOW());

    -- Track that the achievement was inserted
    debug_info := jsonb_set(debug_info, '{achievement_inserted}', to_jsonb(true));

    -- Fetch badge URL from achievements table
    SELECT jsonb_build_object(
        'status', 'success',
        'badge_url', badge_url
    ) INTO result
    FROM public.achievements
    WHERE achievement_name = p_achievement_name;

    -- Add badge URL to debug info
    debug_info := jsonb_set(debug_info, '{badge_url}', result->'badge_url');

    -- Check if the feature already exists in the premium_services table
    SELECT one_off_features ? feature_name INTO feature_exists
    FROM public.premium_services
    WHERE user_id = current_user_id;

    -- Add feature existence check to debug info
    debug_info := jsonb_set(debug_info, '{feature_exists}', to_jsonb(feature_exists));

    -- If feature doesn't exist, update it in the premium_services table
    IF NOT feature_exists THEN
        UPDATE public.premium_services
        SET one_off_features = jsonb_set(
            coalesce(one_off_features, '{}'::jsonb),
            ARRAY[feature_name],
            coalesce(one_off_features -> feature_name, '{}'::jsonb) || jsonb_build_object(
                'acquisition_method', acquisition_method,
                'acquisition_date', CURRENT_TIMESTAMP
            )
        ),
        updated_at = NOW()
        WHERE user_id = current_user_id;

        -- Track feature activation in debug info
        debug_info := jsonb_set(debug_info, '{feature_activated}', to_jsonb(true));

        -- Return combined success result
        RETURN jsonb_build_object(
            'status', 'success',
            'badge_url', result->>'badge_url',
            'feature', 'activated',
            'debug_info', debug_info
        );
    ELSE
        -- Track that the feature already exists in debug info
        debug_info := jsonb_set(debug_info, '{feature_activated}', to_jsonb(false));

        -- Feature already exists, return with no update
        RETURN jsonb_build_object(
            'status', 'success',
            'badge_url', result->>'badge_url',
            'feature', 'already_exists',
            'debug_info', debug_info
        );
    END IF;

EXCEPTION WHEN OTHERS THEN
    -- Track errors in debug info
    debug_info := jsonb_set(debug_info, '{error}', to_jsonb(SQLERRM));

    -- Handle errors
    RETURN jsonb_build_object(
        'status', 'error',
        'message', SQLERRM,
        'debug_info', debug_info
    );
END;
$$ LANGUAGE plpgsql;
