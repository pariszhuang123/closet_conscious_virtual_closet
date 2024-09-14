CREATE OR REPLACE FUNCTION fetch_milestone_achievements()
RETURNS json
SET search_path = ''
AS $$
DECLARE
    current_streak int;
    current_user_id uuid := auth.uid();
    p_achievement_name text;
    inserted_achievement jsonb := '{}'::jsonb;
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

        inserted_achievement := jsonb_build_object('achievement_name', p_achievement_name);

        -- Step 1: Map achievement to feature
        feature_name := CASE
            WHEN p_achievement_name = 'all_clothes_worn' THEN 'arrange'
            WHEN p_achievement_name = 'no_new_clothes_90' THEN 'multi_outfit'
            WHEN p_achievement_name = 'no_new_clothes_225' THEN 'filter'
            WHEN p_achievement_name = 'no_new_clothes_405' THEN 'multi_closet'
            WHEN p_achievement_name = 'no_new_clothes_630' THEN 'swap'
            WHEN p_achievement_name = 'no_new_clothes_900' THEN 'calendar'
            WHEN p_achievement_name = 'no_new_clothes_1215' THEN 'add_details'
            WHEN p_achievement_name = 'no_new_clothes_1575' THEN 'usage_analytics'
            ELSE NULL
        END;

        -- Step 2: Fetch badge URL for the achievement
        SELECT json_build_object(
            'status', 'success',
            'badge_url', badge_url)
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
                    'inserted_achievement', inserted_achievement,
                    'badge_url', result->>'badge_url',
                    'feature', 'activated'
                );
            ELSE
                -- Feature already exists
                RETURN json_build_object(
                    'status', 'success',
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
