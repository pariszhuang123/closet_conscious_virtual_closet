create or replace function get_outfit_usage_analytics()
returns table (
    total_reviews int,
    like_percentage numeric,
    alright_percentage numeric,
    dislike_percentage numeric,
    status text,
    days_tracked int,
    closet_shown text,
    user_feedback text
)
language plpgsql
SET search_path = ''
as $$
declare
    current_user_id uuid := auth.uid();
    first_reviewed_outfit_date timestamp;
    user_all_closet boolean;
    user_closet_id uuid;
    user_closet_name text;
    user_feedback text;
begin
    -- Get the first reviewed outfit's creation date
    select min(created_at)
    into first_reviewed_outfit_date
    from public.outfits
    where user_id = current_user_id
      and reviewed = TRUE;

    -- EARLY EXIT if no reviewed outfit exists
    if first_reviewed_outfit_date is null then
        return query
        select 0, 0.0, 0.0, 0.0, 'no reviewed outfit', 0, 'allClosetShown', user_feedback;
        return;
    end if;

    -- Update 'all' feedback to 'like' in public.shared_preferences
    update public.shared_preferences
    set feedback = 'like', updated_at = NOW()
    where user_id = current_user_id and feedback = 'all';

    -- Get the user's closet filtering preferences
    select all_closet, closet_id, feedback
    into user_all_closet, user_closet_id, user_feedback
    from public.shared_preferences
    where user_id = current_user_id;

    -- Get closet name if filtering
    if user_all_closet = FALSE then
        select closet_name into user_closet_name
        from public.user_closets
        where closet_id = user_closet_id;
    end if;

    -- 🚀 OPTIMIZATION: If all_closet = TRUE, skip filtering logic
    if user_all_closet = TRUE then
        return query
        (
            with reviewed_outfits as (
                select feedback
                from public.outfits
                where user_id = current_user_id
                  and reviewed = TRUE
                  and created_at >=
                    case
                        when first_reviewed_outfit_date <= NOW() - INTERVAL '60 days'
                        then NOW() - INTERVAL '60 days'
                        else first_reviewed_outfit_date
                    end
            )
            select
                count(*)::int as total_reviews,
                coalesce(100.0 * sum(case when feedback = 'like' then 1 else 0 end) / count(*), 0.0) as like_percentage,
                coalesce(100.0 * sum(case when feedback = 'alright' then 1 else 0 end) / count(*), 0.0) as alright_percentage,
                coalesce(100.0 * sum(case when feedback = 'dislike' then 1 else 0 end) / count(*), 0.0) as dislike_percentage,
                'data available' as status,
                case
                    when first_reviewed_outfit_date <= NOW() - INTERVAL '60 days'
                    then 60
                    else extract(day from NOW() - first_reviewed_outfit_date)::int
                end as days_tracked,
               'allClosetShown' as closet_shown,
                user_feedback
            from reviewed_outfits
        );

    else
        -- 1️⃣ Get valid outfit IDs based on closet filtering
        return query
        with filtered_outfits as (
            select o.outfit_id
            from public.outfits o
            join public.outfit_items oi on o.outfit_id = oi.outfit_id
            join public.items i on oi.item_id = i.item_id
            where o.user_id = current_user_id
              and o.reviewed = TRUE
              and i.is_active = TRUE
            group by o.outfit_id
            having bool_and(i.closet_id = user_closet_id)  -- Ensures *every* item is from this closet
        ),
        first_review_date as (
            select min(o.created_at) as first_date
            from public.outfits o
            join filtered_outfits f on o.outfit_id = f.outfit_id
        )
        select
            count(*)::int as total_reviews,
            coalesce(100.0 * sum(case when feedback = 'like' then 1 else 0 end) / count(*), 0.0) as like_percentage,
            coalesce(100.0 * sum(case when feedback = 'alright' then 1 else 0 end) / count(*), 0.0) as alright_percentage,
            coalesce(100.0 * sum(case when feedback = 'dislike' then 1 else 0 end) / count(*), 0.0) as dislike_percentage,
            'filtered data available' as status,
            CASE
              WHEN (SELECT first_date FROM first_review_date) IS NOT NULL THEN
                  -- Normal logic using the filtered earliest date
                  CASE
                    WHEN (SELECT first_date FROM first_review_date) <= NOW() - INTERVAL '60 days'
                         THEN 60
                    ELSE EXTRACT(DAY FROM NOW() - (SELECT first_date FROM first_review_date))::int
                  END
              ELSE
                  -- Fallback: use the global earliest date if filter returned none
                  CASE
                    WHEN first_reviewed_outfit_date <= NOW() - INTERVAL '60 days'
                         THEN 60
                    ELSE EXTRACT(DAY FROM NOW() - first_reviewed_outfit_date)::int
                  END
            END as days_tracked,
            user_closet_name as closet_shown,  -- ✅ Showing closet name if filtering by a specific closet
            user_feedback
        from public.outfits o
        join filtered_outfits f on o.outfit_id = f.outfit_id
        where o.created_at >=
            case
                when (select first_date from first_review_date) <= NOW() - INTERVAL '60 days'
                then NOW() - INTERVAL '60 days'
                else (select first_date from first_review_date)
            end;
    end if;
end;
$$;

CREATE OR REPLACE FUNCTION get_filtered_outfits(
    p_current_page INT
)
RETURNS JSONB
LANGUAGE plpgsql
SET search_path = ''
AS $$
DECLARE
    current_user_id UUID := auth.uid();
    result JSONB;
    items_per_page INT;
    offset_val INT;
    user_all_closet BOOLEAN;
    user_closet_id UUID;
    user_feedback TEXT;
    total_user_outfits INT;     -- For checking if user has any outfits
    total_filtered_outfits INT; -- For checking outfits after filter
BEGIN
    -- 1) Check if the user has *any* outfits (unfiltered)
    SELECT COUNT(*)
    INTO total_user_outfits
    FROM public.outfits
    WHERE user_id = current_user_id;

    IF total_user_outfits = 0 THEN
        RETURN JSONB_BUILD_OBJECT(
            'status', 'no_user_outfits'
        );
    END IF;

    -- Retrieve items per page from user preferences
    SELECT FLOOR(grid * 1.5 * grid)::INT
    INTO items_per_page
    FROM public.shared_preferences sp
    WHERE sp.user_id = current_user_id;

    offset_val := p_current_page * items_per_page;

    -- Get user's filtering preferences
    SELECT all_closet, closet_id,
           CASE WHEN feedback = 'all' THEN 'like' ELSE feedback END AS user_feedback
    INTO user_all_closet, user_closet_id, user_feedback
    FROM public.shared_preferences
    WHERE user_id = current_user_id;

    ------------------------------------------------------------------------------
    -- 2) Create temporary table for filtered outfits (ensuring distinct outfit IDs)
    ------------------------------------------------------------------------------
    CREATE TEMP TABLE temp_filtered_outfits ON COMMIT DROP AS
    WITH relevant_outfits AS (
        SELECT
            o.outfit_id,
            o.outfit_image_url,
            o.is_active,
            o.created_at,
            i.closet_id
        FROM public.outfits o
        JOIN public.outfit_items oi ON o.outfit_id = oi.outfit_id
        JOIN public.items i       ON oi.item_id   = i.item_id
        WHERE o.user_id = current_user_id
          AND o.reviewed = TRUE
          AND o.feedback = user_feedback
    )
    SELECT
        ro.outfit_id,
        ro.outfit_image_url,
        ro.is_active,
        ro.created_at
    FROM relevant_outfits ro
    GROUP BY ro.outfit_id, ro.outfit_image_url, ro.is_active, ro.created_at
    HAVING (
        user_all_closet
        OR bool_and(ro.closet_id = user_closet_id)
    );

    -- Check if there are any outfits after applying filters
    SELECT COUNT(*) INTO total_filtered_outfits
    FROM temp_filtered_outfits;

    IF total_filtered_outfits = 0 THEN
        -- No outfits match the user’s current filter preferences
        DROP TABLE IF EXISTS temp_filtered_outfits;
        RETURN JSONB_BUILD_OBJECT(
            'status', 'no_filtered_outfits'
        );
    END IF;

    ------------------------------------------------------------------------------
    -- 3) Paginate and build the final JSON
    ------------------------------------------------------------------------------
    /*
       1) We SELECT from temp_filtered_outfits using LIMIT/OFFSET.
       2) For each returned row (1 row per distinct outfit), we embed
          a subquery to fetch the items if outfit_image_url = 'cc_none'.
       3) We ORDER BY created_at DESC to show the newest outfits first.
    */

    SELECT JSONB_BUILD_OBJECT(
        'status', 'success',
        'outfits',
        COALESCE(
            JSONB_AGG(
                JSONB_BUILD_OBJECT(
                    'outfit_id', tfo.outfit_id,
                    'outfit_image_url', tfo.outfit_image_url,
                    'outfit_is_active', tfo.is_active,
                    'created_at', tfo.created_at,  -- Include created_at in the response
                    'items', CASE
                        WHEN tfo.outfit_image_url = 'cc_none' THEN (
                            SELECT JSONB_AGG(
                                JSONB_BUILD_OBJECT(
                                    'item_id', subq.item_id,
                                    'image_url', subq.image_url,
                                    'name', subq.name
                                )
                            )
                            FROM (
                                SELECT i.item_id, i.image_url, i.name
                                FROM public.outfit_items oi
                                JOIN public.items i ON oi.item_id = i.item_id
                                WHERE oi.outfit_id = tfo.outfit_id
                                ORDER BY i.is_active DESC, i.updated_at DESC
                            ) AS subq
                        )
                        ELSE '[]'::JSONB
                    END
                )
            ),
            '[]'::JSONB
        )
    )
    INTO result
    FROM (
        SELECT outfit_id, outfit_image_url, is_active, created_at
        FROM temp_filtered_outfits
        ORDER BY is_active DESC,  created_at DESC  -- Sorting by newest outfits first
        LIMIT items_per_page
        OFFSET offset_val
    ) tfo;

    -- Drop temporary table
    DROP TABLE IF EXISTS temp_filtered_outfits;

    -- Return final JSON result
    RETURN result;
END;
$$;
