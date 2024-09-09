CREATE OR REPLACE FUNCTION fetch_edit_item_details(
    _item_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SET search_path = ''
AS $$
DECLARE
    item_details JSONB;
BEGIN
    -- Fetch the item details from the items table along with its related data
    SELECT jsonb_build_object(
        'item_id', i.item_id,  -- Include item_id in the result
        'image_url', i.image_url,
        'item_type', i.item_type,
        'name', i.name,
        'amount_spent', i.amount_spent,
        'occasion', i.occasion,
        'season', i.season,
        'colour', i.colour,
        'colour_variations', CASE WHEN i.colour_variations = 'cc_none' THEN NULL ELSE i.colour_variations END,
        'updated_at', i.updated_at,
        'clothing_type', icb.clothing_type,
        'clothing_layer', icb.clothing_layer,
        'shoes_type', isb.shoes_type,
        'accessory_type', iab.accessory_type
    )
    INTO item_details
    FROM public.items i
    LEFT JOIN public.items_clothing_basic icb ON i.item_id = icb.item_id
    LEFT JOIN public.items_shoes_basic isb ON i.item_id = isb.item_id
    LEFT JOIN public.items_accessory_basic iab ON i.item_id = iab.item_id
    WHERE i.item_id = _item_id;

    -- Return the fetched item details
    RETURN item_details;

EXCEPTION
    WHEN OTHERS THEN
        -- Return error in JSON format
        RETURN jsonb_build_object('status', 'error', 'message', SQLERRM);

END;
$$;


-- Function to upload_clothing_metadata
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
  _colour_variations text default 'cc_none'
)
returns json
language plpgsql
SET search_path = ''
as $$
declare
  result json;  -- Declare the variable here
begin

  -- Update the general items table
  update public.items
  set
    item_type = _item_type,
    name = _name,
    amount_spent = _amount_spent,
    occasion = _occasion,
    season = _season,
    colour_variations = _colour_variations,
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
  -- Return success response with a custom message
    result := json_build_object(
        'status', 'success'
    );
exception
  when others then
    -- Handle any errors
    return json_build_object('status', 'error', 'message', SQLERRM);
end;
$$;
