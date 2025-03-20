CREATE OR REPLACE FUNCTION fetch_pending_items(p_current_page INT)
RETURNS TABLE(
  item_id UUID,
  image_url TEXT,
  name TEXT,
  item_type TEXT,
  price_per_wear NUMERIC
)
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
  items_per_page INT;
  offset_val INT;
  current_user_id UUID := auth.uid();
BEGIN

  -- Retrieve user preferences for pagination & sorting
  SELECT
    FLOOR(grid * 1.5 * grid)::INT
  INTO
    items_per_page
  FROM
    public.shared_preferences sp
  WHERE
    sp.user_id = current_user_id;

  offset_val := p_current_page * items_per_page;

  -- Execute dynamic SQL
  RETURN QUERY
    SELECT
      i.item_id,
      i.image_url,
      i.name,
      i.item_type,
      i.price_per_wear
    FROM
      public.items i
    WHERE
      i.is_active = true
      AND i.is_pending = true
      AND i.current_owner_id = current_user_id
      ORDER BY
        i.updated_at DESC, i.item_id -- Stable sort
      OFFSET offset_val LIMIT items_per_page;
END;
$$;


