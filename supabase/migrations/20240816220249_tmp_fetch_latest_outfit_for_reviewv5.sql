CREATE OR REPLACE FUNCTION public.tmp_fetch_latest_outfit_for_review(feedback TEXT)
RETURNS TABLE(item_id UUID, outfit_image_url TEXT)
LANGUAGE plpgsql
SET search_path = ''
AS $$
DECLARE
  current_user_id UUID := auth.uid();
  outfit_image_url TEXT;
  outfit_id UUID;
BEGIN
  -- Fetch the outfit_id and outfit_image_url with the earliest updated_at where reviewed is false for the current user
  RETURN QUERY
  SELECT outfit_id, outfit_image_url
  FROM public.outfits
  WHERE reviewed = false
    AND user_id = 'f702e41a-62b1-4360-812b-f6cfe9fbdc77'
  ORDER BY updated_at ASC
  LIMIT 1;

EXCEPTION
  WHEN others THEN
    RAISE NOTICE 'Error fetching latest outfit for review: %', SQLERRM;
    RETURN;
END;
$$;
