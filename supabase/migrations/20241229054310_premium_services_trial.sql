ALTER TABLE public.premium_services
ADD COLUMN is_trial BOOLEAN NOT NULL DEFAULT FALSE;

COMMENT ON COLUMN public.premium_services.is_trial IS 'Indicates whether the user is currently in their 30-day trial period. Default is FALSE where they are not on trial.';


CREATE OR REPLACE FUNCTION public.sync_user_profile()
RETURNS TRIGGER
SET search_path = ''
SECURITY DEFINER
AS $$
DECLARE
    v_closet_id UUID := gen_random_uuid();
    v_full_name TEXT := COALESCE(NEW.raw_user_meta_data->>'full_name', 'cc_none');
    v_one_off_features JSONB := '{}'::JSONB;
    v_target_features TEXT[] := ARRAY[
        'com.makinglifeeasie.closetconscious.filter',
        'com.makinglifeeasie.closetconscious.arrange',
        'com.makinglifeeasie.closetconscious.multicloset',
        'com.makinglifeeasie.closetconscious.multipleoutfits'
    ];
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

    -- Build the JSONB object for the target features with trial acquisition data
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

    -- Insert the trial data into premium_features for new users
    INSERT INTO public.premium_services (user_id, premium_features, is_trial)
    VALUES (
        NEW.id,
        v_one_off_features,
        TRUE
    )
    ON CONFLICT (user_id) DO UPDATE
    SET premium_features = COALESCE(premium_services.premium_features, '{}'::JSONB) || EXCLUDED.premium_features;

    -- Insert into user_closets with the generated closet_id
    INSERT INTO public.user_closets (user_id, closet_id)
    VALUES (NEW.id, v_closet_id);

    -- Insert into shared_preferences using the same closet_id
    INSERT INTO public.shared_preferences (user_id, closet_id)
    VALUES (NEW.id, v_closet_id);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.validate_and_update_trial_features()
RETURNS BOOLEAN
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    feature_keys_to_remove JSONB;
    current_user_id UUID := auth.uid();

BEGIN
    -- Fetch all feature keys with acquisition_method 'trial' and acquisition_date earlier than today's date
    SELECT jsonb_object_agg(
        feature_key,
        premium_features->feature_key
    )
    INTO feature_keys_to_remove
    FROM public.premium_services, jsonb_each(premium_features)
    WHERE
        premium_features->feature_key->>'acquisition_method' = 'trial'
        AND (premium_features->feature_key->>'acquisition_date')::timestamp < CURRENT_DATE
        AND is_trial = TRUE
        AND user_id = current_user_id;

    -- If no feature keys to remove, exit early with FALSE
    IF feature_keys_to_remove IS NULL THEN
        RETURN FALSE;
    END IF;

    -- Update the premium_features JSONB by removing the expired trial keys
    UPDATE public.premium_services
    SET
        premium_features = premium_features - ARRAY(
            SELECT jsonb_object_keys(feature_keys_to_remove)
        ),
        is_trial = FALSE,
        updated_at = CURRENT_TIMESTAMP
    WHERE is_trial = TRUE
      AND user_id = current_user_id;

    -- If updates were made, return TRUE
    RETURN TRUE;
END;
$$;

