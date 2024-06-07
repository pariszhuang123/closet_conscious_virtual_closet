-- Drop the existing foreign key constraint
ALTER TABLE items
DROP CONSTRAINT items_user_id_fkey;

-- Add the constraint back without ON DELETE CASCADE
ALTER TABLE items
ADD CONSTRAINT items_upload_owner_id_fkey FOREIGN KEY (upload_owner_id) REFERENCES user_profiles (id);
