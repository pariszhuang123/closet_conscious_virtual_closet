-- Function to edit_item_metadata
create or replace function public.edit_item_metadata(
  _item_id uuid,
  _item_type text,
  _name text,
  _amount_spent numeric,
  _occasion text,
  _season text,
  _colour text,
  _clothing_type text,
  _clothing_layer text,
  _accessory_type text,
  _shoes_type text,
  _colour_variations text default 'cc_none'  -- Keep the default here
)
returns json
language plpgsql
SET search_path = ''
as $$
declare
  result json;  -- Declare the variable here
  current_user_id UUID := auth.uid();
begin

  -- Ensure _colour_variations defaults to 'cc_none' if NULL or empty string is passed
  if _colour_variations is null or _colour_variations = '' then
    _colour_variations := 'cc_none';
  end if;

update public.shared_preferences
    set
        sort = 'updated_at',
        sort_order = 'DESC'
    where user_id = current_user_id
    and (sort != 'updated_at' or sort_order != 'DESC');

  -- Update the general items table
  update public.items
  set
    item_type = _item_type,
    name = _name,
    amount_spent = _amount_spent,
    occasion = _occasion,
    season = _season,
    colour = _colour,
    colour_variations = _colour_variations,  -- Now will never be NULL
    updated_at = NOW()
  where item_id = _item_id
    AND current_owner_id = current_user_id;

  -- Handle type-specific updates based on the new item type
  if _item_type = 'clothing' then
    -- Upsert into items_clothing_basic
    insert into public.items_clothing_basic (item_id, clothing_type, clothing_layer)
    values (_item_id, _clothing_type, _clothing_layer)
    on conflict (item_id)
    do update set clothing_type = excluded.clothing_type, clothing_layer = excluded.clothing_layer;

    -- Optional: Clean up previous accessory/shoes-specific data
    delete from public.items_accessory_basic where item_id = _item_id;
    delete from public.items_shoes_basic where item_id = _item_id;

  elsif _item_type = 'accessory' then
    -- Upsert into items_accessory_basic
    insert into public.items_accessory_basic (item_id, accessory_type)
    values (_item_id, _accessory_type)
    on conflict (item_id)
    do update set accessory_type = excluded.accessory_type;

    -- Clean up previous clothing/shoes-specific data
    delete from public.items_clothing_basic where item_id = _item_id;
    delete from public.items_shoes_basic where item_id = _item_id;

  elsif _item_type = 'shoes' then
    -- Upsert into items_shoes_basic
    insert into public.items_shoes_basic (item_id, shoes_type)
    values (_item_id, _shoes_type)
    on conflict (item_id)
    do update set shoes_type = excluded.shoes_type;

    -- Clean up previous clothing/accessory-specific data
    delete from public.items_clothing_basic where item_id = _item_id;
    delete from public.items_accessory_basic where item_id = _item_id;
  end if;

  -- Assign success response
  result := json_build_object(
        'status', 'success'
    );

  -- Return the result
  return result;

exception
  when others then
    -- Handle any errors
    return json_build_object('status', 'error', 'message', SQLERRM);
end;
$$;

-- Function to navigate_to_item_analytics
create or replace function public.navigate_to_item_analytics(
  _item_id uuid
)
returns bool
language plpgsql
SET search_path = ''
as $$
declare
  current_user_id UUID := auth.uid();
begin

update public.shared_preferences
    set
        sort = 'updated_at',
        sort_order = 'DESC'
    where user_id = current_user_id
    and (sort != 'updated_at' or sort_order != 'DESC');

  -- Update the general items table
  update public.items
  set
    updated_at = NOW()
  where item_id = _item_id
    AND current_owner_id = current_user_id;

  -- Return success if at least one row was updated in `items`
  return found;
end;
$$;

-- Function to navigate_to_outfit_analytics
create or replace function public.navigate_to_outfit_analytics(
  _outfit_id uuid
)
returns bool
language plpgsql
SET search_path = ''
as $$
declare
  current_user_id UUID := auth.uid();
  outfit_feedback TEXT;
begin
  -- Retrieve the feedback for the given outfit_id
  select feedback into outfit_feedback
  from public.outfits
  where outfit_id = _outfit_id
    AND user_id = current_user_id;

  -- If the outfit exists, update shared_preferences with the retrieved feedback
  if outfit_feedback is not null then
    update public.shared_preferences
    set
        feedback = outfit_feedback,
        updated_at = NOW()
    where user_id = current_user_id;
  end if;

  -- Update the outfits table timestamp
  update public.outfits
  set
    updated_at = NOW()
  where outfit_id = _outfit_id
    AND user_id = current_user_id;

  -- Return success if at least one row was updated in public.outfits
  return found;
end;
$$;

