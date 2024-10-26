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
      and (
        sp.filter = '{}'::jsonb or sp.filter is null
        or (
          (sp.filter->>'item_type' is null or i.item_type = sp.filter->>'item_type')
          and (sp.filter->>'occasion' is null or i.occasion = sp.filter->>'occasion')
          and (sp.filter->>'season' is null or i.season = sp.filter->>'season')
          and (sp.filter->>'colour' is null or i.colour = sp.filter->>'colour')
          and (sp.filter->>'colour_variations' is null or i.colour_variations = sp.filter->>'colour_variations')
          and (sp.filter->>'accessory_type' is null or (i.item_type = 'accessory' and a.accessory_type = sp.filter->>'accessory_type'))
          and (sp.filter->>'clothing_type' is null or (i.item_type = 'clothing' and c.clothing_type = sp.filter->>'clothing_type'))
          and (sp.filter->>'clothing_layer' is null or (i.item_type = 'clothing' and c.clothing_layer = sp.filter->>'clothing_layer'))
          and (sp.filter->>'shoes_type' is null or (i.item_type = 'shoes' and s.shoes_type = sp.filter->>'shoes_type'))
        )
      )
      order by %I %s
      offset %L limit %L
    $sql$,
    sort_column,      -- Injects the validated column name
    sort_direction,   -- Injects the sort direction (ASC or DESC)
    offset_val,
    items_per_page
  );

end;
$$;
