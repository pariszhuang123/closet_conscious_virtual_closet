-- Inserts a row into public.user_profiles
CREATE OR REPLACE FUNCTION public.sync_user_profile()
RETURNS TRIGGER AS $$
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = 'public, auth'
AS $$
BEGIN
  INSERT INTO public.user_profiles (user_id, name, email, role, created_at, updated_at)
  VALUES (NEW.id::uuid, NEW.raw_user_meta_data ->> 'name', NEW.email::text, 'authenticated', now(), now());
  RETURN NEW;
END;
$$;

-- trigger the function every time a user is created
CREATE TRIGGER create_user_profile
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE FUNCTION public.sync_user_profile();

