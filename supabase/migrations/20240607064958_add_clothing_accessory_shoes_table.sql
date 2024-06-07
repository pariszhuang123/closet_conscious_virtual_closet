CREATE TABLE items_clothing_basic (
  item_id UUID PRIMARY KEY REFERENCES items(item_id) ON DELETE CASCADE,
  clothing_type TEXT NOT NULL CHECK (clothing_type IN ('top', 'bottom', 'full-length')),
  clothing_layer TEXT NOT NULL CHECK (clothing_layer IN ('base_layer', 'insulating_layer', 'outer_layer'))
);

CREATE TABLE items_accessory_basic (
  item_id UUID PRIMARY KEY REFERENCES items(item_id) ON DELETE CASCADE,
  accessory_type TEXT NOT NULL CHECK (accessory_type IN ('bag', 'belt', 'eyewear', 'gloves', 'hat', 'jewellery', 'scarf and wrap', 'tie & bowtie'))
);

CREATE TABLE items_shoes_basic (
  item_id UUID PRIMARY KEY REFERENCES items(item_id) ON DELETE CASCADE,
  shoes_type TEXT NOT NULL CHECK (shoes_type IN ('boots', 'casual shoes', 'running shoes', 'dress shoes', 'speciality shoes')),
);

COMMENT ON TABLE items_clothing_basic IS 'Table to store basic information about clothing items';
COMMENT ON COLUMN items_clothing_basic.item_id IS 'Unique identifier for each clothing item';
COMMENT ON COLUMN items_clothing_basic.clothing_type IS 'Type of clothing: top, bottom, or full-length';
COMMENT ON COLUMN items_clothing_basic.clothing_layer IS 'Layer of clothing: base_layer, insulating_layer, or outer_layer';

COMMENT ON TABLE items_accessory_basic IS 'Table to store basic information about accessory items';
COMMENT ON COLUMN items_accessory_basic.item_id IS 'Unique identifier for each accessory item';
COMMENT ON COLUMN items_accessory_basic.accessory_type IS 'Type of accessory: bag, belt, eyewear, gloves, hat, jewellery, scarf and wrap, or tie & bowtie';

COMMENT ON TABLE items_shoes_basic IS 'Table to store basic information about shoe items';
COMMENT ON COLUMN items_shoes_basic.item_id IS 'Unique identifier for each shoe item';
COMMENT ON COLUMN items_shoes_basic.shoes_type IS 'Type of shoes: boots, casual shoes, running shoes, dress shoes, or speciality shoes';

CREATE VIEW items_clothing_view AS
SELECT
  i.item_id,
  i.current_owner_id,
  c.clothing_type,
  c.clothing_layer
FROM
  items i
JOIN
  items_clothing_basic c ON i.item_id = c.item_id;

CREATE VIEW items_accessory_view AS
SELECT
  i.item_id,
  i.current_owner_id,
  a.accessory_type
FROM
  items i
JOIN
  items_accessory_basic a ON i.item_id = a.item_id;

CREATE VIEW items_shoes_view AS
SELECT
  i.item_id,
  i.current_owner_id,
  s.shoes_type
FROM
  items i
JOIN
  items_shoes_basic s ON i.item_id = s.item_id;

ALTER VIEW items_clothing_view ENABLE ROW LEVEL SECURITY;
ALTER VIEW items_accessory_view ENABLE ROW LEVEL SECURITY;
ALTER VIEW items_shoes_view ENABLE ROW LEVEL SECURITY;

CREATE POLICY view_items_clothing_select_policy ON items_clothing_view
FOR SELECT
USING (current_owner_id = auth.uid());

CREATE POLICY view_items_accessory_select_policy ON items_accessory_view
FOR SELECT
USING (current_owner_id = auth.uid());

CREATE POLICY view_items_shoes_select_policy ON items_shoes_view
FOR SELECT
USING (current_owner_id = auth.uid());
