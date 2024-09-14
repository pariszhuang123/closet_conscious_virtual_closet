CREATE OR REPLACE FUNCTION public.fetch_clothes_worn_achievement_combined()
RETURNS JSON
SET search_path = ''
AS $$
DECLARE
    clothes_worn BOOLEAN;
    current_user_id UUID := auth.uid();
    p_achievement_name CONSTANT TEXT := 'all_clothes_worn';
    reward_result JSON;
    result JSON;
    feature_exists BOOLEAN;
    feature_name TEXT := 'arrange';  -- Direct assignment since only one case
    acquisition_method TEXT := 'milestone'; -- Default value for acquisition_method
BEGIN
    -- Check if user has 100% clothes worn and has not yet achieved 'all_clothes_worn'
    SELECT uhfs.initial_upload_items_worn_percentage = 100
    INTO clothes_worn
    FROM public.user_high_freq_stats uhfs
    WHERE uhfs.user_id = current_user_id;

    IF clothes_worn THEN
        SELECT NOT EXISTS (
            SELECT 1
            FROM public.user_achievements ua
            WHERE ua.user_id = current_user_id
            AND ua.achievement_name = p_achievement_name
        ) INTO clothes_worn;
    END IF;

    -- Early exit if clothes_worn is false
    IF NOT clothes_worn THEN
        RETURN json_build_object(
            'status', 'no_achievement',
            'message', 'No achievement unlocked, clothes worn percentage is below 100%'
        );
    END IF;

    -- Insert the achievement into the user_achievements table
    INSERT INTO public.user_achievements (user_id, achievement_name, awarded_at)
    VALUES (current_user_id, p_achievement_name, NOW());

    -- Fetch badge URL from achievements table
    SELECT json_build_object(
        'status', 'success',
        'badge_url', badge_url
    ) INTO result
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
            coalesce(one_off_features -> feature_name, '{}'::jsonb) || reward_result
        ),
        updated_at = NOW()
        WHERE user_id = current_user_id;


        -- Return combined success result
        RETURN json_build_object(
            'status', 'success',
            'badge_url', result->>'badge_url',
            'feature', 'activated'
        );
    ELSE
        -- Feature already exists, return with no update
        RETURN json_build_object(
            'status', 'success',
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
