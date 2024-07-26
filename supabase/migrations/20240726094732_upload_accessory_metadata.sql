-- Function to upload_accessory_metadata
create or replace function upload_accessory_metadata(
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
returns json
SET search_path = ''
language plpgsql
as $$
declare
  items_item_id uuid;
  current_user_id uuid := auth.uid();
begin
  -- Check if user has the 'closet_uploaded' achievement and handle accordingly
  if exists(select 1 from public.user_achievements where user_id = current_user_id and achievement_name = 'closet_uploaded') then
    -- Insert into items table and get the generated item_id
    insert into public.items (item_type, image_url, name, amount_spent, occasion, season, colour, colour_variations, closet_upload)
    values (_item_type, _image_url, _name, _amount_spent, _occasion, _season, _colour, _colour_variations, 'false')
    returning item_id into items_item_id;

    -- Insert into items_accessory_basic table
    insert into public.items_accessory_basic (item_id, accessory_type)
    values (items_item_id, _accessory_type);

    -- Update user_high_freq_stats table
    update public.user_high_freq_stats
    set items_uploaded = items_uploaded + 1
    where user_id = current_user_id;

    if _amount_spent > 0 then
      -- Reset no_buy_streak and update new accessory statistics
      update public.user_high_freq_stats
      set no_buy_streak = 0
      where user_id = current_user_id;

      update public.user_low_freq_stats
      set
        new_items = new_items + 1,
        new_items_value = new_items_value + _amount_spent
      where user_id = current_user_id;
    end if;
  else
    -- Initial upload scenario
    insert into public.items (item_type, image_url, name, amount_spent, occasion, season, colour, colour_variations, closet_upload)
    values (_item_type, _image_url, _name, _amount_spent, _occasion, _season, _colour, _colour_variations, 'true')
    returning item_id into items_item_id;

    insert into public.items_accessory_basic (item_id, accessory_type)
    values (items_item_id, _accessory_type);

    update public.user_high_freq_stats
    set
      items_uploaded = items_uploaded + 1,
      initial_upload_item_count = initial_upload_item_count + 1
    where user_id = current_user_id;
  end if;

  -- Return success response with a custom message
  return json_build_object('status', 'success', 'message', 'You have successfully uploaded your item.');
end;
$$;