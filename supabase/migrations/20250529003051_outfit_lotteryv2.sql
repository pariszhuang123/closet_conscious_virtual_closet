CREATE OR REPLACE FUNCTION should_show_outfit_lottery( )
RETURNS BOOLEAN
LANGUAGE plpgsql
SET search_path = ''
AS $$
DECLARE
  current_user_id  UUID := auth.uid();
  reviewed_count   INTEGER;

  -- outfit parts
  v_one_piece UUID;
  v_top       UUID;
  v_bottom    UUID;
  v_shoes     UUID;
BEGIN
  -- Step 1: Check reviewed count
  SELECT outfits_reviewed INTO reviewed_count
  FROM public.user_high_freq_stats
  WHERE user_id = current_user_id;

  IF reviewed_count >= 60 THEN
    RETURN FALSE;


  END IF;

  -- Step 2: Try finding one-piece
  SELECT i.item_id INTO v_one_piece
  FROM public.items i
  JOIN public.items_clothing_basic c ON c.item_id = i.id
  WHERE i.item_type = 'clothing'
    AND c.clothing_type = 'onePiece'
    AND i.current_owner_id = current_user_id

  LIMIT 1;

  -- Step 3: If no one-piece, try top and bottom
  IF v_one_piece IS NULL THEN
    SELECT i.item_id INTO v_top
    FROM public.items i
    JOIN public.items_clothing_basic c ON c.item_id = i.item_id
    WHERE i.item_type = 'clothing'
      AND c.clothing_type = 'top'
      AND i.current_owner_id = current_user_id

    LIMIT 1;


    SELECT i.item_id INTO v_bottom
    FROM public.items i
    JOIN public.items_clothing_basic c ON c.item_id = i.item_id
    WHERE i.item_type = 'clothing'
      AND c.clothing_type = 'bottom'
      AND i.current_owner_id = current_user_id

    LIMIT 1;
  END IF;

  -- Step 5: Try to get shoes
  SELECT i.item_id INTO v_shoes
  FROM public.items i
  WHERE i.item_type = 'shoes'
    AND i.current_owner_id = current_user_id

  LIMIT 1;

  -- Step 6: Only return true if a full outfit is possible
  IF (v_one_piece IS NOT NULL AND v_shoes IS NOT NULL)
     OR (v_top IS NOT NULL AND v_bottom IS NOT NULL AND v_shoes IS NOT NULL) THEN
    RETURN TRUE;
  END IF;

  RETURN FALSE;
END;
$$;

CREATE OR REPLACE FUNCTION outfit_lottery(
  p_occasion        TEXT,
  p_season          TEXT,
  p_use_all_closets BOOLEAN DEFAULT FALSE
) RETURNS JSONB
SET search_path = ''
LANGUAGE plpgsql AS $$
DECLARE
  v_current_closet UUID;
  current_user_id  UUID := auth.uid();

  -- core items
  v_one_piece UUID;
  v_top       UUID;
  v_bottom    UUID;
  v_shoes     UUID;

  v_items UUID[];
BEGIN
  -- A. Get current user's closet if needed
  IF NOT p_use_all_closets THEN
    SELECT closet_id INTO v_current_closet
    FROM public.shared_preferences
    WHERE user_id = current_user_id;
  END IF;

  -- B. Pick one_piece (if available)
  SELECT i.item_id INTO v_one_piece
  FROM public.items i
  JOIN public.items_clothing_basic c ON c.item_id = i.item_id
  WHERE i.item_type = 'clothing'
    AND c.clothing_type = 'onePiece'
    AND i.current_owner_id = current_user_id
    AND p_occasion = ANY(i.occasion)
    AND p_season = ANY(i.season)
    AND (p_use_all_closets OR i.closet_id = v_current_closet)
  ORDER BY i.updated_at
  LIMIT 1;

  -- C. Pick top and bottom (if one_piece is not chosen)
  IF v_one_piece IS NULL THEN
    SELECT i.item_id INTO v_top
    FROM public.items i
    JOIN public.items_clothing_basic c ON c.item_id = i.item_id
    WHERE i.item_type = 'clothing'
      AND c.clothing_type = 'top'
      AND i.current_owner_id = current_user_id
      AND p_occasion = ANY(i.occasion)
      AND p_season = ANY(i.season)
      AND (p_use_all_closets OR i.closet_id = v_current_closet)
    ORDER BY i.updated_at, random()
    LIMIT 1;

    SELECT i.item_id INTO v_bottom
    FROM public.items i
    JOIN public.items_clothing_basic c ON c.item_id = i.item_id
    WHERE i.item_type = 'clothing'
      AND c.clothing_type = 'bottom'
      AND i.current_owner_id = current_user_id
      AND p_occasion = ANY(i.occasion)
      AND p_season = ANY(i.season)
      AND (p_use_all_closets OR i.closet_id = v_current_closet)
    ORDER BY i.updated_at, random()
    LIMIT 1;
  END IF;

  -- D. Pick shoes
  SELECT i.item_id INTO v_shoes
  FROM public.items i
  WHERE i.item_type = 'shoes'
    AND i.current_owner_id = current_user_id
    AND p_occasion = ANY(i.occasion)
    AND p_season = ANY(i.season)
    AND (p_use_all_closets OR i.closet_id = v_current_closet)
  ORDER BY i.updated_at, random()
  LIMIT 1;

  -- E. Decide final outfit
  IF v_one_piece IS NOT NULL AND v_shoes IS NOT NULL THEN
    v_items := ARRAY[v_one_piece, v_shoes];
  ELSIF v_top IS NOT NULL AND v_bottom IS NOT NULL AND v_shoes IS NOT NULL THEN
    v_items := ARRAY[v_top, v_bottom, v_shoes];
  ELSE
    RETURN jsonb_build_object(
      'can_create', false,
      'reason', 'Missing core items'
    );
  END IF;

  -- F. Return full JSON for selected items

  UPDATE public.items
  SET updated_at = NOW()
  WHERE item_id = ANY(v_items);

  RETURN (
    SELECT jsonb_build_object(
      'can_create', true,
      'reason',     null,
      'items',      jsonb_agg(jsonb_build_object(
                       'item_id',        i.id,
                       'image_url',      i.image_url,
                       'name',           i.name,
                       'item_type',      i.item_type
                     ))
    )
    FROM public.items i
    WHERE i.item_id = ANY(v_items)
  );
END;
$$;
