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
begin

  -- Explicitly set _colour_variations to 'cc_none' if it is NULL
  if _colour_variations is null then
    _colour_variations := 'cc_none';
  end if;

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
  where item_id = _item_id;

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
