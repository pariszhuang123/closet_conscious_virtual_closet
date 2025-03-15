ALTER TABLE public.items
ADD COLUMN is_pending BOOLEAN NOT NULL DEFAULT FALSE;

COMMENT ON COLUMN public.items.is_pending IS 'Indicates where if its True, the item is not still in processing, and not accessible within the closet. Defaults to FALSE.';


CREATE OR REPLACE FUNCTION fetch_items_analytics_with_preferences(p_current_page INT)
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
  sort_column TEXT;
  sort_direction TEXT;
  current_user_id UUID := auth.uid();
BEGIN

  -- Retrieve user preferences for pagination & sorting
  SELECT
    FLOOR(grid * 1.5 * grid)::INT,
    sort,
    sort_order
  INTO
    items_per_page,
    sort_column,
    sort_direction
  FROM
    public.shared_preferences sp
  WHERE
    sp.user_id = current_user_id;

  offset_val := p_current_page * items_per_page;

  -- Execute dynamic SQL
  RETURN QUERY EXECUTE FORMAT(
    $sql$
    SELECT
      i.item_id,
      i.image_url,
      i.name,
      i.item_type,
      i.price_per_wear
    FROM
      public.items i
    LEFT JOIN public.items_accessory_basic a ON i.item_id = a.item_id AND i.item_type = 'accessory'
    LEFT JOIN public.items_clothing_basic c ON i.item_id = c.item_id AND i.item_type = 'clothing'
    LEFT JOIN public.items_shoes_basic s ON i.item_id = s.item_id AND i.item_type = 'shoes'
    JOIN public.shared_preferences sp ON i.current_owner_id = sp.user_id
    WHERE
      i.is_active = true
      AND i.is_pending = false
      AND (sp.all_closet OR i.closet_id = sp.closet_id)  -- Closet filter

      -- ✅ Apply only_unworn filter
      AND (sp.only_unworn = FALSE OR i.worn_in_outfit = 0)

      AND (
          sp.ignore_item_name  -- ✅ Skip name filtering if ignore_item_name is true
          OR (sp.item_name IS NOT NULL AND i.name ILIKE '%%' || sp.item_name || '%%')  -- ✅ Apply filtering only if item_name is provided
      )
      AND (
        sp.filter = '{}'::jsonb OR sp.filter IS NULL
        OR (
          (sp.filter->'item_type' IS NULL OR EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'item_type') elem WHERE elem = i.item_type
          ))
          AND (sp.filter->'occasion' IS NULL OR EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'occasion') elem WHERE elem = i.occasion
          ))
          AND (sp.filter->'season' IS NULL OR EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'season') elem WHERE elem = i.season
          ))
          AND (sp.filter->'colour' IS NULL OR EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'colour') elem WHERE elem = i.colour
          ))
          AND (sp.filter->'colour_variations' IS NULL OR EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'colour_variations') elem WHERE elem = i.colour_variations
          ))
          AND (sp.filter->'accessory_type' IS NULL OR (i.item_type = 'accessory' AND EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'accessory_type') elem WHERE elem = a.accessory_type
          )))
          AND (sp.filter->'clothing_type' IS NULL OR (i.item_type = 'clothing' AND EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'clothing_type') elem WHERE elem = c.clothing_type
          )))
          AND (sp.filter->'clothing_layer' IS NULL OR (i.item_type = 'clothing' AND EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'clothing_layer') elem WHERE elem = c.clothing_layer
          )))
          AND (sp.filter->'shoes_type' IS NULL OR (i.item_type = 'shoes' AND EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'shoes_type') elem WHERE elem = s.shoes_type
          )))
        )
      )
      ORDER BY i.%I %s, i.item_id -- Stable sorting with item_id as a secondary criterion
      OFFSET %L LIMIT %L
    $sql$,
    sort_column,      -- Injects the validated column name
    sort_direction,   -- Injects the sort direction (ASC or DESC)
    offset_val,
    items_per_page
  );

END;
$$;


CREATE OR REPLACE FUNCTION fetch_outfit_items_with_preferences(
  p_current_page INT,
  p_category TEXT
)
RETURNS TABLE(
  item_id UUID,
  image_url TEXT,
  name TEXT,
  item_type TEXT
)
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
  items_per_page INT;
  offset_val INT;
  sort_column TEXT;
  sort_direction TEXT;
  current_user_id UUID := auth.uid();
BEGIN

  -- Calculate items per page and offset based on user preferences
  SELECT
    FLOOR(grid * 1.5 * grid)::INT,  -- Use floor to avoid rounding up
    sort,
    sort_order
  INTO
    items_per_page,
    sort_column,
    sort_direction
  FROM
    public.shared_preferences sp
  WHERE
    sp.user_id = current_user_id;

  -- Standard offset calculation
  offset_val := p_current_page * items_per_page;

  -- Execute dynamic SQL for sorting, pagination, and filtering
  RETURN QUERY EXECUTE FORMAT(
    $sql$
    SELECT
      i.item_id,
      i.image_url,
      i.name,
      i.item_type
    FROM
      public.items i
    LEFT JOIN public.items_accessory_basic a ON i.item_id = a.item_id AND i.item_type = 'accessory'
    LEFT JOIN public.items_clothing_basic c ON i.item_id = c.item_id AND i.item_type = 'clothing'
    LEFT JOIN public.items_shoes_basic s ON i.item_id = s.item_id AND i.item_type = 'shoes'
    JOIN public.shared_preferences sp ON i.current_owner_id = sp.user_id
    WHERE
      i.is_active = true
      AND i.is_pending = false
      AND i.item_type = %L  -- Mandatory category filter
      AND (sp.all_closet OR i.closet_id = sp.closet_id)  -- Closet filter
      AND (sp.only_unworn = FALSE OR i.worn_in_outfit = 0)
      AND (
          sp.ignore_item_name
          OR (sp.item_name IS NOT NULL AND i.name ILIKE '%%' || sp.item_name || '%%')
      )
      AND (
        sp.filter = '{}'::jsonb OR sp.filter IS NULL
        OR (
          (sp.filter->'item_type' IS NULL OR EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'item_type') elem WHERE elem = i.item_type
          ))
          AND (sp.filter->'occasion' IS NULL OR EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'occasion') elem WHERE elem = i.occasion
          ))
          AND (sp.filter->'season' IS NULL OR EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'season') elem WHERE elem = i.season
          ))
          AND (sp.filter->'colour' IS NULL OR EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'colour') elem WHERE elem = i.colour
          ))
          AND (sp.filter->'colour_variations' IS NULL OR EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'colour_variations') elem WHERE elem = i.colour_variations
          ))
          AND (sp.filter->'accessory_type' IS NULL OR (i.item_type = 'accessory' AND EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'accessory_type') elem WHERE elem = a.accessory_type
          )))
          AND (sp.filter->'clothing_type' IS NULL OR (i.item_type = 'clothing' AND EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'clothing_type') elem WHERE elem = c.clothing_type
          )))
          AND (sp.filter->'clothing_layer' IS NULL OR (i.item_type = 'clothing' AND EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'clothing_layer') elem WHERE elem = c.clothing_layer
          )))
          AND (sp.filter->'shoes_type' IS NULL OR (i.item_type = 'shoes' AND EXISTS (
              SELECT 1 FROM jsonb_array_elements_text(sp.filter->'shoes_type') elem WHERE elem = s.shoes_type
          )))
        )
      )
      ORDER BY i.%I %s, i.item_id -- Stable sorting with item_id as secondary criterion
      OFFSET %L LIMIT %L
    $sql$,
    p_category,      -- Injects the validated category filter
    sort_column,      -- Injects the validated column name
    sort_direction,   -- Injects the sort direction (ASC or DESC)
    offset_val,
    items_per_page
  );

END;
$$;


create or replace function get_filtered_item_summary()
returns table (
    total_items int,
    total_item_cost numeric,
    avg_price_per_wear numeric
)
language plpgsql
set search_path = ''
as $$
declare
    current_user_id uuid := auth.uid();  -- Standardized for all RPCs
begin
    return query
    with filtered_items as (
        select
            i.item_id,
            i.amount_spent,
            i.worn_in_outfit
        from
            public.items i
        LEFT JOIN public.items_accessory_basic a ON i.item_id = a.item_id AND i.item_type = 'accessory'
        LEFT JOIN public.items_clothing_basic c ON i.item_id = c.item_id AND i.item_type = 'clothing'
        LEFT JOIN public.items_shoes_basic s ON i.item_id = s.item_id AND i.item_type = 'shoes'
        JOIN public.shared_preferences sp ON i.current_owner_id = sp.user_id
        WHERE
            i.is_active = true
            AND i.is_pending = false
            AND i.current_owner_id = current_user_id  -- Use standardized user ID
            and (sp.all_closet OR i.closet_id = sp.closet_id)  -- Closet filter
            AND (sp.only_unworn = FALSE OR i.worn_in_outfit = 0)
       AND (
          sp.ignore_item_name  -- ✅ Skip name filtering if ignore_item_name is true
          OR (sp.item_name IS NOT NULL AND i.name ILIKE '%%' || sp.item_name || '%%')  -- ✅ Apply filtering only if item_name is provided
      )
            AND (
                sp.filter = '{}'::jsonb OR sp.filter IS NULL
                OR (
                    (sp.filter->'item_type' IS NULL OR EXISTS (
                        SELECT 1 FROM jsonb_array_elements_text(sp.filter->'item_type') elem WHERE elem = i.item_type
                    ))
                    AND (sp.filter->'occasion' IS NULL OR EXISTS (
                        SELECT 1 FROM jsonb_array_elements_text(sp.filter->'occasion') elem WHERE elem = i.occasion
                    ))
                    AND (sp.filter->'season' IS NULL OR EXISTS (
                        SELECT 1 FROM jsonb_array_elements_text(sp.filter->'season') elem WHERE elem = i.season
                    ))
                    AND (sp.filter->'colour' IS NULL OR EXISTS (
                        SELECT 1 FROM jsonb_array_elements_text(sp.filter->'colour') elem WHERE elem = i.colour
                    ))
                    AND (sp.filter->'colour_variations' IS NULL OR EXISTS (
                        SELECT 1 FROM jsonb_array_elements_text(sp.filter->'colour_variations') elem WHERE elem = i.colour_variations
                    ))
                    AND (sp.filter->'accessory_type' IS NULL OR (i.item_type = 'accessory' AND EXISTS (
                        SELECT 1 FROM jsonb_array_elements_text(sp.filter->'accessory_type') elem WHERE elem = a.accessory_type
                        ))
                    )
                    AND (sp.filter->'clothing_type' IS NULL OR (i.item_type = 'clothing' AND EXISTS (
                        SELECT 1 FROM jsonb_array_elements_text(sp.filter->'clothing_type') elem WHERE elem = c.clothing_type
                        ))
                    )
                    AND (sp.filter->'clothing_layer' IS NULL OR (i.item_type = 'clothing' AND EXISTS (
                        SELECT 1 FROM jsonb_array_elements_text(sp.filter->'clothing_layer') elem WHERE elem = c.clothing_layer
                        ))
                    )
                    AND (sp.filter->'shoes_type' IS NULL OR (i.item_type = 'shoes' AND EXISTS (
                        SELECT 1 FROM jsonb_array_elements_text(sp.filter->'shoes_type') elem WHERE elem = s.shoes_type
                    ))
                )
            )
        )
    )
    select
        coalesce(count(item_id)::int, 0) as total_items,
        coalesce(sum(amount_spent), 0) as total_item_cost,
        coalesce(
            case
                when sum(worn_in_outfit) > 0
                then sum(amount_spent) / sum(worn_in_outfit)
                else 0
            end, 0
        ) as avg_price_per_wear
    from filtered_items;
end;
$$;


-- Function to edit_item_metadata
create or replace function public.edit_item_metadata(
  _item_id uuid,
  _item_type text,
  _name text,
  _amount_spent numeric,
  _occasion text,
  _season text,
  _colour text,
  _clothing_type text,
  _clothing_layer text,
  _accessory_type text,
  _shoes_type text,
  _colour_variations text default 'cc_none'  -- Keep the default here
)
returns json
language plpgsql
SET search_path = ''
as $$
declare
  result json;  -- Declare the variable here
  current_user_id UUID := auth.uid();
begin

  -- Ensure _colour_variations defaults to 'cc_none' if NULL or empty string is passed
  if _colour_variations is null or _colour_variations = '' then
    _colour_variations := 'cc_none';
  end if;

update public.shared_preferences
    set
        sort = 'updated_at',
        sort_order = 'DESC'
    where user_id = current_user_id
    and (sort != 'updated_at' or sort_order != 'DESC');

  -- Update the general items table
  update public.items
  set
    item_type = _item_type,
    name = _name,
    amount_spent = _amount_spent,
    occasion = _occasion,
    season = _season,
    colour = _colour,
    colour_variations = _colour_variations,  -- Now will never be NULL
    is_pending = false,
    updated_at = NOW()
  where item_id = _item_id
    AND current_owner_id = current_user_id;

  -- Handle type-specific updates based on the new item type
  if _item_type = 'clothing' then
    -- Upsert into items_clothing_basic
    insert into public.items_clothing_basic (item_id, clothing_type, clothing_layer)
    values (_item_id, _clothing_type, _clothing_layer)
    on conflict (item_id)
    do update set clothing_type = excluded.clothing_type, clothing_layer = excluded.clothing_layer;

    -- Optional: Clean up previous accessory/shoes-specific data
    delete from public.items_accessory_basic where item_id = _item_id;
    delete from public.items_shoes_basic where item_id = _item_id;

  elsif _item_type = 'accessory' then
    -- Upsert into items_accessory_basic
    insert into public.items_accessory_basic (item_id, accessory_type)
    values (_item_id, _accessory_type)
    on conflict (item_id)
    do update set accessory_type = excluded.accessory_type;

    -- Clean up previous clothing/shoes-specific data
    delete from public.items_clothing_basic where item_id = _item_id;
    delete from public.items_shoes_basic where item_id = _item_id;

  elsif _item_type = 'shoes' then
    -- Upsert into items_shoes_basic
    insert into public.items_shoes_basic (item_id, shoes_type)
    values (_item_id, _shoes_type)
    on conflict (item_id)
    do update set shoes_type = excluded.shoes_type;

    -- Clean up previous clothing/accessory-specific data
    delete from public.items_clothing_basic where item_id = _item_id;
    delete from public.items_accessory_basic where item_id = _item_id;
  end if;

  -- Assign success response
  result := json_build_object(
        'status', 'success'
    );

  -- Return the result
  return result;

exception
  when others then
    -- Handle any errors
    return json_build_object('status', 'error', 'message', SQLERRM);
end;
$$;
