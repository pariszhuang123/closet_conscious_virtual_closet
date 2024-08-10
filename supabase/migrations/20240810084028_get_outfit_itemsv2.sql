CREATE OR REPLACE FUNCTION public.get_outfit_items(outfit_id UUID)
RETURNS TABLE(item_id UUID, image_url text, name text)
SET search_path = ''
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT i.item_id, i.image_url, i.name
  FROM public.outfit_items oi
  JOIN public.items i ON oi.item_id = i.item_id
  WHERE oi.outfit_id = get_outfit_items.outfit_id;  -- Using function's parameter
END;
$$;
