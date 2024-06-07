BEGIN;

-- Add NOT NULL constraints to the specified columns in user_high_freq_stats
ALTER TABLE public.user_high_freq_stats
ALTER COLUMN items_uploaded SET NOT NULL;

ALTER TABLE public.user_high_freq_stats
ALTER COLUMN items_edited SET NOT NULL;

ALTER TABLE public.user_high_freq_stats
ALTER COLUMN outfits_created SET NOT NULL;

ALTER TABLE public.user_high_freq_stats
ALTER COLUMN created_at SET NOT NULL;

ALTER TABLE public.user_high_freq_stats
ALTER COLUMN updated_at SET NOT NULL;

-- Add NOT NULL constraints to the specified columns in user_low_freq_stats
ALTER TABLE public.user_low_freq_stats
ALTER COLUMN items_swapped SET NOT NULL;

ALTER TABLE public.user_low_freq_stats
ALTER COLUMN items_sold SET NOT NULL;

ALTER TABLE public.user_low_freq_stats
ALTER COLUMN items_gifted SET NOT NULL;

ALTER TABLE public.user_low_freq_stats
ALTER COLUMN new_clothings SET NOT NULL;

ALTER TABLE public.user_low_freq_stats
ALTER COLUMN new_clothings_value SET NOT NULL;

ALTER TABLE public.user_low_freq_stats
ALTER COLUMN app_ambassador SET NOT NULL;

ALTER TABLE public.user_low_freq_stats
ALTER COLUMN created_at SET NOT NULL;

ALTER TABLE public.user_low_freq_stats
ALTER COLUMN updated_at SET NOT NULL;

-- Inserts a row into public.user_low_freq_stats
CREATE FUNCTION public.sync_user_low_freq_stats()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.user_low_freq_stats (user_id, items_swapped, items_sold, items_gifted, new_clothings, new_clothings_value, app_ambassador, created_at, updated_at)
  VALUES (NEW.id, 0, 0, 0, 0, 0, 0, now(), now());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger the function every time a user is created
CREATE TRIGGER create_user_low_freq_stats_profile
AFTER INSERT ON public.user_profiles
FOR EACH ROW EXECUTE FUNCTION public.sync_user_low_freq_stats();

-- Inserts a row into public.user_high_freq_stats
CREATE FUNCTION public.sync_user_high_freq_stats()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.user_high_freq_stats (user_id, items_uploaded, items_edited, outfits_created, created_at, updated_at)
  VALUES (NEW.id, 0, 0, 0, now(), now());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger the function every time a user is created
CREATE TRIGGER create_user_high_freq_stats_profile
AFTER INSERT ON public.user_profiles
FOR EACH ROW EXECUTE FUNCTION public.sync_user_high_freq_stats();

COMMIT;
