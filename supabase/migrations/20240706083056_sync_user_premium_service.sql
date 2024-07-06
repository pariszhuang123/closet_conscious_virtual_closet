-- Inserts a row into public.premium_service
CREATE FUNCTION public.sync_user_premium_service()
RETURNS TRIGGER
SET search_path = ''
AS $$
BEGIN
  INSERT INTO public.premium_service (user_id)
  VALUES (NEW.id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger the function every time a user is created
CREATE TRIGGER create_user_premium_service_profile
AFTER INSERT ON public.user_profiles
FOR EACH ROW EXECUTE FUNCTION public. sync_user_premium_service();

-- Add comments to the columns
COMMENT ON COLUMN public.user_high_freq_stats.no_buy_streak IS 'The current streak of days the user has not made any purchases';
COMMENT ON COLUMN public.user_high_freq_stats.no_buy_highest_streak IS 'The highest streak of days the user has not made any purchases';
COMMENT ON COLUMN public.user_high_freq_stats.daily_upload IS 'A boolean indicating whether the user has uploaded items today';