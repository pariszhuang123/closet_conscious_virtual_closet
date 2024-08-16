-- Increment share requests
CREATE OR REPLACE FUNCTION public.increment_share_request()
RETURNS json
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id uuid := auth.uid();
    result json;
BEGIN
    -- Update the calendar request count for the current user
    UPDATE public.user_low_freq_stats
    SET
        share_request = share_request + 1,
        updated_at = NOW()
    WHERE user_id = current_user_id;

    -- Check if the update was successful
    IF FOUND THEN
        result := json_build_object('status', 'success', 'message', 'Recorded share request');
    ELSE
        result := json_build_object('status', 'failure', 'message', 'Cannot record share request');
    END IF;

    RETURN result;
EXCEPTION
    WHEN others THEN
        RETURN json_build_object('status', 'error', 'message', format('An error occurred: %s', SQLERRM));
END;
$$;

-- Function to upload_outfits_selfie
CREATE OR REPLACE FUNCTION public.upload_outfit_selfie(
  _image_url text,
  _outfit_id uuid
)
RETURNS json
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
  current_user_id uuid := auth.uid();
BEGIN
    -- Update the outfits table
    UPDATE public.outfits
    SET
        outfit_image_url = _image_url,
        updated_at = NOW()
    WHERE outfit_id = _outfit_id AND user_id = current_user_id;

    -- Update user_high_freq_stats table
    UPDATE public.user_high_freq_stats
    SET
        selfie_taken = selfie_taken + 1,
        updated_at = NOW()
    WHERE user_id = current_user_id;

    -- Return success response with a custom message
    RETURN json_build_object('status', 'success', 'message', 'You have successfully uploaded your selfie.');
END;
$$;

-- Review Outfit Function
CREATE OR REPLACE FUNCTION public.review_outfit(
  p_outfit_id UUID,
  p_feedback TEXT,
  p_item_ids UUID[], -- Array of item_ids
  p_outfit_comments TEXT DEFAULT 'cc_none' -- Default value to ensure it's never NULL
)
RETURNS JSON
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
  result JSON;
BEGIN
  -- Update the public.outfits table with feedback and comments
  UPDATE public.outfits
  SET
    feedback = p_feedback,
    outfit_comments = COALESCE(p_outfit_comments, 'cc_none'),
    reviewed = true,
    updated_at = NOW()
  WHERE
    outfit_id = p_outfit_id;

  -- Check if the update was successful
  IF NOT FOUND THEN
    RETURN json_build_object('status', 'failure', 'message', 'Outfit update failed');
  END IF;

  -- If feedback is 'alright' or 'dislike', update public.disliked_outfit_items
  IF p_feedback IN ('alright', 'dislike') THEN
    -- First, delete existing disliked items for the outfit (if any)
    IF array_length(p_item_ids, 1) > 0 THEN
      DELETE FROM public.disliked_outfit_items WHERE outfit_id = p_outfit_id;

      -- Then, insert the new disliked items
      INSERT INTO public.disliked_outfit_items (outfit_id, item_id)
      SELECT p_outfit_id, UNNEST(p_item_ids);

      -- Check if the insertion was successful
      IF NOT FOUND THEN
        RETURN json_build_object('status', 'failure', 'message', 'Failed to update disliked outfit items');
      END IF;
    END IF;
  END IF;

  -- If everything is successful
  result := json_build_object('status', 'success', 'message', 'Review updated successfully');
  RETURN result;

EXCEPTION
  WHEN OTHERS THEN
    -- Handle unexpected errors
    RETURN json_build_object('status', 'error', 'message', SQLERRM);
END;
$$;

CREATE OR REPLACE FUNCTION public.fetch_latest_outfit_for_review(feedback TEXT)
RETURNS TABLE(item_id UUID, image_url TEXT, name TEXT)
LANGUAGE plpgsql
SET search_path = ''
AS $$
DECLARE
  current_user_id UUID := auth.uid();
  outfit_image_url TEXT;
  outfit_id UUID;
BEGIN
  -- Fetch the outfit_id and outfit_image_url with the earliest updated_at where reviewed is false for the current user
  SELECT outfit_id, outfit_image_url
  INTO outfit_id, outfit_image_url
  FROM public.outfits
  WHERE reviewed = false
    AND user_id = current_user_id
  ORDER BY updated_at ASC
  LIMIT 1;

  -- Return early if no outfit found
  IF outfit_id IS NULL THEN
    RETURN;
  END IF;

  -- If the outfit has no image, or feedback is 'like'
  IF outfit_image_url = 'cc_none' AND (feedback IS 'pending' OR feedback = 'like') THEN
    RETURN QUERY
    SELECT * FROM public.get_outfit_items(outfit_id);

    RETURN;
  END IF;

  -- If there's an image URL and feedback is 'like'
  IF feedback IS 'pending' OR feedback = 'like' THEN
    RETURN QUERY
    SELECT null::uuid as item_id, outfit_image_url as image_url, null::text as name;
    RETURN;
  END IF;

  -- If feedback is 'alright' or 'dislike', return items using the sub-function
  IF feedback = 'alright' OR feedback = 'dislike' THEN
    RETURN QUERY
    SELECT * FROM public.get_outfit_items(outfit_id);
  END IF;

  -- Default to an empty result if no conditions match
  RETURN QUERY
  SELECT null::uuid as item_id, null::text as image_url, null::text as name
  WHERE false;

EXCEPTION
  WHEN others THEN
    RAISE NOTICE 'Error fetching latest outfit for review: %', SQLERRM;
    RETURN;
END;
$$;
