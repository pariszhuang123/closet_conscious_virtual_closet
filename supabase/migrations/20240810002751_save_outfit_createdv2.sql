-- Function to increment outfit created and update related stats
CREATE OR REPLACE FUNCTION public.increment_outfit_created()
RETURNS void
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id UUID := auth.uid();
    daily_upload boolean;
    has_closet_uploaded boolean;
BEGIN
    -- Retrieve daily_upload status and check for closet_uploaded achievement in a single query
    SELECT uhfs.daily_upload,
           EXISTS (
               SELECT 1
               FROM public.user_achievements ua
               WHERE ua.user_id = uhfs.user_id
               AND ua.achievement_name = 'closet_uploaded'
           ) AS has_closet_uploaded
    INTO daily_upload, has_closet_uploaded
    FROM public.user_high_freq_stats uhfs
    WHERE uhfs.user_id = current_user_id;

    -- Update the user_high_freq_stats table based on daily_upload and closet_uploaded achievement
    UPDATE public.user_high_freq_stats
    SET
        outfit_created = outfit_created + 1,
        no_buy_streak = CASE WHEN daily_upload IS FALSE AND has_closet_uploaded THEN no_buy_streak + 1 ELSE no_buy_streak END,
        highest_no_buy_streak = CASE WHEN daily_upload IS FALSE AND has_closet_uploaded THEN GREATEST(no_buy_streak + 1, highest_no_buy_streak) ELSE highest_no_buy_streak END,
        daily_upload = TRUE,
        updated_at = NOW()
    WHERE user_id = current_user_id;
END;
$$;

-- Function to increment usage of items and update item stats
CREATE OR REPLACE FUNCTION public.increment_items_usage(p_selected_items UUID[])
RETURNS void
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id UUID := auth.uid();
BEGIN
    -- Update worn_in_outfit and item_last_worn fields for selected items
    UPDATE public.items
    SET worn_in_outfit = worn_in_outfit + 1,
        item_last_worn = NOW(),
        updated_at = NOW()
    WHERE item_id = ANY(p_selected_items);

    -- Update initial_upload_items_worn_count for the user
    UPDATE public.user_high_freq_stats
    SET
        initial_upload_items_worn_count = initial_upload_items_worn_count + (
            SELECT COUNT(*)
            FROM public.items
            WHERE item_id = ANY(p_selected_items)
            AND closet_uploaded = true
        ),
        updated_at = NOW()
    WHERE user_id = current_user_id;
END;
$$;

-- Main function to save outfit items and update related stats
CREATE OR REPLACE FUNCTION public.save_outfit_items(p_selected_items UUID[])
RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id UUID := auth.uid();
    new_outfit_id UUID;
    result JSON;
BEGIN
    -- Insert a new outfit and get the generated outfit_id
    INSERT INTO public.outfits (user_id)
    VALUES (current_user_id)
    RETURNING outfit_id INTO new_outfit_id;

    -- Insert selected items into outfit_items table
    INSERT INTO public.outfit_items (outfit_id, item_id)
    SELECT new_outfit_id, unnest(p_selected_items);

    -- Perform increments for outfits created and items usage
    CALL public.increment_outfit_created();
    CALL public.increment_items_usage(p_selected_items);

    -- Return success result
    result := json_build_object(
        'status', 'success',
        'message', 'Outfit items saved and counters updated'
    );

    RETURN result;

EXCEPTION
    -- Rollback the transaction in case of any error
    WHEN OTHERS THEN
        result := json_build_object(
            'status', 'error',
            'message', SQLERRM
        );
        RETURN result;
END;
$$;
