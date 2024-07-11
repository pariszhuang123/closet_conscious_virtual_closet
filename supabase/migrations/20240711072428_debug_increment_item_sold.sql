create or replace function increment_items_sold(current_item_id uuid)
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
    -- Check if the item exists and fetch closet_uploaded and worn_in_outfit status
    select closet_uploaded, worn_in_outfit into closet_uploaded, item_worn_in_outfit
    from public.items
    where current_owner_id = current_user_id and item_id = current_item_id;

    if found then
        -- Update item status to sold and inactive
        update public.items
        set
            sub_status = 'sold',
            status = 'inactive',
            updated_at = now()
        where current_owner_id = current_user_id and item_id = current_item_id;

        if closet_uploaded then
            if item_worn_in_outfit = 0 then
                -- Debug statement
                RAISE NOTICE 'Updating user_high_freq_stats for closet_uploaded = true and item_worn_in_outfit = 0';

                -- Adjust counts in user_high_freq_stats when items.worn_in_outfit = 0
                update public.user_high_freq_stats
                set
                    initial_upload_item_count = initial_upload_item_count - 1,
                    updated_at = now()
                where user_id = current_user_id;
            else
                -- Debug statement
                RAISE NOTICE 'Updating user_high_freq_stats for closet_uploaded = true and item_worn_in_outfit > 0';

                -- Adjust counts in user_high_freq_stats when items.worn_in_outfit > 0
                update public.user_high_freq_stats
                set
                    initial_upload_item_count = initial_upload_item_count - 1,
                    initial_upload_items_worn_count = initial_upload_items_worn_count - 1,
                    updated_at = now()
                where user_id = current_user_id;
            end if;
        end if;

        -- Increment items_sold in user_low_freq_stats
        update public.user_low_freq_stats
        set
            items_sold = items_sold + 1,
            updated_at = now()
        where user_id = current_user_id;

        result := json_build_object('status', 'success', 'message', 'Item successfully sold');
    else
        result := json_build_object('status', 'failure', 'message', 'Item does not exist or cannot be sold');
    end if;

    return result;

exception
    when others then
        return json_build_object('status', 'error', 'message', format('An error occurred: %s', SQLERRM));
end;
$$;
