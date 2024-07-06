-- Drop existing outfit_items policies and table
DROP POLICY IF EXISTS "Allow user to access own items" ON public.outfit_items;
DROP POLICY IF EXISTS "Allow user to delete own outfit items" ON public.outfit_items;
DROP POLICY IF EXISTS "Allow user to insert outfit items" ON public.outfit_items;
DROP POLICY IF EXISTS "Allow user to modify own outfit items" ON public.outfit_items;

DROP TABLE IF EXISTS public.outfit_items;

-- Drop existing disliked_outfit_items policies and table
DROP POLICY IF EXISTS "Allow user to access own disliked items" ON public.disliked_outfit_items;
DROP POLICY IF EXISTS "Allow user to delete own disliked outfit items" ON public.disliked_outfit_items;
DROP POLICY IF EXISTS "Allow user to insert disliked outfit items" ON public.disliked_outfit_items;
DROP POLICY IF EXISTS "Allow user to modify own disliked outfit items" ON public.disliked_outfit_items;

DROP TABLE IF EXISTS public.disliked_outfit_items;

-- Create outfit_items table with comments
CREATE TABLE public.outfit_items (
    outfit_id uuid REFERENCES outfits(outfit_id) ON DELETE CASCADE,
    item_id uuid REFERENCES items(item_id),
    PRIMARY KEY (outfit_id, item_id)
);

-- Add comments to the columns
COMMENT ON COLUMN public.outfit_items.outfit_id IS 'References the unique identifier of an outfit in the outfits table';
COMMENT ON COLUMN public.outfit_items.item_id IS 'References the unique identifier of an item in the items table';
COMMENT ON TABLE public.outfit_items IS 'Table linking outfits to their respective items';

-- Enable Row Level Security on the outfit_items table if not already enabled
ALTER TABLE public.outfit_items ENABLE ROW LEVEL SECURITY;

-- Create a policy for selecting records for authenticated users
CREATE POLICY "Allow user to access own outfit items"
ON public.outfit_items
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1
        FROM public.outfits
        WHERE outfits.outfit_id = outfit_items.outfit_id
        AND outfits.user_id = (SELECT auth.uid())
    )
    AND EXISTS (
        SELECT 1
        FROM public.items
        WHERE items.item_id = outfit_items.item_id
        AND items.status = 'active'
    )
);

-- Create a policy for inserting records for authenticated users
CREATE POLICY "Allow user to insert outfit items"
ON public.outfit_items
TO authenticated
FOR INSERT
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.outfits
        WHERE outfits.outfit_id = outfit_items.outfit_id
        AND outfits.user_id = (SELECT auth.uid())
    )
    AND EXISTS (
        SELECT 1
        FROM public.items
        WHERE items.item_id = outfit_items.item_id
        AND items.status = 'active'
    )
);

-- Create a policy for updating records for authenticated users
CREATE POLICY "Allow user to update own outfit items"
ON public.outfit_items
FOR UPDATE
TO authenticated
USING (
    EXISTS (
        SELECT 1
        FROM public.outfits
        WHERE outfits.outfit_id = outfit_items.outfit_id
        AND outfits.user_id = (SELECT auth.uid())
    )
    AND EXISTS (
        SELECT 1
        FROM public.items
        WHERE items.item_id = outfit_items.item_id
        AND items.status = 'active'
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.outfits
        WHERE outfits.outfit_id = outfit_items.outfit_id
        AND outfits.user_id = (SELECT auth.uid())
    )
    AND EXISTS (
        SELECT 1
        FROM public.items
        WHERE items.item_id = outfit_items.item_id
        AND items.status = 'active'
    )
);

-- Create a policy for deleting records for authenticated users
CREATE POLICY "Allow user to delete own outfit items"
ON public.outfit_items
FOR DELETE
TO authenticated
USING (
    EXISTS (
        SELECT 1
        FROM public.outfits
        WHERE outfits.outfit_id = outfit_items.outfit_id
        AND outfits.user_id = (SELECT auth.uid())
    )
);

-- Create disliked_outfit_items table with comments
CREATE TABLE public.disliked_outfit_items (
    outfit_id uuid REFERENCES outfits(outfit_id) ON DELETE CASCADE,
    item_id uuid REFERENCES items(item_id),
    PRIMARY KEY (outfit_id, item_id)
);

-- Add comments to the columns
COMMENT ON COLUMN public.disliked_outfit_items.outfit_id IS 'References the unique identifier of an outfit in the outfits table';
COMMENT ON COLUMN public.disliked_outfit_items.item_id IS 'References the unique identifier of an item in the items table';
COMMENT ON TABLE public.disliked_outfit_items IS 'Table linking outfits to their respective disliked_items';

-- Enable Row Level Security on the disliked_outfit_items table if not already enabled
ALTER TABLE public.disliked_outfit_items ENABLE ROW LEVEL SECURITY;

-- Create a policy for selecting records for authenticated users
CREATE POLICY "Allow user to access own disliked_outfit items"
ON public.disliked_outfit_items
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1
        FROM public.outfits
        WHERE outfits.outfit_id = disliked_outfit_items.outfit_id
        AND outfits.user_id = (SELECT auth.uid())
    )
    AND EXISTS (
        SELECT 1
        FROM public.items
        WHERE items.item_id = disliked_outfit_items.item_id
        AND items.status = 'active'
    )
);

-- Create a policy for inserting records for authenticated users
CREATE POLICY "Allow user to insert disliked outfit items"
ON public.disliked_outfit_items
FOR INSERT
TO authenticated
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.outfits
        WHERE outfits.outfit_id = disliked_outfit_items.outfit_id
        AND outfits.user_id = (SELECT auth.uid())
    )
    AND EXISTS (
        SELECT 1
        FROM public.items
        WHERE items.item_id = disliked_outfit_items.item_id
        AND items.status = 'active'
    )
);

-- Create a policy for updating records for authenticated users
CREATE POLICY "Allow user to update own disliked outfit items"
ON public.disliked_outfit_items
FOR UPDATE
TO authenticated
USING (
    EXISTS (
        SELECT 1
        FROM public.outfits
        WHERE outfits.outfit_id = disliked_outfit_items.outfit_id
        AND outfits.user_id = (SELECT auth.uid())
    )
    AND EXISTS (
        SELECT 1
        FROM public.items
        WHERE items.item_id = disliked_outfit_items.item_id
        AND items.status = 'active'
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.outfits
        WHERE outfits.outfit_id = disliked_outfit_items.outfit_id
        AND outfits.user_id = (SELECT auth.uid())
    )
    AND EXISTS (
        SELECT 1
        FROM public.items
        WHERE items.item_id = disliked_outfit_items.item_id
        AND items.status = 'active'
    )
);

-- Create a policy for deleting records for authenticated users
CREATE POLICY "Allow user to delete own disliked_outfit items"
ON public.disliked_outfit_items
FOR DELETE
TO authenticated
USING (
    EXISTS (
        SELECT 1
        FROM public.outfits
        WHERE outfits.outfit_id = disliked_outfit_items.outfit_id
        AND outfits.user_id = (SELECT auth.uid())
    )
);
