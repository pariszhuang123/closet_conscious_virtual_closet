create or replace function public.increment_items_sold(current_item_id uuid)
returns json
SET search_path = ''
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

    -- Logging item existence check
    RAISE LOG 'Item existence check - found: %, closet_uploaded: %, item_worn_in_outfit: %', found, closet_uploaded, item_worn_in_outfit;

    if found then
        -- Logging item found
        RAISE LOG 'Item found. Updating item status.';

        -- Update item status to sold and inactive
        update public.items
        set
            sub_status = 'sold',
            status = 'inactive',
            updated_at = now()
        where current_owner_id = current_user_id and item_id = current_item_id;

        -- Logging item status update
        RAISE LOG 'Item status updated to sold and inactive.';

        if closet_uploaded then
            if item_worn_in_outfit = 0 then
                -- Logging high_freq_stats update condition
                RAISE LOG 'Updating user_high_freq_stats for closet_uploaded = true and item_worn_in_outfit = 0';

                -- Adjust counts in user_high_freq_stats when items.worn_in_outfit = 0
                update public.user_high_freq_stats
                set
                    initial_upload_item_count = initial_upload_item_count - 1,
                    updated_at = now()
                where user_id = current_user_id;

                -- Logging high_freq_stats update
                RAISE LOG 'user_high_freq_stats updated: initial_upload_item_count decremented by 1';
            else
                -- Logging high_freq_stats update condition
                RAISE LOG 'Updating user_high_freq_stats for closet_uploaded = true and item_worn_in_outfit > 0';

                -- Adjust counts in user_high_freq_stats when items.worn_in_outfit > 0
                update public.user_high_freq_stats
                set
                    initial_upload_item_count = initial_upload_item_count - 1,
                    initial_upload_items_worn_count = initial_upload_items_worn_count - 1,
                    updated_at = now()
                where user_id = current_user_id;

                -- Logging high_freq_stats update
                RAISE LOG 'user_high_freq_stats updated: initial_upload_item_count and initial_upload_items_worn_count decremented by 1';
            end if;
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
    else
        -- Logging item not found or cannot be sold
        RAISE LOG 'Item does not exist or cannot be sold. item_id: %', current_item_id;

        result := json_build_object('status', 'failure', 'message', 'Item does not exist or cannot be sold');
    end if;

    return result;

exception
    when others then
        -- Logging any exception that occurs
        RAISE LOG 'An error occurred: %', SQLERRM;

        return json_build_object('status', 'error', 'message', format('An error occurred: %s', SQLERRM));
end;
$$;
