-- For items_accessory_basic
DROP POLICY IF EXISTS "accessory_basic_delete_policy" ON items_accessory_basic;
DROP POLICY IF EXISTS "accessory_basic_insert_policy" ON items_accessory_basic;
DROP POLICY IF EXISTS "accessory_basic_update_policy" ON items_accessory_basic;
DROP POLICY IF EXISTS "accessory_basic_select_policy" ON items_accessory_basic;

CREATE POLICY "user can access their items_accessory_basic"
ON items_accessory_basic
FOR SELECT
USING (EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_accessory_basic.item_id
  AND items.current_owner_id = (SELECT auth.uid())
)
AND EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_accessory_basic.item_id
  AND items.status = 'active'
));

CREATE POLICY "user can insert their items_accessory_basic"
ON items_accessory_basic
FOR INSERT
WITH CHECK (EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_accessory_basic.item_id
  AND items.current_owner_id = (SELECT auth.uid())
)
AND EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_accessory_basic.item_id
  AND items.status = 'active'
));

CREATE POLICY "user can update their items_accessory_basic"
ON items_accessory_basic
FOR UPDATE
USING (EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_accessory_basic.item_id
  AND items.current_owner_id = (SELECT auth.uid())
)
AND EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_accessory_basic.item_id
  AND items.status = 'active'
))
WITH CHECK (EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_accessory_basic.item_id
  AND items.current_owner_id = (SELECT auth.uid())
)
AND EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_accessory_basic.item_id
  AND items.status = 'active'
));

CREATE POLICY "user can delete their items_accessory_basic"
ON items_accessory_basic
FOR DELETE
USING (EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_accessory_basic.item_id
  AND items.current_owner_id = (SELECT auth.uid())
));

-- For items_clothing_basic
DROP POLICY IF EXISTS "clothing_basic_select_policy" ON items_clothing_basic;
DROP POLICY IF EXISTS "clothing_basic_delete_policy" ON items_clothing_basic;
DROP POLICY IF EXISTS "clothing_basic_update_policy" ON items_clothing_basic;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON items_clothing_basic;

CREATE POLICY "user can select their items_clothing_basic"
ON items_clothing_basic
FOR SELECT
USING (EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_clothing_basic.item_id
  AND items.current_owner_id = (SELECT auth.uid())
)
AND EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_clothing_basic.item_id
  AND items.status = 'active'
));

CREATE POLICY "user can insert their items_clothing_basic"
ON items_clothing_basic
FOR INSERT
WITH CHECK (EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_clothing_basic.item_id
  AND items.current_owner_id = (SELECT auth.uid())
)
AND EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_clothing_basic.item_id
  AND items.status = 'active'
));

CREATE POLICY "user can update their items_clothing_basic"
ON items_clothing_basic
FOR UPDATE
USING (EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_clothing_basic.item_id
  AND items.current_owner_id = (SELECT auth.uid())
)
AND EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_clothing_basic.item_id
  AND items.status = 'active'
))
WITH CHECK (EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_clothing_basic.item_id
  AND items.current_owner_id = (SELECT auth.uid())
)
AND EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_clothing_basic.item_id
  AND items.status = 'active'
));

CREATE POLICY "user can delete their items_clothing_basic"
ON items_clothing_basic
FOR DELETE
USING (EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_clothing_basic.item_id
  AND items.current_owner_id = (SELECT auth.uid())
));

-- For items_shoes_basic
DROP POLICY IF EXISTS "shoes_basic_insert_policy" ON items_shoes_basic;
DROP POLICY IF EXISTS "shoes_basic_select_policy" ON items_shoes_basic;
DROP POLICY IF EXISTS "shoes_basic_update_policy" ON items_shoes_basic;
DROP POLICY IF EXISTS "shoes_basic_delete_policy" ON items_shoes_basic;

CREATE POLICY "user can select their items_shoes_basic"
ON items_shoes_basic
FOR SELECT
USING (EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_shoes_basic.item_id
  AND items.current_owner_id = (SELECT auth.uid())
)
AND EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_shoes_basic.item_id
  AND items.status = 'active'
));

CREATE POLICY "user can insert their items_shoes_basic"
ON items_shoes_basic
FOR INSERT
WITH CHECK (EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_shoes_basic.item_id
  AND items.current_owner_id = (SELECT auth.uid())
)
AND EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_shoes_basic.item_id
  AND items.status = 'active'
));

CREATE POLICY "user can update their items_shoes_basic"
ON items_shoes_basic
FOR UPDATE
USING (EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_shoes_basic.item_id
  AND items.current_owner_id = (SELECT auth.uid())
)
AND EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_shoes_basic.item_id
  AND items.status = 'active'
))
WITH CHECK (EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_shoes_basic.item_id
  AND items.current_owner_id = (SELECT auth.uid())
)
AND EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_shoes_basic.item_id
  AND items.status = 'active'
));

CREATE POLICY "user can delete their items_shoes_basic"
ON items_shoes_basic
FOR DELETE
USING (EXISTS (
  SELECT 1
  FROM items
  WHERE items.item_id = items_shoes_basic.item_id
  AND items.current_owner_id = (SELECT auth.uid())
));

-- Drop the existing foreign key constraint on item_id and add new one with ON DELETE CASCADE for items_accessory_basic
ALTER TABLE items_accessory_basic
DROP CONSTRAINT IF EXISTS fk_item_id;

ALTER TABLE items_accessory_basic
ADD CONSTRAINT fk_item_id
FOREIGN KEY (item_id)
REFERENCES items(item_id)
ON DELETE CASCADE;

-- Drop the foreign key constraint on current_owner_id if it exists and drop the column
ALTER TABLE items_accessory_basic
DROP CONSTRAINT IF EXISTS fk_current_owner_id;

ALTER TABLE items_accessory_basic
DROP COLUMN current_owner_id;

-- Drop the existing foreign key constraint on item_id and add new one with ON DELETE CASCADE for items_clothing_basic
ALTER TABLE items_clothing_basic
DROP CONSTRAINT IF EXISTS fk_item_id;

ALTER TABLE items_clothing_basic
ADD CONSTRAINT fk_item_id
FOREIGN KEY (item_id)
REFERENCES items(item_id)
ON DELETE CASCADE;

-- Drop the foreign key constraint on current_owner_id if it exists and drop the column
ALTER TABLE items_clothing_basic
DROP CONSTRAINT IF EXISTS fk_current_owner_id;

ALTER TABLE items_clothing_basic
DROP COLUMN current_owner_id;

-- Drop the existing foreign key constraint on item_id and add new one with ON DELETE CASCADE for items_shoes_basic
ALTER TABLE items_shoes_basic
DROP CONSTRAINT IF EXISTS fk_item_id;

ALTER TABLE items_shoes_basic
ADD CONSTRAINT fk_item_id
FOREIGN KEY (item_id)
REFERENCES items(item_id)
ON DELETE CASCADE;

-- Drop the foreign key constraint on current_owner_id if it exists and drop the column
ALTER TABLE items_shoes_basic
DROP CONSTRAINT IF EXISTS fk_current_owner_id;

ALTER TABLE items_shoes_basic
DROP COLUMN current_owner_id;
