ALTER TABLE public.user_profiles
ADD COLUMN to_delete BOOLEAN NOT NULL DEFAULT FALSE;

COMMENT ON COLUMN public.user_profiles.to_delete IS 'Indicates if the user account is marked for deletion (TRUE = yes, FALSE = no)';

CREATE OR REPLACE FUNCTION notify_delete_user_account()
RETURNS json
SET search_path = ''
AS $$
DECLARE
    current_user_id UUID := auth.uid();
    response json;
BEGIN
  UPDATE public.user_profiles
  SET to_delete = TRUE,
      updated_at = now()
  WHERE id = current_user_id;

  -- Return a success response
  response := json_build_object(
    'status', 'success',
    'message', 'User marked for deletion'
  );

  RETURN response;
EXCEPTION
  WHEN OTHERS THEN
    -- Handle exceptions and return an error response
    response := json_build_object(
      'status', 'error',
      'message', 'Failed to mark user for deletion'
    );
    RETURN response;
END;
$$ LANGUAGE plpgsql;
