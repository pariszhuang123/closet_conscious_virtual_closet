-- Add a new column to the shared_preferences table
ALTER TABLE public.shared_preferences
ADD COLUMN item_name text NOT NULL DEFAULT 'cc_none',
ADD COLUMN ignore_item_name BOOLEAN NOT NULL DEFAULT TRUE;

-- Add a comment to the new column
COMMENT ON COLUMN public.shared_preferences.item_name IS 'Stores the name of the item. Default value is "cc_none", used when no specific name is provided.';
COMMENT ON COLUMN public.shared_preferences.ignore_item_name IS 'Indicates whether the item name should be excluded from filters. Default is TRUE, meaning item name filtering is typically not active unless set to FALSE.';


create or replace function fetch_items_with_preferences(p_current_page int)
returns table(
  item_id uuid,
  image_url text,
  name text,
  item_type text
)
SET search_path = ''
language plpgsql
as $$
declare
  items_per_page int;
  offset_val int;
  sort_column text;
  sort_direction text;
  current_user_id uuid := auth.uid();

begin

  -- Calculate items per page and offset based on user preferences
  select
    grid * grid, sort, sort_order
  into
    items_per_page, sort_column, sort_direction
  from
    public.shared_preferences sp
  where
    sp.user_id = current_user_id;

  offset_val := p_current_page * items_per_page;

-- Execute dynamic SQL for sorting and pagination
return query execute format(
  $sql$
    select
      i.item_id,
      i.image_url,
      i.name,
      i.item_type
    from
      public.items i
    left join public.items_accessory_basic a on i.item_id = a.item_id and i.item_type = 'accessory'
    left join public.items_clothing_basic c on i.item_id = c.item_id and i.item_type = 'clothing'
    left join public.items_shoes_basic s on i.item_id = s.item_id and i.item_type = 'shoes'
    join public.shared_preferences sp on i.current_owner_id = sp.user_id
    where
      i.status = 'active'
      and (sp.all_closet OR i.closet_id = sp.closet_id)  -- Closet filter
      and (sp.ignore_item_name OR i.name ILIKE '%%' || sp.item_name || '%%')
      and (
        sp.filter = '{}'::jsonb or sp.filter is null
        or (
          (sp.filter->'item_type' IS NULL OR i.item_type = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'item_type'))))
          AND (sp.filter->'occasion' IS NULL OR i.occasion = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'occasion'))))
          AND (sp.filter->'season' IS NULL OR i.season = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'season'))))
          AND (sp.filter->'colour' IS NULL OR i.colour = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'colour'))))
          AND (sp.filter->'colour_variations' IS NULL OR i.colour_variations = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'colour_variations'))))
          AND (sp.filter->'accessory_type' IS NULL OR (i.item_type = 'accessory' AND a.accessory_type = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'accessory_type')))))
          AND (sp.filter->'clothing_type' IS NULL OR (i.item_type = 'clothing' AND c.clothing_type = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'clothing_type')))))
          AND (sp.filter->'clothing_layer' IS NULL OR (i.item_type = 'clothing' AND c.clothing_layer = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'clothing_layer')))))
          AND (sp.filter->'shoes_type' IS NULL OR (i.item_type = 'shoes' AND s.shoes_type = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'shoes_type')))))
        )
      )
      order by i.%I %s
      offset %L limit %L
    $sql$,
    sort_column,      -- Injects the validated column name
    sort_direction,   -- Injects the sort direction (ASC or DESC)
    offset_val,
    items_per_page
  );

end;
$$;
