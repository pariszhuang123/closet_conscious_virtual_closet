CREATE OR REPLACE FUNCTION public.sync_user_profile()
RETURNS TRIGGER
SET search_path = ''
SECURITY DEFINER
AS $$
DECLARE
    v_closet_id UUID;  -- Variable to store the generated closet_id
BEGIN
    -- Sync user profile information
    INSERT INTO public.user_profiles (id, name, email)
    VALUES (NEW.id, NEW.raw_user_meta_data->>'full_name', NEW.email::text);

    -- Ensure user exists in high frequency stats
    INSERT INTO public.user_high_freq_stats (user_id)
    VALUES (NEW.id);

    -- Ensure user exists in low frequency stats
    INSERT INTO public.user_low_freq_stats (user_id)
    VALUES (NEW.id);

    -- Ensure user exists in achievements
    INSERT INTO public.premium_services (user_id)
    VALUES (NEW.id);

    -- Insert into user_closets and capture the generated closet_id
    INSERT INTO public.user_closets (user_id)
    VALUES (NEW.id)
    RETURNING closet_id INTO v_closet_id;

    -- Update shared_preferences with the generated closet_id
    INSERT INTO public.shared_preferences (user_id, closet_id)
    VALUES (NEW.id, v_closet_id)
    ON CONFLICT (user_id) DO UPDATE
    SET closet_id = EXCLUDED.closet_id;

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;
