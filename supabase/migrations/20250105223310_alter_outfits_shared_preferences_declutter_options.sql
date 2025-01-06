-- Add column public.outfits.is_active
ALTER TABLE public.outfits
ADD COLUMN is_active BOOLEAN NOT NULL DEFAULT TRUE;
COMMENT ON COLUMN public.outfits.is_active IS 'Indicates whether the outfit is active. The column is false if any items in the outfit are inactive.';

-- Add column public.shared_preferences.event_name
ALTER TABLE public.shared_preferences
ADD COLUMN event_name TEXT NOT NULL DEFAULT 'cc_none';
COMMENT ON COLUMN public.shared_preferences.event_name IS 'Event name filter for outfits. Default "cc_none" is used as placeholder text.';

-- Add column public.shared_preferences.ignore_event_name
ALTER TABLE public.shared_preferences
ADD COLUMN ignore_event_name BOOLEAN NOT NULL DEFAULT TRUE;
COMMENT ON COLUMN public.shared_preferences.ignore_event_name IS 'Determines whether to ignore the event name filter.';

-- Add column public.shared_preferences.feedback
ALTER TABLE public.shared_preferences
ADD COLUMN feedback TEXT NOT NULL DEFAULT 'all';
ALTER TABLE public.shared_preferences
ADD CONSTRAINT feedback_check CHECK (feedback IN ('all', 'like', 'alright', 'dislike'));
COMMENT ON COLUMN public.shared_preferences.feedback IS 'Feedback filter for outfits. "All" means no filter is applied. Other values apply filters based on feedback.';

-- Add column public.shared_preferences.focused_date
ALTER TABLE public.shared_preferences
ADD COLUMN focused_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW();
COMMENT ON COLUMN public.shared_preferences.focused_date IS 'Specifies the date the user is focusing on, particularly for features like the calendar.';

-- Add column public.shared_preferences.is_calendar_selectable
ALTER TABLE public.shared_preferences
ADD COLUMN is_calendar_selectable BOOLEAN NOT NULL DEFAULT FALSE;
COMMENT ON COLUMN public.shared_preferences.is_calendar_selectable IS 'Indicates whether the calendar is in selectable mode for creating multi-closets from selected outfits items.';

-- Add column public.shared_preferences.is_outfit_active
ALTER TABLE public.shared_preferences
ADD COLUMN is_outfit_active TEXT NOT NULL DEFAULT 'all';
ALTER TABLE public.shared_preferences
ADD CONSTRAINT is_outfit_active_check CHECK (is_outfit_active IN ('all', 'active', 'inactive'));
COMMENT ON COLUMN public.shared_preferences.is_outfit_active IS 'Filter for outfit.is_active. "All" means no filter is applied, while "active" or "inactive" filters based on the outfit active status.';

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
    where outfit_id in (
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
    where outfit_id in (
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
    where outfit_id in (
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
    where outfit_id in (
        select outfit_id
        from public.outfit_items
        where item_id = current_item_id
    );

    return json_build_object('status', 'success');
end;
$$;
