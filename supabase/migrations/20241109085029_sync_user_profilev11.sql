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
