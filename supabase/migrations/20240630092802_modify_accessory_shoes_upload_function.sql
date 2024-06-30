-- Insert upload_accessory_metadata
create  OR REPLACE function upload_accessory_metadata(
  _item_type text,
  _image_url text,
  _name text,
  _amount_spent numeric,
  _occasion text,
  _season text,
  _colour text,
  _colour_variations text,
  _accessory_type text
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

  -- Insert into items_clothing_accessory table
  insert into public.items_accessory_basic (item_id, accessory_type)
  values (items_item_id, _accessory_type);

  -- Update user_high_freq_stats table
  update public.user_high_freq_stats
  set items_uploaded = items_uploaded + 1
  where user_id = current_user_id;
end;
$$ language plpgsql;

-- Insert upload_shoes_metadata

create OR REPLACE function upload_shoes_metadata(
  _item_type text,
  _image_url text,
  _name text,
  _amount_spent numeric,
  _occasion text,
  _season text,
  _colour text,
  _colour_variations text,
  _shoes_type text
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

  -- Insert into items_shoes_basic table
  insert into public.items_shoes_basic (item_id, shoes_type)
  values (items_item_id, _shoes_type);

  -- Update user_high_freq_stats table
  update public.user_high_freq_stats
  set items_uploaded = items_uploaded + 1
  where user_id = current_user_id;
end;
$$ language plpgsql;
