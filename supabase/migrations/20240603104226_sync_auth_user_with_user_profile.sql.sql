-- Step 1: Create the function to sync `auth.users` with `user_profiles`
CREATE OR REPLACE FUNCTION sync_user_profile()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO user_profiles (user_id, name, email, role, created_at, updated_at)
    VALUES (NEW.id, NEW.raw_user_meta_data->>'full_name', NEW.email, 'authenticated', now(), now());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Step 2: Create the trigger to call the function
CREATE TRIGGER create_user_profile
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE FUNCTION sync_user_profile();
