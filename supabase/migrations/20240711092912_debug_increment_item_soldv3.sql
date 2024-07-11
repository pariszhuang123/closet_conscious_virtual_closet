create or replace function public.increment_items_sold(current_item_id uuid)
returns json
language plpgsql
as $$
declare
  current_user_id uuid := auth.uid();
  result json;
  closet_uploaded boolean;
  item_worn_in_outfit int;
begin
    -- Logging function call
    RAISE LOG 'Function increment_items_sold called with item_id: %', current_item_id;

    -- Check if the item exists and fetch closet_uploaded and worn_in_outfit status
    select closet_uploaded, worn_in_outfit into closet_uploaded, item_worn_in_outfit
    from public.items
    where current_owner_id = current_user_id and item_id = current_item_id;

    -- If item does not exist, return failure
    if not found then
        RAISE LOG 'Item does not exist or cannot be sold. item_id: %', current_item_id;
        return json_build_object('status', 'failure', 'message', 'Item does not exist or cannot be sold');
    end if;

    -- Logging item found
    RAISE LOG 'Item existence check - closet_uploaded: %, item_worn_in_outfit: %', closet_uploaded, item_worn_in_outfit;

    -- Update item status to sold and inactive
    update public.items
    set
        sub_status = 'sold',
        status = 'inactive',
        updated_at = now()
    where current_owner_id = current_user_id and item_id = current_item_id;

    -- Logging item status update
    RAISE LOG 'Item status updated to sold and inactive.';

    -- Adjust counts in user_high_freq_stats
    if closet_uploaded then
        update public.user_high_freq_stats
        set
            initial_upload_item_count = initial_upload_item_count - 1,
            initial_upload_items_worn_count = initial_upload_items_worn_count - (case when item_worn_in_outfit > 0 then 1 else 0 end),
            updated_at = now()
        where user_id = current_user_id;

        -- Logging high_freq_stats update
        RAISE LOG 'user_high_freq_stats updated: initial_upload_item_count decremented by 1 and initial_upload_items_worn_count updated';
    end if;

    -- Increment items_sold in user_low_freq_stats
    update public.user_low_freq_stats
    set
        items_sold = items_sold + 1,
        updated_at = now()
    where user_id = current_user_id;

    -- Logging low_freq_stats update
    RAISE LOG 'user_low_freq_stats updated: items_sold incremented by 1';

    result := json_build_object('status', 'success', 'message', 'Item successfully sold');

    return result;

exception
    when others then
        -- Logging any exception that occurs
        RAISE LOG 'An error occurred: %', SQLERRM;

        return json_build_object('status', 'error', 'message', format('An error occurred: %s', SQLERRM));
end;
$$;
