CREATE OR REPLACE FUNCTION get_active_items_from_calendar(selected_outfit_ids UUID[])
RETURNS UUID[]
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id UUID := auth.uid();
    active_item_ids UUID[];
BEGIN
    -- Update shared_preferences for the current user
    UPDATE public.shared_preferences
    SET
        all_closets = TRUE,
        sort = 'updated_at',
        sort_order = 'DESC',
        updated_at = NOW()
    WHERE user_id = current_user_id;

    -- Retrieve active item IDs
    SELECT ARRAY_AGG(DISTINCT i.item_id)
    INTO active_item_ids
    FROM public.outfit_items oi
    INNER JOIN public.items i ON oi.item_id = i.item_id
    INNER JOIN public.outfits o ON oi.outfit_id = o.outfit_id
    WHERE
        o.user_id = current_user_id AND
        i.current_owner_id = current_user_id AND
        oi.outfit_id = ANY(selected_outfit_ids) AND
        i.is_active = TRUE;

    -- Update `updated_at` in public.items for retrieved items
    UPDATE public.items
    SET updated_at = NOW()
    WHERE item_id = ANY(active_item_ids)
    AND current_owner_id = current_user_id;

    RETURN active_item_ids;
END;
$$;

-- Drop the fetch_calendar_metadata function
DROP FUNCTION IF EXISTS fetch_daily_outfits(focused_date DATE);

CREATE OR REPLACE FUNCTION fetch_daily_outfits()
RETURNS JSONB
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id UUID := auth.uid();
    f_focused_date DATE;
    has_previous_outfits BOOLEAN;
    has_next_outfits BOOLEAN;
    f_ignore_event_name BOOLEAN;
    f_event_name_filter TEXT;
    f_feedback_filter TEXT;
    f_is_outfit_active_filter TEXT;
    result JSONB;
BEGIN
    ----------------------------------------------------------------------------
    -- Step 1: Fetch the focused date and user preferences from shared_preferences
    ----------------------------------------------------------------------------
    SELECT
        sp.focused_date,
        sp.ignore_event_name,
        sp.event_name,
        sp.feedback,
        sp.is_outfit_active
    INTO f_focused_date, f_ignore_event_name, f_event_name_filter, f_feedback_filter, f_is_outfit_active_filter
    FROM public.shared_preferences sp
    WHERE sp.user_id = current_user_id
    LIMIT 1;

    ----------------------------------------------------------------------------
    -- Step 2: Create a temporary filtered outfits table
    ----------------------------------------------------------------------------
    CREATE TEMP TABLE temp_filtered_outfits AS
    SELECT
        o.*,
        o.created_at::DATE AS created_day,
        o.created_at::DATE = f_focused_date AS has_outfit_on_date
    FROM public.outfits o
    WHERE o.reviewed = true
      AND o.user_id = current_user_id
      AND (
          (NOT f_ignore_event_name AND o.event_name ILIKE f_event_name_filter)
          OR f_ignore_event_name
      )
      AND (
          f_feedback_filter = 'all'
          OR o.feedback = f_feedback_filter
      )
      AND (
          f_is_outfit_active_filter = 'all'
          OR (f_is_outfit_active_filter = 'active' AND o.is_active = true)
          OR (f_is_outfit_active_filter = 'inactive' AND o.is_active = false)
      );

    ----------------------------------------------------------------------------
    -- Step 3: Determine has_previous_outfits and has_next_outfits
    ----------------------------------------------------------------------------
    SELECT
        EXISTS (SELECT 1 FROM temp_filtered_outfits WHERE created_day < f_focused_date LIMIT 1),
        EXISTS (SELECT 1 FROM temp_filtered_outfits WHERE created_day > f_focused_date LIMIT 1)
    INTO has_previous_outfits, has_next_outfits;

    ----------------------------------------------------------------------------
    -- Step 4: Fetch daily outfits using JSON aggregation
    ----------------------------------------------------------------------------
    SELECT JSONB_AGG(
        JSONB_BUILD_OBJECT(
            'outfit_id', opd.outfit_id,
            'feedback', opd.feedback,
            'reviewed', opd.reviewed,
            'is_active', opd.is_active,
            'outfit_image_url', opd.outfit_image_url,
            'event_name', opd.event_name,
            'outfit_comments', opd.outfit_comments,
            'items', COALESCE(
                JSONB_AGG(
                    JSONB_BUILD_OBJECT(
                        'item_id', di.item_id,
                        'item_image_url', di.item_image_url,
                        'item_name', di.item_name,
                        'item_is_active', di.item_is_active,
                        'disliked', di.disliked
                    )
                ) FILTER (WHERE di.item_id IS NOT NULL), '[]'
            )
        )
    )
    INTO result
    FROM (
        SELECT
            o.outfit_id,
            o.feedback,
            o.reviewed,
            o.is_active,
            o.outfit_image_url,
            o.event_name,
            o.outfit_comments
        FROM temp_filtered_outfits o
        WHERE created_day = f_focused_date
        ORDER BY
            CASE
                WHEN o.outfit_id = (SELECT f_outfit_id FROM public.shared_preferences WHERE user_id = current_user_id LIMIT 1) THEN 0
                ELSE 1
            END, o.outfit_id
    ) opd
    LEFT JOIN (
        SELECT
            oi.outfit_id,
            i.item_id,
            i.item_image_url,
            i.name AS item_name,
            i.is_active AS item_is_active,
            oi.disliked
        FROM public.outfit_items oi
        JOIN public.items i
            ON oi.item_id = i.item_id
            WHERE i.current_owner_id = current_user_id
    ) di
    ON opd.outfit_id = di.outfit_id
    GROUP BY opd.outfit_id;

    ----------------------------------------------------------------------------
    -- Step 5: Drop temporary table and return JSON response
    ----------------------------------------------------------------------------
    DROP TABLE IF EXISTS temp_filtered_outfits;

    RETURN JSONB_BUILD_OBJECT(
        'status', 'success',
        'focused_date', f_focused_date,
        'has_previous_outfits', has_previous_outfits,
        'has_next_outfits', has_next_outfits,
        'outfits', result
    );
END;
$$;

CREATE OR REPLACE FUNCTION public.activate_trial_premium_features()
RETURNS BOOLEAN
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    -- Automatically retrieve the current user's ID
    current_user_id UUID := auth.uid();
    v_target_features TEXT[] := ARRAY[
        'com.makinglifeeasie.closetconscious.filter',
        'com.makinglifeeasie.closetconscious.arrange',
        'com.makinglifeeasie.closetconscious.multicloset',
        'com.makinglifeeasie.closetconscious.multipleoutfits',
        'com.makinglifeeasie.closetconscious.calendar'
    ];
    v_one_off_features JSONB;
BEGIN
    -- Check if the user is authenticated
    IF current_user_id IS NULL THEN
        RAISE EXCEPTION 'User not authenticated';
    END IF;

    -- Quick pass: Check if the user is ineligible for update
    IF NOT EXISTS (
        SELECT 1
        FROM public.premium_services
        WHERE user_id = current_user_id
          AND DATE(created_at) = CURRENT_DATE
          AND is_trial = FALSE
    ) THEN
        RETURN FALSE; -- User does not meet the criteria for update
    END IF;

    -- Build the JSONB object for the target features
    v_one_off_features := (
        SELECT jsonb_object_agg(
            u.feature_key,
            jsonb_build_object(
                'acquisition_date', (CURRENT_TIMESTAMP + INTERVAL '30 days')::TEXT,
                'acquisition_method', 'trial'
            )
        )
        FROM (
            SELECT UNNEST(v_target_features) AS feature_key
        ) u
    );

    -- Update the premium_services table
    UPDATE public.premium_services
    SET one_off_features = COALESCE(one_off_features, '{}'::JSONB) || v_one_off_features,
        is_trial = TRUE
    WHERE user_id = current_user_id
      AND is_trial = FALSE
      AND DATE(created_at) = CURRENT_DATE;

    RETURN TRUE; -- Update was successful
END;
$$;

create or replace function check_user_access_to_access_calendar_page()
returns boolean
SET search_path = ''
as $$
declare
    current_user_id uuid := auth.uid();  -- Get the current authenticated user ID
begin
    return (
        select case
            when ps.one_off_features ? 'com.makinglifeeasie.closetconscious.calendar' then true
            else false
        end
        from public.premium_services ps
        where ps.user_id = current_user_id
    );
end;
$$ language plpgsql;
