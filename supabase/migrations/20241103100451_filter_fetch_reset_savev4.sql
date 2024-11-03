ALTER TABLE public.user_closets
ADD COLUMN closet_image TEXT NOT NULL DEFAULT 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/item_pics/cc_none/CC_Logo.png';

COMMENT ON COLUMN public.user_closets.closet_image IS 'URL of the closet image. Defaults to a placeholder logo if no image is provided.';

create or replace function save_default_selection()
returns jsonb
language plpgsql
SET search_path = ''
as $$
declare
    default_closet_id uuid;
    current_user_id uuid := auth.uid();
begin
    -- Retrieve the closet_id from user_closets where closet_name is 'cc_closet' for the authenticated user
    select closet_id into default_closet_id
    from public.user_closets
    where user_id = current_user_id
      and closet_name = 'cc_closet';

    -- Reset the user's preferences to default values
    update public.shared_preferences
    set
        filter = '{}'::jsonb,
        closet_id = default_closet_id,
        all_closet = FALSE,
        item_name = 'cc_none'
    where user_id = current_user_id;

    -- Return the updated values as a single JSON object
    return json_build_object(
        'r_filter', '{}'::jsonb,
        'r_closet_id', default_closet_id,
        'r_all_closet', FALSE,
        'r_item_name', ''
    );
end;
$$;

create or replace function update_filter_settings(
    new_filter jsonb,
    new_closet_id text,
    new_all_closet bool,
    new_item_name text
)
returns jsonb
SET search_path = ''
language plpgsql
as $$
declare
    result jsonb;
    current_user_id uuid := auth.uid();
begin
  -- Update the user_preferences row for the authenticated user
  update public.shared_preferences
  set
      filter = new_filter,
      closet_id = new_closet_id::uuid,
      all_closet = new_all_closet,
      item_name = case
                     when new_item_name is null or new_item_name = '' then 'cc_none'
                     else new_item_name
                  end
  where user_id = current_user_id;

  -- Check if the update was successful
  if found then
    result := jsonb_build_object('status', 'success', 'message', 'Filter settings updated successfully');
  else
    result := jsonb_build_object('status', 'error', 'message', 'Failed to update filter settings');
  end if;

  return result;
end;
$$;

create or replace function fetch_filter_settings()
returns jsonb
language sql
SET search_path = ''
as $$
    select json_build_object(
        'f_filter', filter,
        'f_closet_id', closet_id,
        'f_all_closet', all_closet,
        'f_item_name', case when item_name = 'cc_none' then '' else item_name end
    )
    from public.shared_preferences
    where user_id = auth.uid();
$$;
