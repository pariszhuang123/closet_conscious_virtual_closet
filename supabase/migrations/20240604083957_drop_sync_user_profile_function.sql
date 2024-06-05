-- Step 1: Drop the trigger
DROP TRIGGER IF EXISTS create_user_profile ON auth.users;

-- Step 2: Drop the function
DROP FUNCTION IF EXISTS sync_user_profile();

