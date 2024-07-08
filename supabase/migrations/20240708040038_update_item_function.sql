DROP FUNCTION

-- Create Function update_accessory_metadata
CREATE OR REPLACE FUNCTION update_accessory_metadata(
  _item_id uuid,
  _item_type text DEFAULT NULL,
  _image_url text DEFAULT NULL,
  _name text DEFAULT NULL,
  _amount_spent numeric DEFAULT NULL,
  _occasion text DEFAULT NULL,
  _season text DEFAULT NULL,
  _colour text DEFAULT NULL,
  _colour_variations text DEFAULT NULL,
  _accessory_type text DEFAULT NULL
)
returns json
SET search_path = ''
language plpgsql
as $$

DECLARE
  current_user_id uuid := auth.uid();
BEGIN
  -- Update items table
  UPDATE public.items
  SET
    item_type = COALESCE(_item_type, item_type),
    image_url = COALESCE(_image_url, image_url),
    name = COALESCE(_name, name),
    amount_spent = COALESCE(_amount_spent, amount_spent),
    occasion = COALESCE(_occasion, occasion),
    season = COALESCE(_season, season),
    colour = COALESCE(_colour, colour),
    colour_variations = COALESCE(_colour_variations, colour_variations)
  WHERE item_id = _item_id;

  -- Check if accessory type needs to be updated
  IF _accessory_type IS NOT NULL THEN
    UPDATE public.items_accessory_basic
    SET
      accessory_type = COALESCE(_accessory_type, accessory_type)
    WHERE item_id = _item_id;
  END IF;

  -- Update user_high_freq_stats table
  UPDATE public.user_high_freq_stats
  SET items_edited = items_edited + 1
  WHERE user_id = current_user_id;

END;
$$ LANGUAGE plpgsql;
