-- Start a transaction
BEGIN;

-- Drop sync functions
drop function if exists sync_user_high_freq_stats();
drop function if exists sync_user_low_freq_stats();
drop function if exists sync_user_premium_service();

-- Drop trigger functions
drop trigger if exists create_user_high_freq_stats_profile ON public.user_profiles;
drop trigger if exists create_user_low_freq_stats_profile ON public.user_profiles;
drop trigger if exists create_user_premium_service_profile ON public.user_profiles;

-- Create the function to sync `auth.users` with user records
CREATE OR REPLACE FUNCTION sync_user_profile()
RETURNS TRIGGER
SET search_path = ''
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Insert into user_profiles
    INSERT INTO public.user_profiles (id, name, email)
    VALUES (NEW.id, NEW.raw_user_meta_data->>'full_name', NEW.email);

    -- Insert into user_high_freq_stats
    INSERT INTO public.user_high_freq_stats (user_id)
    VALUES (NEW.id);

    -- Insert into user_low_freq_stats
    INSERT INTO public.user_low_freq_stats (user_id)
    VALUES (NEW.id);

    -- Insert into user_achievements
    INSERT INTO public.user_achievements (user_id)
    VALUES (NEW.id);

    RETURN NEW;
END;
$$;

-- Commit the transaction
COMMIT;
