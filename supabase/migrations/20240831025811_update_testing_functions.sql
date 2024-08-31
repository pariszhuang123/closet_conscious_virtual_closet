-- Increment filter requests
CREATE OR REPLACE FUNCTION increment_filter_request()
RETURNS json
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id uuid := auth.uid();
    result json;
BEGIN
    -- Update the filter request count for the current user
    UPDATE public.user_low_freq_stats
    SET
        filter_request = filter_request + 1,
        updated_at = NOW()
    WHERE user_id = current_user_id;

    -- Check if the update was successful
    IF FOUND THEN
        result := json_build_object('status', 'success', 'message', 'Recorded filtering request');
    ELSE
        result := json_build_object('status', 'failure', 'message', 'Cannot record filtering request');
    END IF;

    RETURN result;
EXCEPTION
    WHEN others THEN
        RETURN json_build_object('status', 'error', 'message', format('An error occurred: %s', SQLERRM));
END;
$$;


-- Increment multi-closet requests
CREATE OR REPLACE FUNCTION increment_multi_closet_request()
RETURNS json
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id uuid := auth.uid();
    result json;
BEGIN
    UPDATE public.user_low_freq_stats
    SET
        multi_closet_request = multi_closet_request + 1,
        updated_at = NOW()
    WHERE user_id = current_user_id;

    -- Check if the update was successful
    IF FOUND THEN
        result := json_build_object('status', 'success', 'message', 'Recorded multi-closet request');
    ELSE
        result := json_build_object('status', 'failure', 'message', 'Cannot record multi-closet request');
    END IF;

    RETURN result;
EXCEPTION
    WHEN others THEN
        RETURN json_build_object('status', 'error', 'message', format('An error occurred: %s', SQLERRM));
END;
$$;


-- Increment analytics requests
CREATE OR REPLACE FUNCTION increment_analytics_request()
RETURNS json
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id uuid := auth.uid();
    result json;
BEGIN
    UPDATE public.user_low_freq_stats
    SET
        analytics_request = analytics_request + 1,
        updated_at = NOW()
    WHERE user_id = current_user_id;

    -- Check if the update was successful
    IF FOUND THEN
        result := json_build_object('status', 'success', 'message', 'Recorded analytics request');
    ELSE
        result := json_build_object('status', 'failure', 'message', 'Cannot record analytics request');
    END IF;

    RETURN result;
EXCEPTION
    WHEN others THEN
        RETURN json_build_object('status', 'error', 'message', format('An error occurred: %s', SQLERRM));
END;
$$;

-- Increment calendar requests
CREATE OR REPLACE FUNCTION increment_calendar_request()
RETURNS json
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id uuid := auth.uid();
    result json;
BEGIN
    -- Update the calendar request count for the current user
    UPDATE public.user_low_freq_stats
    SET
        calendar_request = calendar_request + 1,
        updated_at = NOW()
    WHERE user_id = current_user_id;

    -- Check if the update was successful
    IF FOUND THEN
        result := json_build_object('status', 'success', 'message', 'Recorded calendar request');
    ELSE
        result := json_build_object('status', 'failure', 'message', 'Cannot record calendar request');
    END IF;

    RETURN result;
EXCEPTION
    WHEN others THEN
        RETURN json_build_object('status', 'error', 'message', format('An error occurred: %s', SQLERRM));
END;
$$;


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
    insert into items_accessory_basic (item_id, accessory_type)
    values (items_item_id, _accessory_type);

    -- Update user_high_freq_stats table
    update user_high_freq_stats
    set
        items_uploaded = items_uploaded + 1,
        updated_at = NOW()
    where user_id = current_user_id;

    if _amount_spent > 0 then
      -- Reset no_buy_streak and update new accessory statistics
      update user_high_freq_stats
      set
        no_buy_streak = 0,
        updated_at = NOW()
      where user_id = current_user_id;

      update user_low_freq_stats
      set
        new_items = new_items + 1,
        new_items_value = new_items_value + _amount_spent,
        updated_at = NOW()
      where user_id = current_user_id;
    end if;
  else
    -- Initial upload scenario
    insert into public.items (item_type, image_url, name, amount_spent, occasion, season, colour, colour_variations, closet_upload)
    values (_item_type, _image_url, _name, _amount_spent, _occasion, _season, _colour, _colour_variations, 'true')
    returning item_id into items_item_id;

    insert into items_accessory_basic (item_id, accessory_type)
    values (items_item_id, _accessory_type);

    update user_high_freq_stats
    set
      items_uploaded = items_uploaded + 1,
      initial_upload_item_count = initial_upload_item_count + 1,
      updated_at = NOW()
    where user_id = current_user_id;
  end if;

  -- Return success response with a custom message
  return json_build_object('status', 'success', 'message', 'You have successfully uploaded your item.');
end;
$$;

-- Function to upload_clothing_metadata
create or replace function upload_clothing_metadata(
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

    -- Insert into items_clothing_basic table
    insert into items_clothing_basic (item_id, clothing_type, clothing_layer)
    values (items_item_id, _clothing_type, _clothing_layer);

    -- Update user_high_freq_stats table
    update user_high_freq_stats
    set
        items_uploaded = items_uploaded + 1,
        updated_at = NOW()
    where user_id = current_user_id;

    if _amount_spent > 0 then
      -- Reset no_buy_streak and update new clothes statistics
      update user_high_freq_stats
      set
        no_buy_streak = 0,
        updated_at = NOW()
      where user_id = current_user_id;

      update user_low_freq_stats
      set
        new_items = new_items + 1,
        new_items_value = new_items_value + _amount_spent,
        updated_at = NOW()
      where user_id = current_user_id;
    end if;
  else
    -- Initial upload scenario
    insert into public.items (item_type, image_url, name, amount_spent, occasion, season, colour, colour_variations, closet_upload)
    values (_item_type, _image_url, _name, _amount_spent, _occasion, _season, _colour, _colour_variations, 'true')
    returning item_id into items_item_id;

    insert into items_clothing_basic (item_id, clothing_type, clothing_layer)
    values (items_item_id, _clothing_type, _clothing_layer);

    update user_high_freq_stats
    set
      items_uploaded = items_uploaded + 1,
      initial_upload_item_count = initial_upload_item_count + 1,
      updated_at = NOW()
    where user_id = current_user_id;
  end if;

  -- Return success response with a custom message
  return json_build_object('status', 'success', 'message', 'You have successfully uploaded your item.');
end;
$$;

-- Function for increment_items_thrown
create or replace function public.increment_items_thrown(current_item_id uuid)
returns json
SET search_path = ''
language plpgsql
as $$
declare
  current_user_id uuid := auth.uid();
  result json;
begin
    -- Update item status
    update public.items
    set
        sub_status = 'throw_away',
        status = 'inactive',
        updated_at = now()
    where
        current_owner_id = current_user_id and
        item_id = current_item_id;

    -- Update user high frequency stats if item was uploaded but never worn in an outfit
    update public.user_high_freq_stats
    set
        initial_upload_item_count = initial_upload_item_count - 1,
        updated_at = NOW()
    where
        user_id = current_user_id and
        exists (
            select 1
            from public.items
            where closet_upload = true and worn_in_outfit = 0 and current_owner_id = current_user_id and item_id = current_item_id
        );

    -- Update user high frequency stats if item was uploaded and worn in an outfit
    update public.user_high_freq_stats
    set
        initial_upload_item_count = initial_upload_item_count - 1,
        initial_upload_items_worn_count = initial_upload_items_worn_count - 1,
        updated_at = NOW()
    where
        user_id = current_user_id and
        exists (
            select 1
            from public.items
            where closet_upload = true and worn_in_outfit > 0 and current_owner_id = current_user_id and item_id = current_item_id
        );

    return json_build_object('status', 'success');
end;
$$;


-- Function for increment_items_sold
create or replace function public.increment_items_sold(current_item_id uuid)
returns json
SET search_path = ''
language plpgsql
as $$
declare
  current_user_id uuid := auth.uid();
  result json;
begin
    -- Update item status
    update public.items
    set
        sub_status = 'sold',
        status = 'inactive',
        updated_at = now()
    where
        current_owner_id = current_user_id and
        item_id = current_item_id;

    -- Update user high frequency stats if item was uploaded but never worn in an outfit
    update public.user_high_freq_stats
    set
        initial_upload_item_count = initial_upload_item_count - 1
    where
        user_id = current_user_id and
        exists (
            select 1
            from public.items
            where closet_upload = true and worn_in_outfit = 0 and current_owner_id = current_user_id and item_id = current_item_id
        );

    -- Update user high frequency stats if item was uploaded and worn in an outfit
    update public.user_high_freq_stats
    set
        initial_upload_item_count = initial_upload_item_count - 1,
        initial_upload_items_worn_count = initial_upload_items_worn_count - 1,
        updated_at = NOW()
    where
        user_id = current_user_id and
        exists (
            select 1
            from public.items
            where closet_upload = true and worn_in_outfit > 0 and current_owner_id = current_user_id and item_id = current_item_id
        );

    -- Update user low frequency stats
    update public.user_low_freq_stats
    set
        items_sold = items_sold + 1,
        updated_at = now()
    where
        user_id = current_user_id;

    return json_build_object('status', 'success');
end;
$$;

-- Function for increment_items_gifted
create or replace function public.increment_items_gifted(current_item_id uuid)
returns json
SET search_path = ''
language plpgsql
as $$
declare
  current_user_id uuid := auth.uid();
  result json;
begin
    -- Update item status
    update public.items
    set
        sub_status = 'gift',
        status = 'inactive',
        updated_at = now()
    where
        current_owner_id = current_user_id and
        item_id = current_item_id;

    -- Update user high frequency stats if item was uploaded but never worn in an outfit
    update public.user_high_freq_stats
    set
        initial_upload_item_count = initial_upload_item_count - 1,
        updated_at = NOW()
    where
        user_id = current_user_id and
        exists (
            select 1
            from public.items
            where closet_upload = true and worn_in_outfit = 0 and current_owner_id = current_user_id and item_id = current_item_id
        );

    -- Update user high frequency stats if item was uploaded and worn in an outfit
    update public.user_high_freq_stats
    set
        initial_upload_item_count = initial_upload_item_count - 1,
        initial_upload_items_worn_count = initial_upload_items_worn_count - 1,
        updated_at = NOW()
    where
        user_id = current_user_id and
        exists (
            select 1
            from public.items
            where closet_upload = true and worn_in_outfit > 0 and current_owner_id = current_user_id and item_id = current_item_id
        );

    -- Update user low frequency stats
    update public.user_low_freq_stats
    set
        items_gifted = items_gifted + 1,
        updated_at = now()
    where
        user_id = current_user_id;

    return json_build_object('status', 'success');
end;
$$;

-- Function for items_swapped
create or replace function public.increment_items_swapped(current_item_id uuid)
returns json
SET search_path = ''
language plpgsql
as $$
declare
  current_user_id uuid := auth.uid();
  result json;
begin
    -- Update item status
    update public.items
    set
        sub_status = 'swap',
        status = 'inactive',
        updated_at = now()
    where
        current_owner_id = current_user_id and
        item_id = current_item_id;

    -- Update user high frequency stats if item was uploaded but never worn in an outfit
    update public.user_high_freq_stats
    set
        initial_upload_item_count = initial_upload_item_count - 1,
        updated_at = NOW()
    where
        user_id = current_user_id and
        exists (
            select 1
            from public.items
            where closet_upload = true and worn_in_outfit = 0 and current_owner_id = current_user_id and item_id = current_item_id
        );

    -- Update user high frequency stats if item was uploaded and worn in an outfit
    update public.user_high_freq_stats
    set
        initial_upload_item_count = initial_upload_item_count - 1,
        initial_upload_items_worn_count = initial_upload_items_worn_count - 1,
        updated_at = NOW()
    where
        user_id = current_user_id and
        exists (
            select 1
            from public.items
            where closet_upload = true and worn_in_outfit > 0 and current_owner_id = current_user_id and item_id = current_item_id
        );

    -- Update user low frequency stats
    update public.user_low_freq_stats
    set
        items_swapped = items_swapped + 1,
        updated_at = now()
    where
        user_id = current_user_id;

    return json_build_object('status', 'success');
end;
$$;
