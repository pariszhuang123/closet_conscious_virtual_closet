-- Function to increment outfits created and update no-buy streaks
CREATE OR REPLACE FUNCTION increment_outfit_created(current_user_id UUID)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE public.user_high_freq_stats
  SET outfits_created = outfits_created + 1,
      no_buy_streak = no_buy_streak + 1,
      highest_no_buy_streak = GREATEST(no_buy_streak + 1, highest_no_buy_streak)
  WHERE user_id = current_user_id;
END;
$$;

-- Function to increment usage of items and update item stats
CREATE OR REPLACE FUNCTION increment_items_usage(p_selected_items UUID[])
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
  -- Update worn_in_outfit and item_last_worn fields for selected items
  UPDATE public.items
  SET worn_in_outfit = worn_in_outfit + 1,
      item_last_worn = NOW()
  WHERE item_id = ANY(p_selected_items);

  -- Update initial_upload_items_worn_count for the user
  UPDATE public.user_high_freq_stats
  SET initial_upload_items_worn_count = initial_upload_items_worn_count + (
    SELECT COUNT(*)
    FROM public.items
    WHERE item_id = ANY(p_selected_items)
      AND closet_uploaded = true
  )
  WHERE user_id = auth.uid();
END;
$$;

-- Main function to save outfit items and update related stats
CREATE OR REPLACE FUNCTION save_outfit_items(p_selected_items UUID[])
RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
  current_user_id UUID := auth.uid();
  new_outfit_id UUID;
  result JSON;
BEGIN
  -- Start a transaction
  BEGIN TRANSACTION;

  -- Insert a new outfit and get the generated outfit_id
  INSERT INTO public.outfits (user_id)
  VALUES (current_user_id)
  RETURNING outfit_id INTO new_outfit_id;

  -- Insert selected items into outfit_items table
  INSERT INTO public.outfit_items (outfit_id, item_id)
  SELECT new_outfit_id, unnest(p_selected_items);

  -- Perform increments for outfits created and items usage
  PERFORM increment_outfit_created(current_user_id);
  PERFORM increment_items_usage(p_selected_items);

  -- Commit the transaction
  COMMIT;

  -- Return success result
  result := json_build_object(
    'status', 'success',
    'message', 'Outfit items saved and counters updated'
  );

  RETURN result;

EXCEPTION
  -- Rollback the transaction in case of any error
  WHEN OTHERS THEN
    ROLLBACK;
    result := json_build_object(
      'status', 'error',
      'message', SQLERRM
    );
    RETURN result;
END;
$$;
