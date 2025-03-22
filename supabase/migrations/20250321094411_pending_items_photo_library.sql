-- Function to upload_pending_items_metadata with closet_id support
create or replace function public.upload_pending_items_metadata(
  _image_urls text[]  -- ✅ Accepts multiple image URLs as an array
)
returns boolean  -- ✅ Returns true or false
language plpgsql
SET search_path = ''
as $$
declare
  inserted_count int;
  current_user_id uuid := auth.uid();
  closet_id uuid;  -- New variable to store the closet_id
  is_initial_upload boolean;
  item_closet_upload boolean;

begin

  -- Early return if input array is empty
  if array_length(_image_urls, 1) is null or array_length(_image_urls, 1) = 0 then
    return false;
  end if;

  -- Retrieve the closet_id for the closet named 'cc_closet'
  select uc.closet_id
  into closet_id
  from public.user_closets uc
  where uc.user_id = current_user_id
    and uc.closet_name = 'cc_closet'
  limit 1;

  -- Ensure a closet_id was found
  if closet_id is null then
    return false;
  end if;

  -- Determine if this is the first upload
  select not exists (
    select 1
    from public.user_achievements
    where user_id = current_user_id
      and achievement_name = 'closet_uploaded'
  )
  into is_initial_upload;

  -- Set closet_upload flag based on upload type
  -- First-time upload = closet_upload: true
  -- Later uploads = closet_upload: false
  item_closet_upload := is_initial_upload;

  -- Insert items
  insert into public.items (image_url, closet_upload, closet_id, is_pending)
  select unnest(_image_urls), item_closet_upload, closet_id, true;

  -- ✅ Get count of inserted rows
  get diagnostics inserted_count = row_count;

  -- If no items were inserted, return false
      if inserted_count = 0 then
        return false;
  end if;

  -- Update stats
  update public.user_high_freq_stats
  set
    items_uploaded = items_uploaded + array_length(_image_urls, 1),
    updated_at = now(),
    initial_upload_item_count =
      case when is_initial_upload then initial_upload_item_count + array_length(_image_urls, 1)
           else initial_upload_item_count
      end
  where user_id = current_user_id;

  return true;
end;
$$;
