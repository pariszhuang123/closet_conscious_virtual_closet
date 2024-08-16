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
    RAISE NOTICE 'Exiting: No outfit found';
    RETURN;
  END IF;

  -- If the outfit has no image, or feedback is 'like'
  IF outfit_image_url = 'cc_none' AND (feedback = 'pending' OR feedback = 'like') THEN
    RAISE NOTICE 'Exiting: No image or feedback is like/pending, fetching outfit items';
    RETURN QUERY
    SELECT * FROM public.get_outfit_items(outfit_id);

    RETURN;
  END IF;

  -- If there's an image URL and feedback is 'like'
  IF feedback = 'pending' OR feedback = 'like' THEN
    RAISE NOTICE 'Exiting: Feedback is like/pending, returning image URL';
    RETURN QUERY
    SELECT null::uuid as item_id, outfit_image_url as image_url, null::text as name;
    RETURN;
  END IF;

  -- If feedback is 'alright' or 'dislike', return items using the sub-function
  IF feedback = 'alright' OR feedback = 'dislike' THEN
    RAISE NOTICE 'Exiting: Feedback is alright/dislike, fetching outfit items';
    RETURN QUERY
    SELECT * FROM public.get_outfit_items(outfit_id);
  END IF;

  -- Default to an empty result if no conditions match
  RAISE NOTICE 'Exiting: Default case, returning empty result';
  RETURN QUERY
  SELECT null::uuid as item_id, null::text as image_url, null::text as name
  WHERE false;

EXCEPTION
  WHEN others THEN
    RAISE NOTICE 'Error fetching latest outfit for review: %', SQLERRM;
    RETURN;
END;
$$;
