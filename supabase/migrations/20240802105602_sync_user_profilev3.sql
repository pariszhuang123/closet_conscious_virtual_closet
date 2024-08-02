CREATE OR REPLACE FUNCTION sync_user_profile()
RETURNS TRIGGER
SET search_path = ''
SECURITY DEFINER
AS $$
BEGIN
    -- Sync user profile information
    INSERT INTO public.user_profiles (id, name, email)
    VALUES (NEW.id, NEW.raw_user_meta_data->>'full_name', NEW.email)
    ON CONFLICT (id) DO UPDATE
    SET name = EXCLUDED.name,
        email = EXCLUDED.email;

    -- Ensure user exists in high frequency stats
    INSERT INTO public.user_high_freq_stats (user_id)
    VALUES (NEW.id)
    ON CONFLICT (user_id) DO NOTHING;

    -- Ensure user exists in low frequency stats
    INSERT INTO public.user_low_freq_stats (user_id)
    VALUES (NEW.id)
    ON CONFLICT (user_id) DO NOTHING;

    -- Ensure user exists in achievements
    INSERT INTO public.user_achievements (user_id)
    VALUES (NEW.id)
    ON CONFLICT (user_id) DO NOTHING;

    RETURN NEW;

EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions and log errors
        RAISE NOTICE 'Error in sync_user_profile function: %', SQLERRM;
        RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Trigger to sync user profile after insert or update on auth.users
CREATE TRIGGER trigger_sync_user_profile
AFTER INSERT OR UPDATE ON auth.users
FOR EACH ROW
EXECUTE FUNCTION sync_user_profile();
