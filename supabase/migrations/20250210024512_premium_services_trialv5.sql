ALTER TABLE public.premium_services
ADD COLUMN trial_status TEXT DEFAULT 'pending' CHECK (trial_status IN ('pending', 'active', 'expired'));

COMMENT ON COLUMN public.premium_services.trial_status IS
'Defines the trial status of a user:
- pending: Before trial activation
- active: During the trial period
- expired: Trial has ended.';


CREATE OR REPLACE FUNCTION public.activate_trial_premium_features()
RETURNS BOOLEAN
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id UUID := auth.uid();
    v_target_features TEXT[] := ARRAY[
        'com.makinglifeeasie.closetconscious.filter',
        'com.makinglifeeasie.closetconscious.arrange',
        'com.makinglifeeasie.closetconscious.multicloset',
        'com.makinglifeeasie.closetconscious.multipleoutfits',
        'com.makinglifeeasie.closetconscious.calendar'
    ];
    v_existing_features TEXT[];
    v_new_trial_features JSONB;
BEGIN
    -- Check if the user is authenticated
    IF current_user_id IS NULL THEN
        RAISE EXCEPTION 'User not authenticated';
    END IF;

    -- Quick pass: Ensure user is eligible for trial activation
    IF NOT EXISTS (
        SELECT 1
        FROM public.premium_services
        WHERE user_id = current_user_id
          AND trial_status = 'pending' -- Only allow activation if trial is 'pending'
    ) THEN
        RETURN FALSE; -- User does not meet the criteria for update
    END IF;

    -- Get existing feature keys in one_off_features JSONB
    SELECT array_agg(key)
    INTO v_existing_features
    FROM public.premium_services,
         LATERAL jsonb_each_text(one_off_features)
    WHERE user_id = current_user_id;

    -- Build JSONB object for only missing features
    v_new_trial_features := (
        SELECT jsonb_object_agg(
            u.feature_key,
            jsonb_build_object(
                'acquisition_date', (CURRENT_TIMESTAMP + INTERVAL '30 days')::TEXT,
                'acquisition_method', 'trial'
            )
        )
        FROM (
            SELECT UNNEST(v_target_features) AS feature_key
        ) u
        WHERE u.feature_key NOT IN (SELECT UNNEST(v_existing_features))
    );

    -- If no new features to add, return false
    IF v_new_trial_features IS NULL THEN
        RETURN FALSE;
    END IF;

    -- Update the premium_services table with only missing features and set trial_status to 'active'
    UPDATE public.premium_services
    SET one_off_features = one_off_features || v_new_trial_features,
        trial_status = 'active' -- Set trial as active
    WHERE user_id = current_user_id
      AND trial_status = 'pending';

    RETURN TRUE;
END;
$$;


CREATE OR REPLACE FUNCTION public.validate_and_update_trial_features()
RETURNS BOOLEAN
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    feature_keys_to_remove JSONB;
    remaining_trial_features INT;
    current_user_id UUID := auth.uid();
BEGIN
    -- Check if the user is authenticated
    IF current_user_id IS NULL THEN
        RAISE EXCEPTION 'User not authenticated';
    END IF;

    -- Fetch all expired trial feature keys (acquisition_date past today)
    SELECT jsonb_object_agg(key, value)
    INTO feature_keys_to_remove
    FROM public.premium_services,
         LATERAL jsonb_each(one_off_features) AS feature(key, value)
    WHERE
        value->>'acquisition_method' = 'trial'
        AND (value->>'acquisition_date')::timestamp < CURRENT_DATE
        AND trial_status = 'active'
        AND user_id = current_user_id;

    -- If no expired trial features, exit early
    IF feature_keys_to_remove IS NULL THEN
        RETURN FALSE;
    END IF;

    -- Remove the expired trial features from the JSONB
    UPDATE public.premium_services
    SET
        one_off_features = one_off_features - ARRAY(SELECT jsonb_object_keys(feature_keys_to_remove)),
        updated_at = CURRENT_TIMESTAMP
    WHERE user_id = current_user_id
      AND trial_status = 'active';

    -- Check if any trial features remain after removal
    SELECT COUNT(*)
    INTO remaining_trial_features
    FROM public.premium_services,
         LATERAL jsonb_each(one_off_features) AS feature(key, value)
    WHERE user_id = current_user_id
      AND value->>'acquisition_method' = 'trial';

    -- If no more trial features exist, mark the trial as expired
    IF remaining_trial_features = 0 THEN
        UPDATE public.premium_services
        SET trial_status = 'expired'
        WHERE user_id = current_user_id
          AND trial_status = 'active';
    END IF;

    RETURN TRUE;
END;
$$;

