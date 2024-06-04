-- Step 1: Update the function to sync `auth.users` with `user_profiles`
CREATE OR REPLACE FUNCTION sync_user_profile()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO user_profiles (user_id, email, role, created_at, updated_at)
    VALUES (NEW.id, NEW.email, 'authenticated', now(), now())
    ON CONFLICT (user_id) DO UPDATE SET
        email = NEW.email,
        role = 'authenticated',
        updated_at = now();
    RETURN NEW;
END;
$$
 LANGUAGE plpgsql;

-- Step 2: No need to update the trigger