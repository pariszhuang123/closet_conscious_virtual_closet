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
       SET one_off_features = COALESCE(one_off_features, '{}'::JSONB) || v_one_off_features,
           is_trial = TRUE
       WHERE user_id = current_user_id
         AND is_trial = FALSE
         AND DATE(created_at) = CURRENT_DATE;

       RETURN TRUE; -- Update was successful
   END;
   $$;

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
       FROM public.premium_services, jsonb_each(one_off_features)
       WHERE
           one_off_features->feature_key->>'acquisition_method' = 'trial'
           AND (one_off_features->feature_key->>'acquisition_date')::timestamp < CURRENT_DATE
           AND is_trial = TRUE
           AND user_id = current_user_id;

       -- If no feature keys to remove, exit early with FALSE
       IF feature_keys_to_remove IS NULL THEN
           RETURN FALSE;
       END IF;

       -- Update the premium_features JSONB by removing the expired trial keys
       UPDATE public.premium_services
       SET
           one_off_features = one_off_features - ARRAY(
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

