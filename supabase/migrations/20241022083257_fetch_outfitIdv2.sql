create or replace function public.fetch_outfitId(
  p_user_id uuid
)
returns JSON
LANGUAGE plpgsql
SET search_path = ''
as $$
DECLARE
  v_outfit_id uuid;
  v_event_name text;
  result JSON;
BEGIN
  -- Select the outfit_id and event_name based on the specified criteria
  SELECT outfits.outfit_id, outfits.event_name
  INTO v_outfit_id, v_event_name
  FROM public.outfits
  INNER JOIN public.user_high_freq_stats
        ON outfits.user_id = user_high_freq_stats.user_id
  WHERE outfits.reviewed = false
    AND outfits.user_id = p_user_id
    AND user_high_freq_stats.daily_upload = false
  ORDER BY outfits.updated_at ASC
  LIMIT 1;

  -- Construct the result as a JSON object
  IF v_outfit_id IS NOT NULL THEN
    result := json_build_object(
      'status', 'success',
      'message', 'Successfully obtained outfit_id and event_name',
      'outfit_id', v_outfit_id,
      'event_name', COALESCE(v_event_name, 'cc_none') -- Default to 'cc_none' if null
    );
  ELSE
    result := json_build_object(
      'status', 'failure',
      'message', 'No outfit found for the given criteria'
    );
  END IF;

  RETURN result;

EXCEPTION
  WHEN OTHERS THEN
    result := json_build_object(
      'status', 'error',
      'message', SQLERRM
    );
    RETURN result;
END;
$$;
