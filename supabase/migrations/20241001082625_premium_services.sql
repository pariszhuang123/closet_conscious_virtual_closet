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

create or replace function check_user_access_to_create_outfit()
returns boolean
SET search_path = ''
as $$
declare
    current_user_id uuid := auth.uid();  -- Get the current authenticated user ID
begin
    -- Combine both tables and use CASE for the logic
    return (
        select case
            when uhs.daily_upload = true and ps.one_off_features ? 'com.makinglifeeasie.closetconscious.multipleoutfits' then true
            when uhs.daily_upload = false then true
            else false
        end
        from public.user_high_freq_stats uhs
        join public.premium_services ps
        on uhs.user_id = ps.user_id
        where uhs.user_id = current_user_id
    );
end;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION check_user_access_to_upload_items()
RETURNS JSON
SET search_path = ''
AS $$
DECLARE
    current_user_id UUID := auth.uid();  -- Get the current authenticated user ID
BEGIN
    -- Combine both tables and use CASE for the logic
    RETURN (
        SELECT CASE
            -- Check for Bronze upload feature
            WHEN uhs.items_uploaded = 100 AND NOT ps.one_off_features ? 'com.makinglifeeasie.closetconscious.bronzeuploaditem' THEN
                json_build_object('status', 'uploadItemBronze')

            -- Check for Silver upload feature
            WHEN uhs.items_uploaded = 300 AND NOT ps.one_off_features ? 'com.makinglifeeasie.closetconscious.silveruploaditem' THEN
                json_build_object('status', 'uploadItemSilver')

            -- Check for Gold upload feature
            WHEN uhs.items_uploaded = 1000 AND NOT ps.one_off_features ? 'com.makinglifeeasie.closetconscious.golduploaditem' THEN
                json_build_object('status', 'uploadItemGold')

            -- Default case if none match
            ELSE
                json_build_object('status', 'no_navigation')
        END
        FROM public.user_high_freq_stats uhs
        JOIN public.premium_services ps
        ON uhs.user_id = ps.user_id
        WHERE uhs.user_id = current_user_id
    );
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION check_user_access_to_edit_items()
RETURNS JSON
SET search_path = ''
AS $$
DECLARE
    current_user_id UUID := auth.uid();  -- Get the current authenticated user ID
BEGIN
    -- Combine both tables and use CASE for the logic
    RETURN (
        SELECT CASE
            -- Check for Bronze edit feature
            WHEN uhs.items_edited = 100 AND NOT ps.one_off_features ? 'com.makinglifeeasie.closetconscious.bronzeedititem' THEN
                json_build_object('status', 'editItemBronze')

            -- Check for Silver edit feature
            WHEN uhs.items_edited = 300 AND NOT ps.one_off_features ? 'com.makinglifeeasie.closetconscious.silveredititem' THEN
                json_build_object('status', 'editItemSilver')

            -- Check for Gold edit feature
            WHEN uhs.items_edited = 1000 AND NOT ps.one_off_features ? 'com.makinglifeeasie.closetconscious.goldedititem' THEN
                json_build_object('status', 'editItemGold')

            -- Default case if none match
            ELSE
                json_build_object('status', 'no_navigation')
        END
        FROM public.user_high_freq_stats uhs
        JOIN public.premium_services ps
        ON uhs.user_id = ps.user_id
        WHERE uhs.user_id = current_user_id
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_user_access_to_create_selfie()
RETURNS JSON
SET search_path = ''
AS $$
DECLARE
    current_user_id UUID := auth.uid();  -- Get the current authenticated user ID
BEGIN
    -- Combine both tables and use CASE for the logic
    RETURN (
        SELECT CASE
            -- Check for Bronze selfie feature
            WHEN uhs.selfie_taken = 100 AND NOT ps.one_off_features ? 'com.makinglifeeasie.closetconscious.bronzeselfie' THEN
                json_build_object('status', 'selfieBronze')

            -- Check for Silver selfie feature
            WHEN uhs.selfie_taken = 300 AND NOT ps.one_off_features ? 'com.makinglifeeasie.closetconscious.silverselfie' THEN
                json_build_object('status', 'selfieSilver')

            -- Check for Gold selfie feature
            WHEN uhs.selfie_taken = 1000 AND NOT ps.one_off_features ? 'com.makinglifeeasie.closetconscious.goldselfie' THEN
                json_build_object('status', 'selfieGold')

            -- Default case if none match
            ELSE
                json_build_object('status', 'no_navigation')
        END
        FROM public.user_high_freq_stats uhs
        JOIN public.premium_services ps
        ON uhs.user_id = ps.user_id
        WHERE uhs.user_id = current_user_id
    );
END;
$$ LANGUAGE plpgsql;