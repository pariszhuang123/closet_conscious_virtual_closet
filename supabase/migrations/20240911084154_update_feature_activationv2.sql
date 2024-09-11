CREATE OR REPLACE FUNCTION achievement_badge(p_achievement_name TEXT)
RETURNS JSON
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id uuid := auth.uid();
    result JSON;
BEGIN
    -- Update the user_achievements table with the provided achievement_name
    INSERT INTO public.user_achievements (user_id, achievement_name)
    VALUES (current_user_id, p_achievement_name)
    ON CONFLICT (user_id, achievement_name) DO NOTHING;

    -- Fetch the badge_url and other relevant information from the achievements table
    SELECT json_build_object(
        'status', 'success',
        'badge_url', COALESCE(badge_url, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/ClosetConscious/Small_CC_Logo.png')
    ) INTO result
    FROM public.achievements
    WHERE achievement_name = p_achievement_name;

    -- Check if result is NULL
    IF result IS NULL THEN
        result := json_build_object(
            'status', 'failure',
            'message', 'Achievement not found or badge not available'
        );
    END IF;

    -- Return the JSON object
    RETURN result;

EXCEPTION WHEN OTHERS THEN
    -- Handle unexpected errors
    RETURN json_build_object(
        'status', 'error',
        'message', SQLERRM
    );
END;
$$;


CREATE OR REPLACE FUNCTION achievement_milestone_reward(
    p_achievement_name TEXT
)
RETURNS JSON
SET search_path = ''
AS $$
DECLARE
    current_user_id uuid := auth.uid();
    result JSON;
    feature_exists BOOLEAN;
    feature_name TEXT;
    acquisition_method TEXT := 'milestone';  -- Default value for acquisition_method
BEGIN
    -- Step 1: Map achievement name to feature name
    feature_name := CASE
        WHEN p_achievement_name = 'no_new_clothes_90' THEN 'arrange'
        WHEN p_achievement_name = 'no_new_clothes_225' THEN 'filter'
        WHEN p_achievement_name = 'no_new_clothes_405' THEN 'multi_closet'
        WHEN p_achievement_name = 'no_new_clothes_630' THEN 'swap'
        WHEN p_achievement_name = 'no_new_clothes_900' THEN 'calendar'
        WHEN p_achievement_name = 'no_new_clothes_1215' THEN 'add_details'
        WHEN p_achievement_name = 'no_new_clothes_1575' THEN 'usage_analytics'
        ELSE NULL
    END;

    -- Step 2: Insert achievement into user_achievements table
    INSERT INTO public.user_achievements (user_id, achievement_name)
    VALUES (current_user_id, p_achievement_name)
    ON CONFLICT (user_id, achievement_name) DO NOTHING;

    -- Step 3: Fetch badge URL from achievements table
    SELECT json_build_object(
        'status', 'success',
        'badge_url', COALESCE(badge_url, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/ClosetConscious/Small_CC_Logo.png')
    ) INTO result
    FROM public.achievements
    WHERE achievement_name = p_achievement_name;

    -- If no badge found, return error
    IF result IS NULL THEN
        RETURN json_build_object(
            'status', 'failure',
            'message', 'Achievement not found or badge not available'
        );
    END IF;

    -- Step 4: Check if the feature already exists in users table
    IF feature_name IS NOT NULL THEN
        SELECT one_off_features ? feature_name INTO feature_exists
        FROM public.premium_services
        WHERE user_id = current_user_id;

        -- Step 5: If feature doesn't exist, update it in the premium_services table
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
    ELSE
        -- If the feature name is not mapped, return an error
        RETURN json_build_object(
            'status', 'failure',
            'message', 'No feature mapped to this achievement'
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

