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
    is_calendar_selectable BOOLEAN;
BEGIN
    -- Step 1: Fetch the focused date and filters from shared_preferences
    SELECT
        focused_date,
        ignore_event_name,
        event_name,
        feedback,
        is_outfit_active,
        is_calendar_selectable
    INTO
        f_focused_date,
        ignore_event_name,
        event_name_filter,
        feedback_filter,
        is_outfit_active_filter,
        is_calendar_selectable
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
            'is_calendar_selectable', is_calendar_selectable,
            'calendar_data', JSONB_AGG(
                JSONB_BUILD_OBJECT(
                    'date', created_day,
                    'has_multiple_outfits', COUNT(DISTINCT o.outfit_id) > 1,
                    'outfit', JSONB_BUILD_OBJECT(
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
        FROM (
            SELECT DISTINCT ON (date_trunc('day', o.created_at))
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
            ORDER BY date_trunc('day', o.created_at), o.created_at ASC
        ) o
    );
END;
$$;