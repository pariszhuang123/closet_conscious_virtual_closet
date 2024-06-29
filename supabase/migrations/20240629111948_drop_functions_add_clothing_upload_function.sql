-- Insert upload_clothing_metadata

create OR REPLACE function upload_clothing_metadata(
  _item_type text,
  _image_url text,
  _name text,
  _amount_spent numeric,
  _occasion text,
  _season text,
  _colour text,
  _colour_variations text,
  _clothing_type text,
  _clothing_layer text
)
    returns void
    SET search_path = ''

as $$
declare
  items_item_id uuid;
  current_user_id uuid := auth.uid();
begin
  -- Insert into items table and get the generated item_id
  insert into public.items (item_type, image_url, name, amount_spent, occasion, season, colour, colour_variations)
  values (_item_type, _image_url, _name, _amount_spent, _occasion, _season, _colour, _colour_variations)
  returning item_id into items_item_id;

  -- Insert into items_clothing_basic table
  insert into public.items_clothing_basic (item_id, clothing_type, clothing_layer)
  values (items_item_id, _clothing_type, _clothing_layer);

  -- Update user_high_freq_stats table
  update public.user_high_freq_stats
  set items_uploaded = items_uploaded + 1
  where user_id = current_user_id;
end;
$$ language plpgsql;

-- Drop the trigger
DROP TRIGGER IF EXISTS trg_update_item_ownership ON swaps;

-- Drop the function
DROP FUNCTION IF EXISTS update_item_ownership();

-- Drop the function
DROP FUNCTION IF EXISTS upload_item_metadata();
