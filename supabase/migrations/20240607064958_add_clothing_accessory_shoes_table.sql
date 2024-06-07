-- Define the items_clothing_basic table with ownership
CREATE TABLE items_clothing_basic (
  item_id UUID PRIMARY KEY REFERENCES items(item_id),
  current_owner_id UUID REFERENCES user_profiles(id) ON DELETE CASCADE,
  clothing_type TEXT NOT NULL CHECK (clothing_type IN ('top', 'bottom', 'full-length')),
  clothing_layer TEXT NOT NULL CHECK (clothing_layer IN ('base_layer', 'insulating_layer', 'outer_layer'))
);

-- Define the items_accessory_basic table with ownership
CREATE TABLE items_accessory_basic (
  item_id UUID PRIMARY KEY REFERENCES items(item_id),
  current_owner_id UUID REFERENCES user_profiles(id) ON DELETE CASCADE,
  accessory_type TEXT NOT NULL CHECK (accessory_type IN ('bag', 'belt', 'eyewear', 'gloves', 'hat', 'jewellery', 'scarf and wrap', 'tie & bowtie'))
);

-- Define the items_shoes_basic table with ownership
CREATE TABLE items_shoes_basic (
  item_id UUID PRIMARY KEY REFERENCES items(item_id),
  current_owner_id UUID REFERENCES user_profiles(id) ON DELETE CASCADE,
  shoes_type TEXT NOT NULL CHECK (shoes_type IN ('boots', 'casual shoes', 'running shoes', 'dress shoes', 'speciality shoes'))
);

-- Add comments to describe the purpose and fields of each table
COMMENT ON TABLE items_clothing_basic IS 'Table to store basic information about clothing items';
COMMENT ON COLUMN items_clothing_basic.item_id IS 'Unique identifier for each clothing item';
COMMENT ON TABLE items_clothing_basic.current_owner_id IS 'Identifier for the current owner of the item. This field is updated to reflect changes in ownership, such as through swaps or transfers';
COMMENT ON COLUMN items_clothing_basic.clothing_type IS 'Type of clothing: top, bottom, or full-length';
COMMENT ON COLUMN items_clothing_basic.clothing_layer IS 'Layer of clothing: base_layer, insulating_layer, or outer_layer';

COMMENT ON TABLE items_accessory_basic IS 'Table to store basic information about accessory items';
COMMENT ON TABLE items_accessory_basic.current_owner_id IS 'Identifier for the current owner of the item. This field is updated to reflect changes in ownership, such as through swaps or transfers';
COMMENT ON COLUMN items_accessory_basic.item_id IS 'Unique identifier for each accessory item';
COMMENT ON COLUMN items_accessory_basic.accessory_type IS 'Type of accessory: bag, belt, eyewear, gloves, hat, jewellery, scarf and wrap, or tie & bowtie';

COMMENT ON TABLE items_shoes_basic IS 'Table to store basic information about shoe items';
COMMENT ON TABLE items_shoes_basic.current_owner_id IS 'Identifier for the current owner of the item. This field is updated to reflect changes in ownership, such as through swaps or transfers';
COMMENT ON COLUMN items_shoes_basic.item_id IS 'Unique identifier for each shoe item';
COMMENT ON COLUMN items_shoes_basic.shoes_type IS 'Type of shoes: boots, casual shoes, running shoes, dress shoes, or speciality shoes';

-- Enable Row-Level Security on each table
ALTER TABLE items_clothing_basic ENABLE ROW LEVEL SECURITY;
ALTER TABLE items_accessory_basic ENABLE ROW LEVEL SECURITY;
ALTER TABLE items_shoes_basic ENABLE ROW LEVEL SECURITY;

-- Clothing table policies
CREATE POLICY clothing_basic_select_policy ON items_clothing_basic
FOR SELECT
USING (current_owner_id = auth.uid());

CREATE POLICY clothing_basic_update_policy ON items_clothing_basic
FOR UPDATE
USING (current_owner_id = auth.uid());

CREATE POLICY clothing_basic_insert_policy ON items_clothing_basic
FOR INSERT
WITH CHECK (current_owner_id = auth.uid());

CREATE POLICY clothing_basic_delete_policy ON items_clothing_basic
FOR DELETE
USING (current_owner_id = auth.uid());

-- Accessory table policies
CREATE POLICY accessory_basic_select_policy ON items_accessory_basic
FOR SELECT
USING (current_owner_id = auth.uid());

CREATE POLICY accessory_basic_update_policy ON items_accessory_basic
FOR UPDATE
USING (current_owner_id = auth.uid());

CREATE POLICY accessory_basic_insert_policy ON items_accessory_basic
FOR INSERT
WITH CHECK (current_owner_id = auth.uid());

CREATE POLICY accessory_basic_delete_policy ON items_accessory_basic
FOR DELETE
USING (current_owner_id = auth.uid());

-- Shoes table policies
CREATE POLICY shoes_basic_select_policy ON items_shoes_basic
FOR SELECT
USING (current_owner_id = auth.uid());

CREATE POLICY shoes_basic_update_policy ON items_shoes_basic
FOR UPDATE
USING (current_owner_id = auth.uid());

CREATE POLICY shoes_basic_insert_policy ON items_shoes_basic
FOR INSERT
WITH CHECK (current_owner_id = auth.uid());

CREATE POLICY shoes_basic_delete_policy ON items_shoes_basic
FOR DELETE
USING (current_owner_id = auth.uid());
