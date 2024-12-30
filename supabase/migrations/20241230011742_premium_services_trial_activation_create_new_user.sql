CREATE OR REPLACE FUNCTION public.sync_user_profile()
RETURNS TRIGGER
SET search_path = ''
SECURITY DEFINER
AS $$
DECLARE
    v_closet_id UUID := gen_random_uuid();
    v_full_name TEXT := COALESCE(NEW.raw_user_meta_data->>'full_name', 'cc_none');
BEGIN
    -- Sync user profile information
    INSERT INTO public.user_profiles (id, name, email)
    VALUES (NEW.id, v_full_name, NEW.email::text);

    -- Ensure user exists in high frequency stats
    INSERT INTO public.user_high_freq_stats (user_id)
    VALUES (NEW.id);

    -- Ensure user exists in low frequency stats
    INSERT INTO public.user_low_freq_stats (user_id)
    VALUES (NEW.id);

    -- Ensure user exists in achievements
    INSERT INTO public.premium_services (user_id)
    VALUES (NEW.id);

    -- Insert into user_closets with the generated closet_id
    INSERT INTO public.user_closets (user_id, closet_id)
    VALUES (NEW.id, v_closet_id);

    -- Insert into shared_preferences using the same closet_id
    INSERT INTO public.shared_preferences (user_id, closet_id)
    VALUES (NEW.id, v_closet_id);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION public.activate_trial_premium_features()
RETURNS BOOLEAN
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    -- Automatically retrieve the current user's ID
    current_user_id UUID := auth.uid();
    v_target_features TEXT[] := ARRAY[
        'com.makinglifeeasie.closetconscious.filter',
        'com.makinglifeeasie.closetconscious.arrange',
        'com.makinglifeeasie.closetconscious.multicloset',
        'com.makinglifeeasie.closetconscious.multipleoutfits'
    ];
    v_one_off_features JSONB;
BEGIN
    -- Check if the user is authenticated
    IF current_user_id IS NULL THEN
        RAISE EXCEPTION 'User not authenticated';
    END IF;

    -- Quick pass: Check if the user is ineligible for update
    IF NOT EXISTS (
        SELECT 1
        FROM public.premium_services
        WHERE user_id = current_user_id
          AND DATE(created_at) = CURRENT_DATE
          AND is_trial = FALSE
    ) THEN
        RETURN FALSE; -- User does not meet the criteria for update
    END IF;

    -- Build the JSONB object for the target features
    v_one_off_features := (
        SELECT jsonb_object_agg(
            feature_key,
            jsonb_build_object(
                'acquisition_date', (CURRENT_TIMESTAMP + INTERVAL '30 days')::TEXT,
                'acquisition_method', 'trial'
            )
        )
        FROM UNNEST(v_target_features) AS feature_key
    );

    -- Update the premium_services table
    UPDATE public.premium_services
    SET premium_features = COALESCE(premium_features, '{}'::JSONB) || v_one_off_features,
        is_trial = TRUE
    WHERE user_id = current_user_id
      AND is_trial = FALSE
      AND DATE(created_at) = CURRENT_DATE;

    RETURN TRUE; -- Update was successful
END;
$$;


