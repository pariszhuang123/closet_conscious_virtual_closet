CREATE FUNCTION fetch_calendar_metadata()
RETURNS TABLE (
    event_name TEXT,
    ignore_event_name BOOLEAN,
    feedback TEXT,
    focused_date TIMESTAMPTZ,
    is_calendar_selectable BOOLEAN,
    is_outfit_active TEXT
)
SET search_path = ''
LANGUAGE sql
AS $$

DECLARE
    -- Automatically retrieve the current user's ID
    current_user_id UUID := auth.uid();

BEGIN
    SELECT
        event_name,
        ignore_event_name,
        feedback,
        focused_date,
        is_calendar_selectable,
        is_outfit_active
    FROM
        public.shared_preferences
    WHERE
        user_id = current_user_id;
END;
$$;

create or replace function save_calendar_metadata(
    new_event_name text,
    new_feedback text,
    new_focused_date timestamptz,
    new_is_calendar_selectable boolean,
    new_is_outfit_active text
)
returns boolean
SET search_path = ''
language plpgsql
as $$
declare
    current_user_id uuid := auth.uid();
begin
    -- Update the shared_preferences row for the authenticated user
    update public.shared_preferences
    set
        event_name = case
                        when new_event_name is null or new_event_name = '' then 'cc_none'
                        else new_event_name
                     end,
        ignore_event_name = (new_event_name is null or new_event_name = ''),
        feedback = coalesce(new_feedback, feedback),
        focused_date = coalesce(new_focused_date, focused_date),
        is_calendar_selectable = coalesce(new_is_calendar_selectable, is_calendar_selectable),
        is_outfit_active = coalesce(new_is_outfit_active, is_outfit_active),
        updated_at = NOW()
    where user_id = current_user_id;

    -- Return TRUE if the update affected rows, FALSE otherwise
    return found;
end;
$$;


CREATE OR REPLACE FUNCTION reset_monthly_calendar()
RETURNS BOOLEAN
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id UUID := auth.uid();
    latest_date TIMESTAMPTZ;
BEGIN
    -- Ensure the current user ID is not NULL
    IF current_user_id IS NULL THEN
        RAISE EXCEPTION 'User not authenticated';
    END IF;

    -- Fetch the latest focused date based on the conditions
    SELECT COALESCE(
        (SELECT created_at
         FROM public.outfits
         WHERE
               reviewed = TRUE AND
               user_id = current_user_id
         ORDER BY created_at DESC
         LIMIT 1),
        (SELECT created_at
         FROM public.shared_preferences
         WHERE user_id = current_user_id)
    )
    INTO latest_date;

    -- Validate the latest_date result
    IF latest_date IS NULL THEN
        RAISE EXCEPTION 'No valid date found for user_id %', current_user_id;
    END IF;

    -- Update shared_preferences with the new values
    UPDATE public.shared_preferences
    SET
        ignore_event_name = TRUE,
        feedback = 'all',
        focused_date = latest_date,
        is_calendar_selectable = FALSE,
        is_outfit_active = 'all',
        updated_at = NOW()
    WHERE user_id = current_user_id;

    -- Check if any rows were updated
    IF NOT FOUND THEN
        RAISE EXCEPTION 'No shared_preferences found for user_id %', current_user_id;
    END IF;

    -- Return TRUE to indicate success
    RETURN TRUE;
END;
$$;

CREATE OR REPLACE FUNCTION fetch_monthly_calendar_images()
RETURNS JSONB
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    f_focused_date DATE;
    start_date DATE;
    end_date DATE;
    current_user_id UUID := auth.uid();
    ignore_event_name BOOLEAN;
    event_name_filter TEXT;
    feedback_filter TEXT;
    is_outfit_active_filter TEXT;
    has_outfits BOOLEAN;
BEGIN
    -- Step 1: Fetch the focused date and filters from shared_preferences
    SELECT
        focused_date,
        ignore_event_name,
        event_name,
        feedback,
        is_outfit_active
    INTO
        f_focused_date,
        ignore_event_name,
        event_name_filter,
        feedback_filter,
        is_outfit_active_filter
    FROM public.shared_preferences
    WHERE user_id = current_user_id;

    -- Step 2: Calculate the date range
    start_date := date_trunc('month', f_focused_date) - INTERVAL '1 day';
    end_date := (date_trunc('month', f_focused_date) + INTERVAL '1 month - 1 day') + INTERVAL '1 day';

    -- Step 3: Check if there are any outfits in the date range
    SELECT EXISTS(
        SELECT 1
        FROM public.outfits o
        WHERE o.reviewed = true
        AND o.user_id = current_user_id
        AND o.created_at BETWEEN start_date AND end_date
        -- Apply event_name filter
        AND (
            ignore_event_name = true
            OR (
                ignore_event_name = false
                AND o.event_name ILIKE event_name_filter
            )
        )
        -- Apply feedback filter
        AND (
            feedback_filter = 'all'
            OR o.feedback = feedback_filter
        )
        -- Apply is_outfit_active filter
        AND (
            is_outfit_active_filter = 'all'
            OR (
                is_outfit_active_filter = 'active' AND o.is_active = true
            )
            OR (
                is_outfit_active_filter = 'inactive' AND o.is_active = false
            )
        )
    ) INTO has_outfits;

    -- Step 4: Return false if no outfits exist
    IF NOT has_outfits THEN
        RETURN JSONB_BUILD_OBJECT('has_outfits', false);
    END IF;

    -- Step 5: Proceed with the existing logic if outfits exist
    RETURN (
        SELECT JSONB_BUILD_OBJECT(
            'has_outfits', true,
            'calendar_data', JSONB_AGG(
                JSONB_BUILD_OBJECT(
                    'date', created_day,
                    'has_multiple_outfits', COUNT(DISTINCT o.outfit_id) > 1,
                    'outfits', JSONB_AGG(
                        JSONB_BUILD_OBJECT(
                            'outfit_id', o.outfit_id,
                            'outfit_image_url', CASE
                                WHEN o.outfit_image_url = 'cc_none' THEN NULL
                                ELSE o.outfit_image_url
                            END,
                            'items', CASE
                                -- Fetch items if outfit_image_url is NULL or 'cc_none'
                                WHEN o.outfit_image_url IS NULL OR o.outfit_image_url = 'cc_none' THEN (
                                    SELECT JSONB_AGG(
                                        JSONB_BUILD_OBJECT(
                                            'item_id', i.item_id,
                                            'item_image_url', i.image_url
                                        )
                                    )
                                    FROM public.outfit_items oi
                                    JOIN public.items i ON oi.item_id = i.item_id
                                    WHERE oi.outfit_id = o.outfit_id
                                )
                                ELSE NULL
                            END
                        )
                    )
                )
            )
        )
        FROM (
            SELECT
                o.*,
                date_trunc('day', o.created_at) AS created_day
            FROM public.outfits o
            WHERE o.reviewed = true
            AND o.user_id = current_user_id
            AND o.created_at BETWEEN start_date AND end_date
            -- Apply event_name filter
            AND (
                ignore_event_name = true
                OR (
                    ignore_event_name = false
                    AND o.event_name ILIKE event_name_filter
                )
            )
            -- Apply feedback filter
            AND (
                feedback_filter = 'all'
                OR o.feedback = feedback_filter
            )
            -- Apply is_outfit_active filter
            AND (
                is_outfit_active_filter = 'all'
                OR (
                    is_outfit_active_filter = 'active' AND o.is_active = true
                )
                OR (
                    is_outfit_active_filter = 'inactive' AND o.is_active = false
                )
            )
        ) o
        GROUP BY created_day
    );
END;
$$;


CREATE OR REPLACE FUNCTION get_active_items_from_calendar(selected_outfit_ids UUID[])
RETURNS UUID[]
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id UUID := auth.uid();
    active_item_ids UUID[];
BEGIN
    -- Ensure the user has access to the outfits
    SELECT ARRAY_AGG(DISTINCT i.item_id)
    INTO active_item_ids
    FROM public.outfit_items oi
    INNER JOIN public.items i ON oi.item_id = i.item_id
    INNER JOIN public.outfits o ON oi.outfit_id = o.outfit_id
    WHERE
        o.user_id = current_user_id AND      -- Ensure the outfits belong to the current user
        i.current_owner_id = current_user_id AND  -- Ensure the items belong to the current user
        oi.outfit_id = ANY(selected_outfit_ids) AND
        i.is_active = true;                  -- Ensure items are active

    RETURN active_item_ids;
END;
$$;

CREATE OR REPLACE FUNCTION fetch_daily_outfits(focused_date DATE)
RETURNS JSONB
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
  current_user_id UUID := auth.uid(); -- Get the current authenticated user's ID
BEGIN
  RETURN (
    SELECT jsonb_agg(
      jsonb_build_object(
        'outfit_id', opd.outfit_id,
        'feedback', opd.feedback,
        'reviewed', opd.reviewed,
        'is_active', opd.is_active,
        'outfit_image_url', opd.outfit_image_url,
        'event_name', opd.event_name,
        'items', COALESCE(
          jsonb_agg(
            jsonb_build_object(
              'item_id', di.item_id,
              'item_image_url', di.item_image_url,
              'item_name', di.item_name,
              'item_is_active', di.item_is_active,
              'disliked', di.disliked
            )
          ) FILTER (WHERE di.item_id IS NOT NULL), '[]' -- Handle NULL items
        )
      )
    )
    FROM (
      SELECT
        o.outfit_id,
        o.feedback,
        o.reviewed,
        o.is_active,
        o.outfit_image_url,
        o.event_name
      FROM
        public.outfits o
      WHERE
        DATE(o.created_at) = focused_date
        AND o.user_id = current_user_id -- Ensure the user owns the outfit
    ) opd
    LEFT JOIN (
      SELECT
        oi.outfit_id,
        i.item_id,
        i.item_image_url,
        i.name AS item_name,
        i.is_active AS item_is_active,
        oi.disliked
      FROM
        public.outfit_items oi
      JOIN
        public.items i
      ON
        oi.item_id = i.item_id
      WHERE
        i.current_owner_id = current_user_id -- Ensure the user owns the items
    ) di
    ON opd.outfit_id = di.outfit_id
    GROUP BY opd.outfit_id, opd.feedback, opd.reviewed, opd.is_active, opd.outfit_image_url, opd.event_name
  );
END;
$$;

create or replace function navigate_calendar(
    direction text -- Accepts 'backward' or 'forward'
)
returns boolean
SET search_path = ''
language plpgsql
as $$
declare
    current_user_id uuid := auth.uid(); -- Store the authenticated user's ID
    current_focused_date date;
    next_date date;
begin
    -- Fetch the current focused date for the user
    select focused_date
    into current_focused_date
    from public.shared_preferences
    where user_id = current_user_id;

    -- Check if the current focused date is null
    if current_focused_date is null then
        return false; -- Cannot navigate without a focused date
    end if;

    -- Build the filtered dataset based on user preferences
    with filtered_outfits as (
        select o.outfit_id, o.event_name, o.feedback, o.is_active, o.outfit_date
        from public.outfits o
        join public.shared_preferences sp on sp.user_id = current_user_id
        where o.outfit_id = sp.outfit_id
          and o.reviewed = true -- Ensure only reviewed outfits are included
          and (
              sp.ignore_event_name = true
              or o.event_name ilike sp.event_name
          )
          and (
              sp.feedback = 'all'
              or o.feedback ilike sp.feedback
          )
          and (
              sp.is_outfit_active = 'all'
              or (sp.is_outfit_active = 'active' and o.is_active = true)
              or (sp.is_outfit_active = 'inactive' and o.is_active = false)
          )
    )
    -- Determine the next date based on the direction
    select
        case
            when direction = 'backward' then max(outfit_date)
            when direction = 'forward' then min(outfit_date)
        end
    into next_date
    from filtered_outfits
    where
        (direction = 'backward' and outfit_date < current_focused_date)
        or (direction = 'forward' and outfit_date > current_focused_date);

    -- If no next date is found, return false
    if next_date is null then
        return false;
    end if;

    -- Update the focused date in shared_preferences
    update public.shared_preferences
    set
      focused_date = next_date,
      updated_at = NOW()
    where user_id = current_user_id;

    return true; -- Navigation successful
end;
$$;
