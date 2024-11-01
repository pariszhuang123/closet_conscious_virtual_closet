create or replace function save_default_selection()
returns table(
    r_filter jsonb,
    r_closet_id text,
    r_all_closet bool,
    r_ignore_item_name bool
)
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
        ignore_item_name = TRUE
    where user_id = current_user_id
    returning filter, closet_id, all_closet, ignore_item_name
    into r_filter, r_closet_id, r_all_closet, r_ignore_item_name;

    return;
end;
$$ language plpgsql;

create or replace function update_filter_settings(
    new_filter jsonb,
    new_closet_id text,
    new_all_closet bool,
    new_ignore_item_name bool,
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
      closet_id = new_closet_id,
      all_closet = new_all_closet,
      ignore_item_name = new_ignore_item_name,
      item_name = new_item_name
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
returns table(
    f_filter jsonb,
    f_closet_id text,
    f_all_closet bool,
    f_ignore_item_name bool,
    f_item_name text
)
language sql
SET search_path = ''
as $$
    select
        filter,
        closet_id,
        all_closet,
        ignore_item_name,
        item_name
    from public.shared_preferences
    where user_id = auth.uid();
$$;
