ALTER TABLE items
ADD COLUMN name TEXT NOT NULL,
ADD COLUMN amount_spent NUMERIC(10, 2) NOT NULL CHECK (amount_spent >= 0),
ADD COLUMN occasion TEXT NOT NULL CHECK (occasion IN ('active', 'casual', 'workplace', 'social', 'event')),
ADD COLUMN season TEXT NOT NULL CHECK (season IN ('spring', 'summer', 'autumn', 'winter')),
ADD COLUMN colour TEXT NOT NULL CHECK (colour IN ('red', 'blue', 'green', 'yellow', 'brown', 'grey', 'rainbow', 'black', 'white')),
ADD COLUMN colour_variations TEXT CHECK (colour_variations IN ('light', 'medium', 'dark'));

-- Add descriptions for the columns
COMMENT ON COLUMN items.name IS 'This column stores the name of the item. The value cannot be NULL, ensuring that every item has a name.';
COMMENT ON COLUMN items.amount_spent IS 'This column records the amount of money spent on the item. The value cannot be NULL, must be a numeric value with up to 10 digits, 2 of which are decimal places, and must be non-negative (greater than or equal to 0).';
COMMENT ON COLUMN items.occasion IS 'This column specifies the occasion the item is suitable for. The value cannot be NULL and must be one of the predefined values: active, casual, workplace, social, event.';
COMMENT ON COLUMN items.season IS 'This column indicates the season during which the item is typically worn. The value cannot be NULL and must be one of the predefined values: spring, summer, autumn, winter.';
COMMENT ON COLUMN items.colour IS 'This column stores the primary color of the item. The value cannot be NULL and must be one of the predefined values: red, blue, green, yellow, brown, grey, rainbow, black, white.';
COMMENT ON COLUMN items.colour_variations IS 'This column indicates the color variation of the item. The value must be one of the predefined values: light, medium, dark. The column can be NULL unless specified otherwise.';
