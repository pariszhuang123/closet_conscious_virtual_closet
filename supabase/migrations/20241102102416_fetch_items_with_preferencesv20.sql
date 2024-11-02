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

  -- Retrieve user preferences for pagination and sorting
  select
    floor(grid * 1.5 * grid)::int,  -- Calculate items per page
    sort,                           -- Preferred sort column
    sort_order                      -- Preferred sort direction
  into
    items_per_page,
    sort_column,
    sort_direction
  from
    public.shared_preferences sp
  where
    sp.user_id = current_user_id;

  -- Calculate the offset based on the current page
  offset_val := p_current_page * items_per_page;

  -- Execute the main query with filtering, sorting, and pagination
  return query execute format(
    $sql$
    select
      i.item_id,
      i.image_url,
      i.name,
      i.item_type
    from
      public.items i
    JOIN public.shared_preferences sp ON i.current_owner_id = sp.user_id
    WHERE
      i.status = 'active'
      AND (sp.all_closet OR i.closet_id = sp.closet_id)  -- Apply closet filter
      AND (sp.ignore_item_name OR i.name ILIKE '%%' || sp.item_name || '%%')  -- Optional name filter

      -- Apply filters based on shared preferences JSON if available
      AND (
        sp.filter = '{}'::jsonb OR sp.filter IS NULL  -- No filter applied if JSON is empty
        OR (
          -- Filter by item type
          (sp.filter->'item_type' IS NULL OR i.item_type = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'item_type'))))

          -- Filter by occasion, season, and colour
          AND (sp.filter->'occasion' IS NULL OR i.occasion = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'occasion'))))
          AND (sp.filter->'season' IS NULL OR i.season = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'season'))))
          AND (sp.filter->'colour' IS NULL OR i.colour = ANY(ARRAY(SELECT jsonb_array_elements_text(sp.filter->'colour'))))

          )
        )
      -- Apply sorting with a secondary sort on item_id for stability
      order by i.%I %s, i.item_id
      offset %L limit %L
    $sql$,
    sort_column,      -- Sort column, validated and injected
    sort_direction,   -- Sort direction (ASC or DESC)
    offset_val,
    items_per_page
  );

end;
$$;
