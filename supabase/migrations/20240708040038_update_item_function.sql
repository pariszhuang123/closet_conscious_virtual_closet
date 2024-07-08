-- Drop Function update_accessory_metadata
drop function if exists update_accessory_metadata(
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
);
-- Drop Function update_clothing_metadata
drop function if exists update_clothing_metadata(
  _item_id uuid,
  _item_type text DEFAULT NULL,
  _image_url text DEFAULT NULL,
  _name text DEFAULT NULL,
  _amount_spent numeric DEFAULT NULL,
  _occasion text DEFAULT NULL,
  _season text DEFAULT NULL,
  _colour text DEFAULT NULL,
  _colour_variations text DEFAULT NULL,
  _clothing_type text DEFAULT NULL,
  _clothing_layer text DEFAULT NULL
);

-- Drop Function update_shoes_metadata
drop function if exists update_shoes_metadata(
  _item_id uuid,
  _item_type text DEFAULT NULL,
  _image_url text DEFAULT NULL,
  _name text DEFAULT NULL,
  _amount_spent numeric DEFAULT NULL,
  _occasion text DEFAULT NULL,
  _season text DEFAULT NULL,
  _colour text DEFAULT NULL,
  _colour_variations text DEFAULT NULL,
  _shoes_type text DEFAULT NULL
);

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
RETURNS json
SET search_path = ''
LANGUAGE plpgsql
AS $$
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
  WHERE item_id = _item_id AND current_owner_id = current_user_id;

  -- Check if accessory type needs to be updated
  IF _accessory_type IS NOT NULL THEN
    UPDATE public.items_accessory_basic
    SET
      accessory_type = COALESCE(_accessory_type, accessory_type)
    WHERE item_id = _item_id AND current_owner_id = current_user_id;
  END IF;

  -- Update user_high_freq_stats table
  UPDATE public.user_high_freq_stats
  SET items_edited = items_edited + 1;

  -- Return success response with a custom message
  RETURN json_build_object('status', 'success', 'message', 'You have successfully updated your item.');

END;
$$;

-- Create Function update_clothing_metadata
CREATE OR REPLACE FUNCTION update_clothing_metadata(
  _item_id uuid,
  _item_type text DEFAULT NULL,
  _image_url text DEFAULT NULL,
  _name text DEFAULT NULL,
  _amount_spent numeric DEFAULT NULL,
  _occasion text DEFAULT NULL,
  _season text DEFAULT NULL,
  _colour text DEFAULT NULL,
  _colour_variations text DEFAULT NULL,
  _clothing_type text DEFAULT NULL,
  _clothing_layer text DEFAULT NULL
)
RETURNS json
SET search_path = ''
LANGUAGE plpgsql
AS $$
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
  WHERE item_id = _item_id AND current_owner_id = current_user_id;

  -- Check if clothing type needs to be updated
  IF _clothing_type IS NOT NULL THEN
    UPDATE public.items_clothing_basic
    SET
      clothing_type = COALESCE(_clothing_type, clothing_type)
    WHERE item_id = _item_id AND current_owner_id = current_user_id;
  END IF;

  -- Check if clothing layer needs to be updated
  IF _clothing_layer IS NOT NULL THEN
    UPDATE public.items_clothing_basic
    SET
      clothing_layer = COALESCE(_clothing_layer, clothing_layer)
    WHERE item_id = _item_id AND current_owner_id = current_user_id;
  END IF;

  -- Update user_high_freq_stats table
  UPDATE public.user_high_freq_stats
  SET items_edited = items_edited + 1;

  -- Return success response with a custom message
  RETURN json_build_object('status', 'success', 'message', 'You have successfully updated your item.');

END;
$$;

-- Create Function update_shoes_metadata
CREATE OR REPLACE FUNCTION update_shoes_metadata(
  _item_id uuid,
  _item_type text DEFAULT NULL,
  _image_url text DEFAULT NULL,
  _name text DEFAULT NULL,
  _amount_spent numeric DEFAULT NULL,
  _occasion text DEFAULT NULL,
  _season text DEFAULT NULL,
  _colour text DEFAULT NULL,
  _colour_variations text DEFAULT NULL,
  _shoes_type text DEFAULT NULL
)
RETURNS json
SET search_path = ''
LANGUAGE plpgsql
AS $$
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
  WHERE item_id = _item_id AND current_owner_id = current_user_id;

  -- Check if shoes type needs to be updated
  IF _shoes_type IS NOT NULL THEN
    UPDATE public.items_shoes_basic
    SET
      shoes_type = COALESCE(_shoes_type, shoes_type)
    WHERE item_id = _item_id AND current_owner_id = current_user_id;
  END IF;

  -- Update user_high_freq_stats table
  UPDATE public.user_high_freq_stats
  SET items_edited = items_edited + 1;

  -- Return success response with a custom message
  RETURN json_build_object('status', 'success', 'message', 'You have successfully updated your item.');

END;
$$;
