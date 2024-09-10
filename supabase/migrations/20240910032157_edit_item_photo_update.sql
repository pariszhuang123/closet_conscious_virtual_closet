-- Function to update_edit_item_photo
CREATE OR REPLACE FUNCTION public.update_item_photo(
  _image_url text,
  _item_id uuid
)
RETURNS json
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
  current_user_id uuid := auth.uid();
BEGIN
    -- Update the outfits table
    UPDATE public.items
    SET
        image_url = _image_url,
        updated_at = NOW()
    WHERE item_id = _item_id AND user_id = current_user_id;

    -- Update user_high_freq_stats table
    UPDATE public.user_high_freq_stats
    SET
        items_edited = items_edited + 1,
        updated_at = NOW()
    WHERE user_id = current_user_id;

    -- Return success response with a custom message
    RETURN json_build_object('status', 'success', 'message', 'You have successfully edited your item photo.');
END;
$$;

