-- Function to upload_clothing_metadata
create or replace function public.upload_clothing_metadata(
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
returns json
language plpgsql
SET search_path = ''
as $$
declare
  items_item_id uuid;
  current_user_id uuid := auth.uid();
  reduction_amount constant int := 30;
  previous_milestone int := 0;
  recent_purchase_exists boolean := false;

begin
  -- Check if user has the 'closet_uploaded' achievement and handle accordingly
    select not exists (
      select 1
      from public.items
      where current_owner_id = current_user_id
        and amount_spent > 0
        AND created_at BETWEEN (CURRENT_TIMESTAMP - INTERVAL '25 hours') AND (CURRENT_TIMESTAMP - INTERVAL '1 hour')
      limit 1
    ) into recent_purchase_exists;

  if exists(select 1 from public.user_achievements where user_id = current_user_id and achievement_name = 'closet_uploaded') then

    -- Insert into items table and get the generated item_id
    insert into public.items (item_type, image_url, name, amount_spent, occasion, season, colour, colour_variations, closet_upload)
    values (_item_type, _image_url, _name, _amount_spent, _occasion, _season, _colour, _colour_variations, 'false')
    returning item_id into items_item_id;

    -- Insert into items_clothing_basic table
    insert into public.items_clothing_basic (item_id, clothing_type, clothing_layer)
    values (items_item_id, _clothing_type, _clothing_layer);

    -- Update user_high_freq_stats table
    update public.user_high_freq_stats
    set
        items_uploaded = items_uploaded + 1,
        updated_at = NOW()
    where user_id = current_user_id;

    if _amount_spent > 0 then
      -- Use the previously set variable to check for recent purchases
      if recent_purchase_exists then
        -- Fetch the user's previous milestone from achievements
        select MAX(
          CASE
            WHEN achievement_name = 'no_new_clothes_1575' THEN 1575
            WHEN achievement_name = 'no_new_clothes_1215' THEN 1215
            WHEN achievement_name = 'no_new_clothes_900' THEN 900
            WHEN achievement_name = 'no_new_clothes_630' THEN 630
            WHEN achievement_name = 'no_new_clothes_405' THEN 405
            WHEN achievement_name = 'no_new_clothes_225' THEN 225
            WHEN achievement_name = 'no_new_clothes_90' THEN 90
            ELSE 0
          END
        ) into previous_milestone
        from public.user_achievements
        where user_id = current_user_id;

        -- Reset no_buy_streak by reducing it by 30, but not below the milestone
        update public.user_high_freq_stats
        set
          no_buy_streak = GREATEST(no_buy_streak - reduction_amount, previous_milestone),
          updated_at = NOW()
        where user_id = current_user_id;

        -- Update new items statistics in the low frequency table
        update public.user_low_freq_stats
        set
          new_items = new_items + 1,
          new_items_value = new_items_value + _amount_spent,
          updated_at = NOW()
        where user_id = current_user_id;
      end if;

    end if;

  else
    -- Initial upload scenario
    insert into public.items (item_type, image_url, name, amount_spent, occasion, season, colour, colour_variations, closet_upload)
    values (_item_type, _image_url, _name, _amount_spent, _occasion, _season, _colour, _colour_variations, 'true')
    returning item_id into items_item_id;

    insert into public.items_clothing_basic (item_id, clothing_type, clothing_layer)
    values (items_item_id, _clothing_type, _clothing_layer);

    update public.user_high_freq_stats
    set
      items_uploaded = items_uploaded + 1,
      initial_upload_item_count = initial_upload_item_count + 1,
      updated_at = NOW()
    where user_id = current_user_id;
  end if;

  -- Return success response
  return json_build_object(
    'status', 'success',
    'item_id', items_item_id,
    'message', 'Clothing metadata uploaded successfully'
  );

end;
$$;

create or replace function public.upload_accessory_metadata(
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
language plpgsql
SET search_path = ''
as $$
declare
  items_item_id uuid;
  current_user_id uuid := auth.uid();
  reduction_amount constant int := 30;
  previous_milestone int := 0;
  recent_purchase_exists boolean := false;
begin
  -- Check if user has the 'closet_uploaded' achievement and handle accordingly
    select not exists (
      select 1
      from public.items
      where current_owner_id = current_user_id
        and amount_spent > 0
        AND created_at BETWEEN (CURRENT_TIMESTAMP - INTERVAL '25 hours') AND (CURRENT_TIMESTAMP - INTERVAL '1 hour')
      limit 1
    ) into recent_purchase_exists;

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
    set
        items_uploaded = items_uploaded + 1,
        updated_at = NOW()
    where user_id = current_user_id;

    if _amount_spent > 0 then
      -- Use the previously set variable to check for recent purchases
      if recent_purchase_exists then
        -- Fetch the user's previous milestone from achievements
        select MAX(
          CASE
            WHEN achievement_name = 'no_new_clothes_1575' THEN 1575
            WHEN achievement_name = 'no_new_clothes_1215' THEN 1215
            WHEN achievement_name = 'no_new_clothes_900' THEN 900
            WHEN achievement_name = 'no_new_clothes_630' THEN 630
            WHEN achievement_name = 'no_new_clothes_405' THEN 405
            WHEN achievement_name = 'no_new_clothes_225' THEN 225
            WHEN achievement_name = 'no_new_clothes_90' THEN 90
            ELSE 0
          END
        ) into previous_milestone
        from public.user_achievements
        where user_id = current_user_id;

        -- Reset no_buy_streak by reducing it by 30, but not below the milestone
        update public.user_high_freq_stats
        set
          no_buy_streak = GREATEST(no_buy_streak - reduction_amount, previous_milestone),
          updated_at = NOW()
        where user_id = current_user_id;

        -- Update new items statistics in the low frequency table
        update public.user_low_freq_stats
        set
          new_items = new_items + 1,
          new_items_value = new_items_value + _amount_spent,
          updated_at = NOW()
        where user_id = current_user_id;
      end if;
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
      initial_upload_item_count = initial_upload_item_count + 1,
      updated_at = NOW()
    where user_id = current_user_id;
  end if;

  -- Return success response
  return json_build_object('status', 'success', 'message', 'You have successfully uploaded your accessory.');
end;
$$;

create or replace function public.upload_shoes_metadata(
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
returns json
language plpgsql
SET search_path = ''
as $$
declare
  items_item_id uuid;
  current_user_id uuid := auth.uid();
  reduction_amount constant int := 30;
  previous_milestone int := 0;
  recent_purchase_exists boolean := false;
begin
  -- Check if user has the 'closet_uploaded' achievement and handle accordingly
    select not exists (
      select 1
      from public.items
      where current_owner_id = current_user_id
        and amount_spent > 0
        AND created_at BETWEEN (CURRENT_TIMESTAMP - INTERVAL '25 hours') AND (CURRENT_TIMESTAMP - INTERVAL '1 hour')
      limit 1
    ) into recent_purchase_exists;

  -- Check if user has the 'closet_uploaded' achievement and handle accordingly
  if exists(select 1 from public.user_achievements where user_id = current_user_id and achievement_name = 'closet_uploaded') then
    -- Insert into items table and get the generated item_id
    insert into public.items (item_type, image_url, name, amount_spent, occasion, season, colour, colour_variations, closet_upload)
    values (_item_type, _image_url, _name, _amount_spent, _occasion, _season, _colour, _colour_variations, 'false')
    returning item_id into items_item_id;

    -- Insert into items_shoes_basic table
    insert into public.items_shoes_basic (item_id, shoes_type)
    values (items_item_id, _shoes_type);

    -- Update user_high_freq_stats table
    update public.user_high_freq_stats
    set
        items_uploaded = items_uploaded + 1,
        updated_at = NOW()
    where user_id = current_user_id;

    if _amount_spent > 0 then
      -- Use the previously set variable to check for recent purchases
      if recent_purchase_exists then
        -- Fetch the user's previous milestone from achievements
        select MAX(
          CASE
            WHEN achievement_name = 'no_new_clothes_1575' THEN 1575
            WHEN achievement_name = 'no_new_clothes_1215' THEN 1215
            WHEN achievement_name = 'no_new_clothes_900' THEN 900
            WHEN achievement_name = 'no_new_clothes_630' THEN 630
            WHEN achievement_name = 'no_new_clothes_405' THEN 405
            WHEN achievement_name = 'no_new_clothes_225' THEN 225
            WHEN achievement_name = 'no_new_clothes_90' THEN 90
            ELSE 0
          END
        ) into previous_milestone
        from public.user_achievements
        where user_id = current_user_id;

        -- Reset no_buy_streak by reducing it by 30, but not below the milestone
        update public.user_high_freq_stats
        set
          no_buy_streak = GREATEST(no_buy_streak - reduction_amount, previous_milestone),
          updated_at = NOW()
        where user_id = current_user_id;

        -- Update new items statistics in the low frequency table
        update public.user_low_freq_stats
        set
          new_items = new_items + 1,
          new_items_value = new_items_value + _amount_spent,
          updated_at = NOW()
        where user_id = current_user_id;
      end if;
    end if;

  else
    -- Initial upload scenario
    insert into public.items (item_type, image_url, name, amount_spent, occasion, season, colour, colour_variations, closet_upload)
    values (_item_type, _image_url, _name, _amount_spent, _occasion, _season, _colour, _colour_variations, 'true')
    returning item_id into items_item_id;

    insert into public.items_shoes_basic (item_id, shoes_type)
    values (items_item_id, _shoes_type);

    update public.user_high_freq_stats
    set
      items_uploaded = items_uploaded + 1,
      initial_upload_item_count = initial_upload_item_count + 1,
      updated_at = NOW()
    where user_id = current_user_id;
  end if;

  -- Return success response
  return json_build_object('status', 'success', 'message', 'You have successfully uploaded your shoes.');
end;
$$;
