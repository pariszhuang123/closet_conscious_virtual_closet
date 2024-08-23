create or replace function public.update_nps_review(
  p_user_id uuid,
  p_nps_score int,
  p_milestone_triggered int
)
returns JSON
LANGUAGE plpgsql
SET search_path = ''
as $$
DECLARE
  result JSON;
BEGIN
  -- Insert or update the NPS score in the user_reviews table
  INSERT INTO public.user_reviews (user_id, nps_score, milestone_triggered)
  VALUES (p_user_id, p_nps_score, p_milestone_triggered);

  -- Return success result
  result := json_build_object(
    'status', 'success',
    'message', 'NPS review updated successfully',
    'nps_score', p_nps_score
  );
  RETURN result;

EXCEPTION
  WHEN OTHERS THEN
    -- Return a failure message
    result := json_build_object(
      'status', 'failure',
      'message', SQLERRM,
      'user_id', p_user_id
    );
    RETURN result;
END;
$$;
