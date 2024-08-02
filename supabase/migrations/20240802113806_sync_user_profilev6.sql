CREATE OR REPLACE FUNCTION public.sync_user_profile()
RETURNS TRIGGER
SET search_path = ''
SECURITY DEFINER
AS $$
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

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;
