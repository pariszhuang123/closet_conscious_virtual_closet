-- Drop the existing role constraint
ALTER TABLE users DROP CONSTRAINT users_role_check;

-- Update existing roles
UPDATE users SET role = 'authenticated' WHERE role = 'user';
UPDATE users SET role = 'supabase_admin' WHERE role = 'admin';
UPDATE users SET role = 'service_role' WHERE role = 'developer';

-- Modify the role column to use Supabase roles
ALTER TABLE users
    ALTER COLUMN role SET DEFAULT 'authenticated',
    ADD CONSTRAINT users_role_check CHECK (role IN ('authenticated', 'supabase_admin', 'service_role'));
