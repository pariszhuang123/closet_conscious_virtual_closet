-- inserts a row into public.profiles
CREATE OR REPLACE FUNCTION public.sync_user_profile()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.user_profiles (id, email, name, role, created_at, updated_at)
  VALUES (new.id, new.raw_user_meta_data ->> 'name', new.email, 'authenticated', now(), now());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- trigger the function every time a user is created
CREATE TRIGGER public.create_user_profile
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE FUNCTION public.sync_user_profile();