ALTER TABLE public.shared_preferences
ADD COLUMN personalization_flow_type TEXT NOT NULL DEFAULT 'default_flow'
CHECK (personalization_flow_type IN (
  'default_flow',
  'memory_flow',
  'personal_style_flow',
  'life_change_flow'
));

COMMENT ON COLUMN public.shared_preferences.personalization_flow_type IS
  'Specifies the type of personalization flow the user is in. Options: default_flow, memory_flow, personal_style_flow, life_change_flow.';


CREATE OR REPLACE FUNCTION fetch_daily_outfits(f_outfit_id UUID DEFAULT NULL)
RETURNS JSONB
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id UUID := auth.uid();
    f_focused_date DATE;
    has_previous_outfits BOOLEAN;
    has_next_outfits BOOLEAN;
    f_ignore_event_name BOOLEAN;
    f_event_name_filter TEXT;
    f_feedback_filter TEXT;
    f_is_outfit_active_filter TEXT;
    result JSONB;
BEGIN
    ----------------------------------------------------------------------------
    -- Step 1: Fetch the focused date and user preferences from shared_preferences
    ----------------------------------------------------------------------------
    SELECT
        sp.focused_date,
        sp.ignore_event_name,
        sp.event_name,
        sp.feedback,
        sp.is_outfit_active
    INTO f_focused_date, f_ignore_event_name, f_event_name_filter, f_feedback_filter, f_is_outfit_active_filter
    FROM public.shared_preferences sp
    WHERE sp.user_id = current_user_id
    LIMIT 1;

    ----------------------------------------------------------------------------
    -- Step 2: Create a temporary filtered outfits table
    ----------------------------------------------------------------------------
    DROP TABLE IF EXISTS temp_filtered_outfits;

    CREATE TEMP TABLE temp_filtered_outfits AS
    SELECT
        o.*,
        o.created_at::DATE AS created_day,
        o.created_at::DATE = f_focused_date AS has_outfit_on_date
    FROM public.outfits o
    WHERE o.reviewed = true
      AND o.user_id = current_user_id
      AND (
          f_ignore_event_name
          OR (o.event_name ILIKE '%' || COALESCE(f_event_name_filter, '') || '%')
      )
      AND (
          f_feedback_filter = 'all'
          OR o.feedback = f_feedback_filter
      )
      AND (
          f_is_outfit_active_filter = 'all'
          OR (f_is_outfit_active_filter = 'active' AND o.is_active = true)
          OR (f_is_outfit_active_filter = 'inactive' AND o.is_active = false)
      );

    ----------------------------------------------------------------------------
    -- Step 3: Determine has_previous_outfits and has_next_outfits
    ----------------------------------------------------------------------------
    SELECT
        EXISTS (SELECT 1 FROM temp_filtered_outfits WHERE created_day < f_focused_date LIMIT 1),
        EXISTS (SELECT 1 FROM temp_filtered_outfits WHERE created_day > f_focused_date LIMIT 1)
    INTO has_previous_outfits, has_next_outfits;

    ----------------------------------------------------------------------------
    -- Step 4: Fetch daily outfits using JSON aggregation
    ----------------------------------------------------------------------------
    SELECT JSONB_AGG(
        JSONB_BUILD_OBJECT(
            'outfit_id', opd.outfit_id,
            'feedback', opd.feedback,
            'reviewed', opd.reviewed,
            'is_active', opd.is_active,
            'outfit_image_url', opd.outfit_image_url,
            'event_name', opd.event_name,
            'outfit_comments', opd.outfit_comments,
            'items', COALESCE(di.items, '[]'::JSONB)  -- Precomputed item aggregation
        )
    )
    INTO result
    FROM (
        SELECT
            o.outfit_id,
            o.feedback,
            o.reviewed,
            o.is_active,
            o.outfit_image_url,
            o.event_name,
            o.outfit_comments,
            o.updated_at
        FROM temp_filtered_outfits o
        WHERE created_day = f_focused_date
        ORDER BY o.updated_at DESC
    ) opd
    LEFT JOIN (
        SELECT
            oi.outfit_id,
            JSONB_AGG(
                JSONB_BUILD_OBJECT(
                    'item_id', i.item_id,
                    'image_url', i.image_url,
                    'name', i.name,
                    'item_is_active', i.is_active,
                    'is_disliked', oi.disliked
                )
            ) AS items  -- ✅ Aggregating items separately
        FROM public.outfit_items oi
        JOIN public.items i ON oi.item_id = i.item_id
        WHERE i.current_owner_id = current_user_id
        GROUP BY oi.outfit_id  -- ✅ Ensure this groups properly
    ) di
    ON opd.outfit_id = di.outfit_id;


    ----------------------------------------------------------------------------
    -- Step 5: Drop temporary table and return JSON response
    ----------------------------------------------------------------------------
    DROP TABLE IF EXISTS temp_filtered_outfits;

    RETURN JSONB_BUILD_OBJECT(
        'status', 'success',
        'focused_date', f_focused_date,
        'has_previous_outfits', has_previous_outfits,
        'has_next_outfits', has_next_outfits,
        'outfits', result
    );
END;
$$;

CREATE OR REPLACE FUNCTION public.edit_multi_closet(
    p_closet_id uuid DEFAULT NULL, -- Optional closet ID
    p_closet_name text DEFAULT NULL,
    p_closet_type text DEFAULT NULL,
    p_valid_date text DEFAULT NULL,
    p_is_public boolean DEFAULT NULL,
    p_item_ids uuid[] DEFAULT NULL, -- Optional array
    p_new_closet_id uuid DEFAULT NULL
)
RETURNS json
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id uuid := auth.uid(); -- Authenticated user
BEGIN
    -- First Guard Clause: Skip if closet_id is NULL
    IF p_closet_id IS NULL THEN
        RAISE NOTICE 'Skipping closet update: closet_id is NULL.';
    ELSE
        -- Update closet metadata only for provided fields
        UPDATE public.user_closets
        SET
            closet_name = COALESCE(p_closet_name, closet_name), -- Update only if provided
            type = COALESCE(p_closet_type, type),               -- Update only if provided
            valid_date = CASE
                WHEN p_closet_type = 'disappear' AND p_valid_date IS NOT NULL THEN p_valid_date::timestamptz
                ELSE valid_date -- Retain existing value
            END,
            is_public = CASE
                WHEN p_is_public IS NOT NULL THEN p_is_public -- Update to the provided value (TRUE or FALSE)
                ELSE is_public -- Retain the current value if no input is provided (NULL)
            END,
            updated_at = NOW()
        WHERE closet_id = p_closet_id
          AND user_id = current_user_id;

        RAISE NOTICE 'Closet updated successfully for closet_id %.', p_closet_id;
    END IF;

    -- Second Guard Clause: Skip if p_item_ids or p_new_closet_id is NULL
    IF p_item_ids IS NULL OR p_new_closet_id IS NULL THEN
        RAISE NOTICE 'Skipping item transfer: Missing item IDs or new closet ID.';
    ELSE
        -- Transfer items to a new closet
        UPDATE public.items
        SET
            closet_id = p_new_closet_id,
            updated_at = NOW()
        WHERE item_id = ANY(p_item_ids)
          AND current_owner_id = current_user_id;

        RAISE NOTICE 'Items transferred successfully to new closet_id %.', p_new_closet_id;
    END IF;

    IF p_new_closet_id IS NOT NULL THEN
        UPDATE public.shared_preferences
        SET closet_id = p_new_closet_id,
            updated_at = NOW()
        WHERE user_id = current_user_id;

        RAISE NOTICE 'Shared preferences updated with new closet_id %.', p_new_closet_id;
    END IF;

    -- Return success JSON
    RETURN json_build_object(
        'status', 'success',
        'message', 'Closet and items updated successfully.',
        'closet_id', p_closet_id
    );
END;
$$;

create or replace function track_tutorial_interaction(tutorial_input text)
returns boolean
language plpgsql
set search_path = ''
as $$
declare
  current_user_id uuid := auth.uid();
  tutorial_type_value text;
  personalization_flow_value text;
  exists_already boolean;
begin
  -- Determine the tutorial_type based on the tutorial_input
  case tutorial_input
    when 'free_upload_camera', 'free_upload_photo_library', 'free_edit_camera',
         'free_create_outfit', 'free_closet_upload', 'free_info_hub'
      then tutorial_type_value := 'free';

    when 'paid_filter', 'paid_customize', 'paid_multi_closet',
         'paid_calendar', 'paid_usage_analytics'
      then tutorial_type_value := 'paid';

    when 'flow_intro_default', 'flow_intro_memory',
         'flow_intro_personal_style', 'flow_intro_life_change'
      then tutorial_type_value := 'scenario';

    else
      raise exception 'Unknown tutorial name: %', tutorial_input;
  end case;

  if tutorial_type_value = 'scenario' then
    case tutorial_input
      when 'flow_intro_default' then personalization_flow_value := 'default_flow';
      when 'flow_intro_memory' then personalization_flow_value := 'memory_flow';
      when 'flow_intro_personal_style' then personalization_flow_value := 'personal_style_flow';
      when 'flow_intro_life_change' then personalization_flow_value := 'life_change_flow';
      else
        raise exception 'Missing personalization flow mapping for: %', tutorial_input;
    end case;
  end if;

  -- Check if the tutorial_progress record exists
  select exists (
    select 1 from public.tutorial_progress
    where user_id = current_user_id and tutorial_name = tutorial_input
  ) into exists_already;

  if exists_already then
    update public.tutorial_progress
    set interaction_count = interaction_count + 1,
        updated_at = now()
    where user_id = current_user_id and tutorial_name = tutorial_input;

  else
    insert into public.tutorial_progress (user_id, tutorial_name, tutorial_type, , interaction_count)
    values (current_user_id, tutorial_input, tutorial_type_value, 1);
  end if;

  -- If it's a personalization flow, update shared_preferences
  if tutorial_type_value = 'scenario' then
    update public.shared_preferences
    set personalization_flow_type = personalization_flow_value,
        updated_at = now()
    where user_id = current_user_id
      and personalization_flow_type is distinct from personalization_flow_value;
  end if;

  return exists_already;
end;
$$;
