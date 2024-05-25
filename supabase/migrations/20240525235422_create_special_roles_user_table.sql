-- Insert pariszhuang@gmail.com as supabase_admin
INSERT INTO users (user_id, name, email, role, created_at, updated_at)
VALUES (gen_random_uuid(), 'Paris Zhuang', 'pariszhuang@gmail.com', 'supabase_admin', NOW(), NOW());

-- Insert tomzqb2@gmail.com as service_role
INSERT INTO users (user_id, name, email, role, created_at, updated_at)
VALUES (gen_random_uuid(), 'Tom ZQB', 'tomzqb2@gmail.com', 'service_role', NOW(), NOW());
