BEGIN;

-- Rename user_id to upload_owner_id in the items table
ALTER TABLE public.items
RENAME COLUMN user_id TO upload_owner_id;

-- Add a new column current_owner_id with a foreign key constraint
ALTER TABLE public.items
ADD COLUMN current_owner_id UUID REFERENCES user_profiles(id) ON DELETE CASCADE;

-- Drop the old index on user_id
DROP INDEX IF EXISTS idx_items_user_id;

-- Create a new index on current_owner_id for better query performance
CREATE INDEX idx_items_current_owner_id ON public.items (current_owner_id);

-- Commenting on the upload_owner_id column
COMMENT ON COLUMN public.items.upload_owner_id IS 'Identifier for the user who originally uploaded the item. This field helps track who first added the item to the database.';

-- Commenting on the current_owner_id column
COMMENT ON COLUMN public.items.current_owner_id IS 'Identifier for the current owner of the item. This field is updated to reflect changes in ownership, such as through swaps or transfers.';

COMMIT;
