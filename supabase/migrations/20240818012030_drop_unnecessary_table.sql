BEGIN;

-- Step 1: Disable Row-Level Security
ALTER TABLE public.disliked_outfit_items DISABLE ROW LEVEL SECURITY;

-- Step 2: Drop the Table
DROP TABLE IF EXISTS public.disliked_outfit_items;


-- Step 1: Disable Row-Level Security
ALTER TABLE public.swaps DISABLE ROW LEVEL SECURITY;

-- Step 2: Drop the Table
DROP TABLE IF EXISTS public.swaps;

-- Step 3: Clean up functions
DROP FUNCTION IF EXISTS public.delete_user_folder_and_account(user_id uuid);
DROP FUNCTION IF EXISTS public.fetch_latest_outfit_for_review(feedback text);
DROP FUNCTION IF EXISTS public.tmp_fetch_latest_outfit_for_review(feedback text);

-- Step 4: Add new column to outfit_items
ALTER TABLE public.outfit_items
ADD COLUMN disliked BOOLEAN NOT NULL DEFAULT FALSE;

COMMENT ON COLUMN public.outfit_items.disliked IS 'Indicates if the item in the outfit was disliked by the user. If True, means that they dislike the item in the outfit.';

COMMIT;
