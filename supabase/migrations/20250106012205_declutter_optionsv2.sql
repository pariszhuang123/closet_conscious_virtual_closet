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
        is_active = false,
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

    -- Deactivate outfits containing gifted item
    update public.outfits
    set is_active = false
    where user_id = current_user_id -- Directly filter by user_id
      and outfit_id in (
          select outfit_id
          from public.outfit_items
          where item_id = current_item_id
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
        is_active = false,
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

    -- Deactivate outfits containing sold item
    update public.outfits
    set is_active = false
    where user_id = current_user_id -- Directly filter by user_id
      and outfit_id in (
          select outfit_id
          from public.outfit_items
          where item_id = current_item_id
      );

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
        is_active = false,
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

    -- Deactivate outfits containing swapped item
    update public.outfits
    set is_active = false
    where user_id = current_user_id -- Directly filter by user_id
      and outfit_id in (
          select outfit_id
          from public.outfit_items
          where item_id = current_item_id
      );

    return json_build_object('status', 'success');
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
        is_active = false,
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

    -- Deactivate outfits containing the thrown item
    update public.outfits
    set is_active = false
    where user_id = current_user_id -- Directly filter by user_id
      and outfit_id in (
          select outfit_id
          from public.outfit_items
          where item_id = current_item_id
      );
    return json_build_object('status', 'success');
end;
$$;
